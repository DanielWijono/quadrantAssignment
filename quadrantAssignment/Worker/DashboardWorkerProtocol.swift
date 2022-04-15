//
//  DashboardWorkerProtocol.swift
//  quadrantAssignment
//
//  Created by Daniel Wijono on 15/04/22.
//

import Foundation

protocol DashboardWorkerProtocol: AnyObject {
    var currPriceDelegate: CurrentPriceProtocol? { get set }
    func getCurrentPrice()
}

protocol CurrentPriceProtocol: AnyObject {
    func didSuccessGetCurrentPrice(response: CurrentPriceResponse)
    func didFailedGetCurrentPrice(error: NetworkError)
}
