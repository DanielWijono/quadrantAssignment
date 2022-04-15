//
//  DashboardService.swift
//  quadrantAssignment
//
//  Created by Daniel Wijono on 15/04/22.
//

import Foundation
import Moya

enum DashboardService {
    case getCurrentPrice
}

extension DashboardService: TargetType {

    var headers: [String : String]? {
        return [:]
    }

    var baseURL: URL {
        return URL(string: "https://api.coindesk.com/v1")!
    }

    var path: String {
        switch self {
        case .getCurrentPrice:
            return "/bpi/currentprice.json"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        return .requestPlain
    }

    var parameter: [String: Any] {
        switch self {
        case .getCurrentPrice:
            return [:]
        }
    }
}
