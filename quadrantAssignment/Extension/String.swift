//
//  String.swift
//  quadrantAssignment
//
//  Created by Daniel Wijono on 15/04/22.
//

import Foundation

extension String {
    static let emptyString = ""

    func formatDateInString(convertDateTo format: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = DateFormattingConstant.formatISO.rawValue

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = format

        let date = dateFormatterGet.date(from: self) ?? Date()
        return dateFormatterPrint.string(from: date)
    }

    func toDate() -> Date {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = DateFormattingConstant.formatISO.rawValue
        return dateFormatterGet.date(from: self) ?? Date()
    }
}
