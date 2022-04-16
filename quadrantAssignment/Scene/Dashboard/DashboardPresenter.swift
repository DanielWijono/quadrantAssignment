//
//  DashboardPresenter.swift
//  quadrantAssignment
//
//  Created by Daniel Wijono on 14/04/22.
//

import Foundation
import Charts

class DashboardPresenter {
    var view: DashboardPresenterToView?
    var interactor: DashboardPresenterToInteractor?
    var router: DashboardPresenterToRouter?
    var currentPriceResp: CurrentPriceResponse?
    var listPriceIndex: [PriceIndex] = []

    func refreshView() {
        view?.updateChart()
        view?.reloadDataTableView()
    }
}

extension DashboardPresenter: DashboardViewToPresenter {
    func getCurrentPriceApi() {
        interactor?.getCurrencyPriceIndexApi()
    }

    func getDailyCurrentPriceApi() {
        interactor?.getDailyCurrencyIndex()
    }

    func getCurrentPriceFromDB() {
        let listPriceFromDB = interactor?.loadCurrenctPriceIndex()
        listPriceIndex = listPriceFromDB ?? []
        refreshView()
    }

    func requestLocationPermission() {
        interactor?.requestLocationPermission()
    }

    func getTotalPriceIndex() -> Int {
        return listPriceIndex.count
    }

    func getPriceIndex(index: Int) -> PriceIndex {
        return listPriceIndex[index]
    }

    func getTimePriceIndex(index: Int) -> String {
        let priceIndex = getPriceIndex(index: index)
        let time = priceIndex.updatedDateTime.formatDateInString(convertDateTo: DateFormattingConstant.time.rawValue)
        return "Time: \(time)"
    }

    func getCurrentPriceIndex(index: Int) -> String {
        let priceIndex = getPriceIndex(index: index)
        return "USD: \(priceIndex.value)"
    }

    func getLongitudePriceIndex(index: Int) -> String {
        let priceIndex = getPriceIndex(index: index)
        return "Longitude: \(priceIndex.longitude)"
    }

    func getLatitudePriceIndex(index: Int) -> String {
        let priceIndex = getPriceIndex(index: index)
        return "Latitude: \(priceIndex.latitude)"
    }

    func populateChartDataEntry() -> [ChartDataEntry] {
        var chartDataEntries: [ChartDataEntry] = []
        if let allListPriceIndex = interactor?.loadCurrenctPriceIndex() {
            for priceIndex in allListPriceIndex {
                let hours = Double(priceIndex.updatedDateTime.formatDateInString(convertDateTo: DateFormattingConstant.hours.rawValue)) ?? .zero
                let chartDataEntry = ChartDataEntry(x: hours, y: priceIndex.value)
                chartDataEntries.append(chartDataEntry)
            }
        }
        return chartDataEntries
    }

    private func pickFiveLastCurrencyIndex() -> [PriceIndex] {
        var priceIndexArray = interactor?.loadCurrenctPriceIndex() ?? []
        if priceIndexArray.count > 5 {
            priceIndexArray = Array(priceIndexArray.prefix(5))
        }
        return priceIndexArray
    }

    func getMaxAxis() -> Double {
        guard let priceIndex = listPriceIndex.first else { return .zero }
        let rounded = priceIndex.value.rounded(.towardZero)
        let maxAxis = rounded + 10_000
        return maxAxis
    }
}

extension DashboardPresenter: DashboardInteractorToPresenter {
    func didSuccessGetCurrentPrice(response: CurrentPriceResponse) {
        currentPriceResp = response
        listPriceIndex = pickFiveLastCurrencyIndex()
        let currDate = currentPriceResp?.time.updatedISO.formatDateInString(convertDateTo: DateFormattingConstant.daily.rawValue)
        view?.updateDateTitle(value: currDate ?? "")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.refreshView()
        }
    }

    func didFailedGetCurrentPrice(error: NetworkError) {

    }

    func didLoadCurrencyIndexSuccess(priceIndex: PriceIndex) {
        listPriceIndex = pickFiveLastCurrencyIndex()
        let currentDate = priceIndex.updatedDateTime.formatDateInString(convertDateTo: DateFormattingConstant.daily.rawValue)
        view?.updateDateTitle(value: currentDate)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
            self.refreshView()
        })
    }
}
