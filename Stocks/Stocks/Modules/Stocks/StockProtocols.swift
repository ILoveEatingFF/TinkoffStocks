//
// Created by Иван Лизогуб on 31.01.2021.
//

import Foundation

protocol StockViewInput: class {
    func updateCompanies(with companies: [String:String])
    func updateDisplay(with stock: Stock, color: Color)
    func updateLogo(with logo: String)
    func showAlert(title: String, message: String?)
}

protocol StockViewOutput: class {
    func requestCompanies()
    func requestQuoteUpdate(with symbol: String)
    func requestLogo(with symbol: String)
}
