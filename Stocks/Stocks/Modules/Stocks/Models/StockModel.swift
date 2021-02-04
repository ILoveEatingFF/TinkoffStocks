//
//  StockModel.swift
//  Stocks
//
//  Created by Иван Лизогуб on 30.01.2021.
//

import Foundation

struct Stock: Codable {
    enum CodingKeys: String, CodingKey {
        case companyName, symbol
        case price = "latestPrice"
        case priceChange = "change"
    }
    let companyName: String
    let symbol: String
    let price: Double
    let priceChange: Double
}