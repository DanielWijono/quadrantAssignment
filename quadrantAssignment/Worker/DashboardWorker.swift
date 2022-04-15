//
//  DashboardWorker.swift
//  quadrantAssignment
//
//  Created by Daniel Wijono on 15/04/22.
//

import Foundation

class DashboardWorker: DashboardWorkerProtocol {
    private let networkService: NetworkService
    weak var currPriceDelegate: CurrentPriceProtocol?

    init(networkService: NetworkService = NetworkService.instance) {
        self.networkService = networkService
    }

    func getCurrentPrice() {
        networkService.request(DashboardService.getCurrentPrice, c: CurrentPriceResponse.self) { [weak self] result in
            switch result {
            case .success(let res):
                self?.currPriceDelegate?.didSuccessGetCurrentPrice(response: res)
            case .failure(let err):
                self?.currPriceDelegate?.didFailedGetCurrentPrice(error: err)
            }
        }
    }
}
