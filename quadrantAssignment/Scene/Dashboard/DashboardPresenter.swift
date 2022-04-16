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
        view?.showLoading()
        interactor?.getCurrencyPriceIndexApi()
    }

    func getDailyCurrentPriceApi() {
        view?.showLoading()
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
        for priceIndex in pickFiveLastCurrencyIndex() {
            let hours = Double(priceIndex.updatedDateTime.formatDateInString(convertDateTo: DateFormattingConstant.hours.rawValue)) ?? .zero
            let chartDataEntry = ChartDataEntry(x: hours, y: priceIndex.value)
            chartDataEntries.append(chartDataEntry)
        }
        print("chart data entry : \(chartDataEntries)")
        return chartDataEntries
    }

    private func pickFiveLastCurrencyIndex() -> [PriceIndex] {
        var priceIndexArray = interactor?.loadCurrenctPriceIndex() ?? []
        if priceIndexArray.count > QuadrantUIConstant.intFive {
            priceIndexArray = Array(priceIndexArray.prefix(QuadrantUIConstant.intFive))
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
        DispatchQueue.main.asyncAfter(deadline: .now() + QuadrantUIConstant.durationGlance) {
            self.view?.dismissLoading()
            self.refreshView()
        }
    }

    func didFailedGetCurrentPrice(error: NetworkError) {
        self.view?.dismissLoading()
        print("error : \(error.localizedDescription)")
    }

    func didLoadCurrencyIndexSuccess(priceIndex: PriceIndex) {
        listPriceIndex = pickFiveLastCurrencyIndex()
        let currentDate = priceIndex.updatedDateTime.formatDateInString(convertDateTo: DateFormattingConstant.daily.rawValue)
        view?.updateDateTitle(value: currentDate)
        DispatchQueue.main.asyncAfter(deadline: .now() + QuadrantUIConstant.durationGlance, execute: {
            self.view?.dismissLoading()
            self.refreshView()
        })
    }
}
