//
//  PriceIndex.swift
//  quadrantAssignment
//
//  Created by Daniel Wijono on 15/04/22.
//

import Foundation

struct PriceIndex: Codable {
    var updatedDateTime, longitude, latitude: String
    var value: Double

    static let structName = String(describing: PriceIndex.self)
}
