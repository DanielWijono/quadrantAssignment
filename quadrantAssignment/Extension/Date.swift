//
//  Date.swift
//  quadrantAssignment
//
//  Created by Daniel Wijono on 16/04/22.
//

import Foundation

extension Date {

    func dateToString(withFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}
