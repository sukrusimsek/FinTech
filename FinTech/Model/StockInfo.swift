//
//  StockInfo.swift
//  FinTech
//
//  Created by Şükrü Şimşek on 22.03.2024.
//

import Foundation

struct StockInfo {
    let currency: String
    let symbol: String
    let regularMarketPrice: Double
    let previousClose: Double
    let exchangeName: String
    let hasPrePostMarketData: Bool
    let closePrice: [[Double?]]
}
