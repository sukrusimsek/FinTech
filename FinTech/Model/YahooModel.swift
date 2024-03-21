//
//  YahooModel.swift
//  FinTech
//
//  Created by Şükrü Şimşek on 21.03.2024.
//

import Foundation
// MARK: - Yahoo
struct Yahoo: Codable {
    let chart: Chart?
}

// MARK: - Chart
struct Chart: Codable {
    let result: [Result]?
    let error: JSONNull?
}

// MARK: - Result
struct Result: Codable {
    let meta: Meta?
    let timestamp: [Int]?
    let indicators: Indicators?
}

// MARK: - Indicators
struct Indicators: Codable {
    let quote: [Quote]?
}

// MARK: - Quote
struct Quote: Codable {
    let low: [Double?]?
    let volume: [Int?]?
    let high, close, quoteOpen: [Double?]?

    enum CodingKeys: String, CodingKey {
        case low, volume, high, close
        case quoteOpen = "open"
    }
}

// MARK: - Meta
struct Meta: Codable {
    let currency, symbol, exchangeName, instrumentType: String?
    let firstTradeDate, regularMarketTime: Int?
    let hasPrePostMarketData: Bool?
    let gmtoffset: Int?
    let timezone, exchangeTimezoneName: String?
    let regularMarketPrice, chartPreviousClose, previousClose: Double?
    let scale, priceHint: Int?
    let currentTradingPeriod: CurrentTradingPeriod?
    let tradingPeriods: [[Post]]?
    let dataGranularity, range: String?
    let validRanges: [String]?
}

// MARK: - CurrentTradingPeriod
struct CurrentTradingPeriod: Codable {
    let pre, regular, post: Post?
}

// MARK: - Post
struct Post: Codable {
    let timezone: String?
    let start, end, gmtoffset: Int?
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
