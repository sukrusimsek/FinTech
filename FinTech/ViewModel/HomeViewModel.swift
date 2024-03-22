//
//  HomeViewModel.swift
//  FinTech
//
//  Created by Şükrü Şimşek on 21.03.2024.
//

import Foundation
protocol HomeViewModelInterface {
    var view: HomeViewInterface? { get set }
    func viewDidLoad()
}

final class HomeViewModel {
    weak var view: HomeViewInterface?
    var stockInfo: StockInfo?
    let url = "https://query1.finance.yahoo.com/v8/finance/chart/AAPL?range=5d&interval=5m"
    
    
    func updateSelectedData(_ data: String) {
        let updatedURL = "https://query1.finance.yahoo.com/v8/finance/chart/\(data)?range=5d&interval=5m"
        getStockPrice(with: updatedURL)
    }
    func updateStockInfo(with stockInfo: StockInfo) {
        self.stockInfo = stockInfo
    }
    
    private func getStockPrice(with url: String) {
        NetworkManager.instance.fetch(.get, url: url, requestModel: nil, model: Yahoo.self) { response in
            switch(response) {
            case .success(let result):
                guard let yahooModel = result as? Yahoo else {
                    print("Error HomeViewModel")
                    return
                }
                guard let chart = yahooModel.chart, let results = chart.result else {
                    print("No chart or results in yahoo")
                    return
                }
               
                
                for res in results {
                    guard let indicators = res.indicators else {
                        continue
                    }
                    guard let quote = indicators.quote else {
                        continue
                    }
                    guard let meta = res.meta else {
                        continue
                    }
                    let chartDataList = quote.compactMap { $0.close }
//                    print("Kapanış Fiyatları:",chartDataList)
                    
                    if let currency = meta.currency {
                        print("Parite: \(currency)")
                    }
                    if let symbol = meta.symbol {
                        print("Hisse: \(symbol)")
                    }
                    if let regularMarketPrice = meta.regularMarketPrice {
                        print("Fiyat: \(regularMarketPrice)")
                    }
                    if let previousClose = meta.previousClose {
                        print("Son kapanan mum fiyatı: \(previousClose)")
                    }
//                    if let exchangeName = meta.exchangeName {
//                        print("Borsa Adı: \(exchangeName)")
//                    }
                    if let hasPrePostMarketData = meta.hasPrePostMarketData {
                        print("Sanırım market açık bilgisi: \(hasPrePostMarketData)")
                    }
                    
                    self.stockInfo = StockInfo(currency: meta.currency ?? "Unknown",
                                          symbol: meta.symbol ?? "Unknown",
                                          regularMarketPrice: meta.regularMarketPrice ?? 0.0,
                                          previousClose: meta.previousClose ?? 0.0,
                                          exchangeName: meta.exchangeName ?? "Unknown",
                                          hasPrePostMarketData: meta.hasPrePostMarketData ?? false,
                                               closePrice: chartDataList)
                    self.stockInfo = self.stockInfo
                    self.view?.reloadView()

                    
                    
                }
            case .failure(let error):
                print("Hata HomeViewModel \(error)")
                break
            }
            
        }
    }
    
}

extension HomeViewModel: HomeViewModelInterface {
    func viewDidLoad() {
        getStockPrice(with: url)
        view?.configureVC()
        view?.configureLabels()
        view?.configurePickerView()
    }
}
