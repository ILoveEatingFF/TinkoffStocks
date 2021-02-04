//
// Created by Иван Лизогуб on 31.01.2021.
//

import Foundation

struct Logo: Codable {
    enum CodingKeys: String, CodingKey {
        case logo = "url"
    }

    let logo: String
}