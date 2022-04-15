//
//  DashboardInteractor.swift
//  quadrantAssignment
//
//  Created by Daniel Wijono on 14/04/22.
//

import Foundation

class DashboardInteractor {
    var presenter: DashboardInteractorToPresenter?
    private var worker: DashboardWorkerProtocol?
    var dataService: DataServiceProtocol = DataService.shared
    var locationService: LocationServiceProtocol = LocationService.shared

    init(worker: DashboardWorkerProtocol) {
        self.worker = worker
        self.worker?.currPriceDelegate = self
    }
}

extension DashboardInteractor: DashboardPresenterToInteractor {
    func loadCurrenctPriceIndex() -> [PriceIndex] {
        do {
            let data = try dataService.load(key: PriceIndex.structName)
            let priceIndexArray = try JSONDecoder().decode([PriceIndex].self, from: data)
            return priceIndexArray
        } catch {
            return []
        }
    }

    func requestLocationPermission() {
        locationService.requestLocation()
    }
}

extension DashboardInteractor: CurrentPriceProtocol {
    func didSuccessGetCurrentPrice(response: CurrentPriceResponse) {
        presenter?.didSuccessGetCurrentPrice(response: response)
    }

    func didFailedGetCurrentPrice(error: NetworkError) {
        presenter?.didFailedGetCurrentPrice(error: error)
    }
}
