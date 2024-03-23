//
//  ChartUI.swift
//  FinTech
//
//  Created by Şükrü Şimşek on 23.03.2024.
//

import Foundation
import SwiftUI
import SwiftUICharts

struct ClosePrices: Identifiable {
    let id = UUID()
    let price: Double
}




struct LineCharts:View {
    @EnvironmentObject private var prices: StockPrice
    
    var body: some View {
        VStack(alignment: .center, spacing: 50, content: {
            LineChartView(data: prices.stockPrice,
                          title: "Charts of AAPL",
                          legend: "Last 7 Days",
                          form: ChartForm.extraLarge)
            
        })
    }
}

class StockPrice: ObservableObject {
    @Published var stockPrice: [Double] = []
    
}
