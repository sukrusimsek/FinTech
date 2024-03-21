//
//  HomeView.swift
//  FinTech
//
//  Created by Şükrü Şimşek on 21.03.2024.
//

import UIKit

protocol HomeViewInterface: AnyObject {
    func configureVC()
    func configureLabels()
    func reloadView()
}

final class HomeView: UIViewController {
    private let viewModel = HomeViewModel()
    private let labelForStockPrice = UILabel()
    private let labelForSymbol = UILabel()
    private let labelForPreviousClose = UILabel()
    private let labelHasPrePostMarketData = UILabel()
    private var isReloaded = false
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
        
        
    }
}

extension HomeView: HomeViewInterface {
    func configureVC() {
        view.backgroundColor = .white
        
    }
    func reloadView() {
        guard !isReloaded else { return }
        isReloaded = true
        viewDidLoad()
    }
    func configureLabels() {
        labelForStockPrice.translatesAutoresizingMaskIntoConstraints = false
        labelForStockPrice.text = "\(String(describing: viewModel.stockInfo?.regularMarketPrice ?? .zero)) \(String(describing: viewModel.stockInfo?.currency ?? "Unknown"))"
        labelForStockPrice.font = .systemFont(ofSize: 32, weight: .semibold)
        
        view.addSubview(labelForStockPrice)
        labelForSymbol.translatesAutoresizingMaskIntoConstraints = false
        labelForSymbol.text = "\(String(describing: viewModel.stockInfo?.symbol ?? "Unknown"))"
        labelForSymbol.font = .systemFont(ofSize: 36, weight: .semibold)
        view.addSubview(labelForSymbol)
        
        labelForPreviousClose.translatesAutoresizingMaskIntoConstraints = false
        labelForPreviousClose.text = "Previous Price: \(viewModel.stockInfo?.previousClose ?? .zero)"
        labelForPreviousClose.font = .systemFont(ofSize: 15, weight: .semibold)
        view.addSubview(labelForPreviousClose)
        
        labelHasPrePostMarketData.translatesAutoresizingMaskIntoConstraints = false
        labelHasPrePostMarketData.textColor = .secondaryLabel
        labelHasPrePostMarketData.font = .systemFont(ofSize: 12, weight: .semibold)
        if viewModel.stockInfo?.hasPrePostMarketData == true {
            labelHasPrePostMarketData.text = " Open Market "
            labelHasPrePostMarketData.backgroundColor = .systemGreen
            labelHasPrePostMarketData.layer.cornerRadius = 5
            labelHasPrePostMarketData.layer.masksToBounds = true
        } else {
            labelHasPrePostMarketData.text = " Closed Market "
            labelHasPrePostMarketData.backgroundColor = .systemRed
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
}
