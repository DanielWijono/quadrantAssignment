//
//  CurrentPriceResponse.swift
//  quadrantAssignment
//
//  Created by Daniel Wijono on 15/04/22.
//

import Foundation

struct CurrentPriceResponse: Codable {
    let time: Time
    let disclaimer, chartName: String
    let bpi: Bpi
}

struct Bpi: Codable {
    let usd, gbp, eur: Currency

    enum CodingKeys: String, CodingKey {
        case usd = "USD"
        case gbp = "GBP"
        case eur = "EUR"
    }
}

struct Currency: Codable {
    let code, symbol, rate, description: String
    let rateFloat: Double

    enum CodingKeys: String, CodingKey {
        case code, symbol, rate, description
        case rateFloat = "rate_float"
    }
}

struct Time: Codable {
    let updated, updatedISO, updateduk: String
}
