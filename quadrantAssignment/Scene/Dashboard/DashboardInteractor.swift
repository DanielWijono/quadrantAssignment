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

    func getCurrencyPriceIndexApi() {
        worker?.getCurrentPrice()
    }

    func getDailyCurrencyIndex() {
        let listPriceIndex = loadCurrenctPriceIndex()
        let today = Date().dateToString(withFormat: DateFormattingConstant.days.rawValue)
        let listPriceIndexDaily = listPriceIndex.filter {
            return ($0.updatedDateTime.toDate().dateToString(withFormat: DateFormattingConstant.days.rawValue) == today)
        }
        let sortedList = listPriceIndexDaily.sorted { $0.updatedDateTime.toDate().compare($1.updatedDateTime.toDate()) == .orderedDescending }
        try? dataService.save(data: sortedList, key: PriceIndex.structName)
        if let latestPriceIndex = sortedList.first {
            presenter?.didLoadCurrencyIndexSuccess(priceIndex: latestPriceIndex)
            print("sorted list exist")
        } else {
            getCurrencyPriceIndexApi()
            print("sorted list not exist")
        }
    }
}

extension DashboardInteractor: CurrentPriceProtocol {
    func didSuccessGetCurrentPrice(response: CurrentPriceResponse) {
        do {
            let dateTime = response.time.updatedISO
            let value = response.bpi.usd.rateFloat
            let longitude = String((locationService.getLongitude()))
            let latitude = String(locationService.getLatitude())
            let priceIndex = PriceIndex(updatedDateTime: dateTime, longitude: longitude, latitude: latitude, value: value)
            var priceIndexArray = loadCurrenctPriceIndex()
            priceIndexArray.append(priceIndex)
            let sortedList = priceIndexArray.sorted { $0.updatedDateTime.toDate().compare($1.updatedDateTime.toDate()) == .orderedDescending }
            try dataService.save(data: sortedList, key: PriceIndex.structName)
            presenter?.didSuccessGetCurrentPrice(response: response)
        } catch {
            print("catch error")
        }
    }

    func didFailedGetCurrentPrice(error: NetworkError) {
        presenter?.didFailedGetCurrentPrice(error: error)
    }
}
