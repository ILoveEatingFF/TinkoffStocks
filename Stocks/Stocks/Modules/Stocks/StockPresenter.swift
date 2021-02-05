//
// Created by Иван Лизогуб on 31.01.2021.
//

import Foundation


class StockPresenter {
    weak var view: StockViewInput?
    private let apiClient = ApiClient()
}

extension StockPresenter: StockViewOutput {

    func requestCompanies(type: CompanyType) {
        apiClient.requestCompanies(type: type) { [weak self] (result: Result<[Company], Error>) in
            switch result {
            case .failure(let error):
                self?.view?.showAlert(title: "Error", message: error.localizedDescription)
            case .success(let companies):
                var result: [String:String] = [:]
                for company in companies {
                    result[company.companyName] = company.symbol
                }
                self?.view?.updateCompanies(with: result)
            }
        }
    }

    func requestQuoteUpdate(with symbol: String) {
        apiClient.requestQuote(for: symbol) { [weak self] (result: Result<Stock, Error>) in
            switch result {
            case .failure(let error):
                self?.view?.showAlert(title: "Error", message: error.localizedDescription)
            case .success(let stock):
                var color = Color.black
                if(stock.priceChange > 0){
                    color = .green
                } else if(stock.priceChange < 0) {
                    color = .red
                }
                self?.view?.updateDisplay(with: stock, color: color)
            }
        }
    }

    func requestLogo(with symbol: String) {
        apiClient.requestLogo(for: symbol) { [weak self] (result: Result<Logo, Error>) in
            switch result {
            case .failure(let error):
                self?.view?.showAlert(title: "Error", message: error.localizedDescription)
            case .success(let logo):
                self?.view?.updateLogo(with: logo.logo)
            }
        }
    }
}