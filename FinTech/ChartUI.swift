//
//  ChartUI.swift
//  FinTech
//
//  Created by Şükrü Şimşek on 23.03.2024.
//

import Foundation
import SwiftUI
import SwiftUICharts

//struct ClosePrices: Identifiable {
//    let id = UUID()
//    let price: Double
//}




struct LineCharts:View {
    @EnvironmentObject private var prices: StockPrice
    
    var body: some View {
        VStack(alignment: .center, spacing: 50, content: {
            LineView(data: prices.stockPrice,
                          title: prices.stockName ?? "Charts"
//                          legend: "Daily",
//                          form: ChartForm.extraLarge
                        
//                          rateValue: .zero,
//                          dropShadow: false
                          
                          )
//            .overlay(Text("FinTech").font(.headline), alignment: .topTrailing)
        })
    }
}

class StockPrice: ObservableObject {
    @Published var stockPrice: [Double] = []
    @Published var stockName: String?
}
