//
//  HomeView.swift
//  FinTech
//
//  Created by Şükrü Şimşek on 21.03.2024.
//

import UIKit
import SwiftUI


protocol HomeViewInterface: AnyObject {
    func configureVC()
    func configureLabels()
    func reloadView()
    func configurePickerView()
    func updateUI()
    func configureChart()
    
}

final class HomeView: UIViewController,ObservableObject {
    private let viewModel = HomeViewModel()
    private let labelForStockPrice = UILabel()
    private let labelForSymbol = UILabel()
    private let labelForPreviousClose = UILabel()
    private let labelHasPrePostMarketData = UILabel()
    private var isReloaded = false
    private let pickerView = UIPickerView()
    private let chooseStocksInPicker = UIButton()
    private let pickerViewContainer = UIView()
    var stockClosePrice = [Double]()
    let stockPrice = StockPrice()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
        
    }
}

extension HomeView: HomeViewInterface, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataForStocks.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataForStocks[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.selectRow(row, inComponent: component, animated: true)
        let selectedData = dataForStocks[row]
        viewModel.updateSelectedData(selectedData)
        
    }
    
    func updateUI() {
        guard let stockInfo = viewModel.stockInfo else { return }
        labelForSymbol.text = stockInfo.symbol
        labelForStockPrice.text = "\(String(describing: stockInfo.regularMarketPrice))"
        labelForSymbol.text = stockInfo.symbol
        labelForStockPrice.text = "\(String(describing: stockInfo.regularMarketPrice )) \(String(describing: stockInfo.currency ))"
        labelForPreviousClose.text = "\(stockInfo.previousClose)"
        if stockInfo.hasPrePostMarketData == true {
            labelHasPrePostMarketData.text = " Closed Market "
            labelHasPrePostMarketData.backgroundColor = .systemRed
            labelHasPrePostMarketData.layer.cornerRadius = 5
            labelHasPrePostMarketData.layer.masksToBounds = true
        } else {
            labelHasPrePostMarketData.text = " Open Market "
            labelHasPrePostMarketData.backgroundColor = .systemGreen
            labelHasPrePostMarketData.layer.cornerRadius = 5
            labelHasPrePostMarketData.layer.masksToBounds = true
        }
        for i in 0..<stockInfo.closePrice.count {
            let innerArray = stockInfo.closePrice[i]
            for optionalDouble in innerArray {
                if let doubleValue = optionalDouble {
                    stockClosePrice.append(doubleValue)
                }
            }
            stockPrice.stockPrice = stockClosePrice
            stockPrice.stockName = labelForSymbol.text
//            print("Deneme Dataları: ",stockClosePrice)
        }
        stockClosePrice.removeAll()
        viewModel.updateStockInfo(with: stockInfo)
        
    }
    func configureChart() {
        let controller = UIHostingController(rootView: LineCharts().environmentObject(stockPrice))
        guard let priceView = controller.view else {
            return
        }
        priceView.backgroundColor = .clear
        priceView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(priceView)
        
        NSLayoutConstraint.activate([
            priceView.topAnchor.constraint(equalTo: chooseStocksInPicker.bottomAnchor, constant: 10),
            priceView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            priceView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            priceView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35)
        ])
//        stockPrice.stockPrice.removeAll()
//        stockPrice.stockName?.removeAll()
        
    }
    func configureVC() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        print(dataForStocks.count)//Stock count in pickerView
    }
    func reloadView() {
        updateUI()
        pickerViewContainer.isHidden = true
    }
    func configureLabels() {
        labelForStockPrice.translatesAutoresizingMaskIntoConstraints = false
        labelForStockPrice.textColor = .white
        labelForStockPrice.text = "\(String(describing: viewModel.stockInfo?.regularMarketPrice ?? .zero)) \(String(describing: viewModel.stockInfo?.currency ?? "Unknown"))"
        labelForStockPrice.font = .systemFont(ofSize: 32, weight: .semibold)
        
        view.addSubview(labelForStockPrice)
        labelForSymbol.translatesAutoresizingMaskIntoConstraints = false
        labelForSymbol.textColor = .white
        labelForSymbol.text = "\(String(describing: viewModel.stockInfo?.symbol ?? "Unknown"))"
        labelForSymbol.font = .systemFont(ofSize: 36, weight: .semibold)
        view.addSubview(labelForSymbol)
        
        labelForPreviousClose.translatesAutoresizingMaskIntoConstraints = false
        labelForPreviousClose.textColor = .white
        labelForPreviousClose.text = "Previous Price: \(viewModel.stockInfo?.previousClose ?? .zero)"
        labelForPreviousClose.font = .systemFont(ofSize: 15, weight: .semibold)
        view.addSubview(labelForPreviousClose)
        
        labelHasPrePostMarketData.translatesAutoresizingMaskIntoConstraints = false
        labelHasPrePostMarketData.textColor = .secondaryLabel
        labelHasPrePostMarketData.font = .systemFont(ofSize: 12, weight: .semibold)
        if viewModel.stockInfo?.hasPrePostMarketData == true {
            labelHasPrePostMarketData.text = " Closed Market "
            labelHasPrePostMarketData.backgroundColor = .systemRed
            labelHasPrePostMarketData.layer.cornerRadius = 5
            labelHasPrePostMarketData.layer.masksToBounds = true
        } else {
            labelHasPrePostMarketData.text = " Open Market "
            labelHasPrePostMarketData.backgroundColor = .systemGreen
            labelHasPrePostMarketData.layer.cornerRadius = 5
            labelHasPrePostMarketData.layer.masksToBounds = true
        }
        labelForSymbol.addSubview(labelHasPrePostMarketData)
        
        NSLayoutConstraint.activate([
            labelForSymbol.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            labelForSymbol.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            labelForSymbol.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            
            labelForStockPrice.topAnchor.constraint(equalTo: labelForSymbol.bottomAnchor, constant: 20),
            labelForStockPrice.leadingAnchor.constraint(equalTo: labelForSymbol.leadingAnchor),
            labelForStockPrice.trailingAnchor.constraint(equalTo: labelForSymbol.trailingAnchor),
            
            labelForPreviousClose.topAnchor.constraint(equalTo: labelForStockPrice.bottomAnchor, constant: 20),
            labelForPreviousClose.leadingAnchor.constraint(equalTo: labelForStockPrice.leadingAnchor),
            labelForPreviousClose.trailingAnchor.constraint(equalTo: labelForStockPrice.trailingAnchor),
            
            labelHasPrePostMarketData.topAnchor.constraint(equalTo: labelForSymbol.topAnchor, constant: 10),
            labelHasPrePostMarketData.trailingAnchor.constraint(equalTo: labelForStockPrice.trailingAnchor),
            
        ])
        
    }
    func configurePickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerViewContainer.translatesAutoresizingMaskIntoConstraints = false
        chooseStocksInPicker.translatesAutoresizingMaskIntoConstraints = false
        
        pickerViewContainer.isHidden = true
        pickerViewContainer.backgroundColor = .lightGray
        
        chooseStocksInPicker.setTitle("Choose Stock", for: .normal)
        chooseStocksInPicker.setTitleColor(.white, for: .normal)
        chooseStocksInPicker.tintColor = .systemBlue
        chooseStocksInPicker.backgroundColor = .lightGray
        chooseStocksInPicker.setTitleColor(.black, for: .normal)
        chooseStocksInPicker.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        chooseStocksInPicker.addTarget(self, action: #selector(tappedChooseStock), for: .touchUpInside)
        view.addSubview(chooseStocksInPicker)
        view.addSubview(pickerViewContainer)
        pickerViewContainer.bounds = pickerView.bounds
        pickerViewContainer.addSubview(pickerView)
        NSLayoutConstraint.activate([
            chooseStocksInPicker.topAnchor.constraint(equalTo: labelForPreviousClose.bottomAnchor, constant: 10),
            chooseStocksInPicker.leadingAnchor.constraint(equalTo: labelForSymbol.leadingAnchor),
            
            pickerView.centerXAnchor.constraint(equalTo: pickerViewContainer.centerXAnchor),
            pickerViewContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            pickerViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pickerViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pickerViewContainer.heightAnchor.constraint(equalToConstant: view.frame.size.width/2),
            
        ])
    }
    @objc func tappedChooseStock() {
        print("tappedChooseStock")
        pickerViewContainer.isHidden = false
    }
}
