//
// Created by Иван Лизогуб on 30.01.2021.
//

import Foundation

final class ApiClient {
    private let token = "pk_6bdf2fa2a7344ea6b18bc0f2adfb673f"

    private let baseComponents: URLComponents = {
        var result = URLComponents()

        result.scheme = "https"
        result.host = "cloud.iexapis.com"
        result.queryItems = [URLQueryItem(name: "token", value: "pk_6bdf2fa2a7344ea6b18bc0f2adfb673f")]

        return result
    }()

    private let decoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        return jsonDecoder
    }()

    func requestCompanies<T: Decodable>(type: CompanyType, completion: @escaping (Result<T, Error>) -> Void) {
        guard let urlCompanies = makeURLForCompanies(type: type) else {
            completion(.failure(InternalError.unknownSymbol))
            return
        }

        let urlCompaniesRequest = URLRequest(url: urlCompanies)

        dataTask(urlRequest: urlCompaniesRequest, completion: completion)
    }

    func requestQuote<T: Decodable>(for symbol: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let urlQuote = makeURLForQuote(for: symbol) else {
            completion(.failure(InternalError.unknownSymbol))
            return
        }

        let urlQuoteRequest = URLRequest(url: urlQuote)

        dataTask(urlRequest: urlQuoteRequest, completion: completion)
    }

    func requestLogo<T: Decodable>(for symbol: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let urlLogo = makeURLForImage(for: symbol) else {
            completion(.failure(InternalError.unknownSymbol))
            return
        }

        let urlLogoRequest = URLRequest(url: urlLogo)

        dataTask(urlRequest: urlLogoRequest, completion: completion)
    }

    private func dataTask<T: Decodable>(urlRequest: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { [weak self]
        (data: Data?, response: URLResponse?, error: Error?) -> () in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            else if let data = data {
                do {
                    let decodedObject = try self?.decoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(decodedObject!))
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }

            } else {
                DispatchQueue.main.async {
                    completion(.failure(InternalError.InternalServerError))
                }
                return
            }
        }
        dataTask.resume()
    }

    private func makeURLForCompanies(type: CompanyType) -> URL? {
        var result = baseComponents
        result.path = "/stable/stock/market/list/\(type.rawValue)"
        return result.url
    }

    private func makeURLForQuote(for symbol: String) -> URL? {
        var result = baseComponents
        result.path = "/stable/stock/\(symbol)/quote"
        return result.url
    }

    private func makeURLForImage(for symbol: String) -> URL? {
        var result = baseComponents
        result.path = "/stable/stock/\(symbol)/logo"
        return result.url
    }
}

enum InternalError: Error {
    case unknownSymbol
    case InternalServerError
}