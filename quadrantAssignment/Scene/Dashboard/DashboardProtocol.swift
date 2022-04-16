//
//  DashboardProtocol.swift
//  quadrantAssignment
//
//  Created by Daniel Wijono on 14/04/22.
//

import Foundation
import UIKit
import Charts

protocol DashboardPresenterToView: AnyObject {
    var presenter: DashboardViewToPresenter? { get set }

    func reloadDataTableView()
    func showLoading()
    func dismissLoading()
    func updateChart()
    func updateDateTitle(value: String)
}

protocol DashboardPresenterToInteractor: AnyObject {
    var presenter: DashboardInteractorToPresenter? { get set }
    func loadCurrenctPriceIndex() -> [PriceIndex]
    func requestLocationPermission()
    func getDailyCurrencyIndex()
    func getCurrencyPriceIndexApi()
}

protocol DashboardPresenterToRouter: AnyObject {}

protocol DashboardViewToPresenter: AnyObject {
    var view: DashboardPresenterToView? { get set }
    var interactor: DashboardPresenterToInteractor? { get set }
    var router: DashboardPresenterToRouter? { get set }

    func getDailyCurrentPriceApi()
    func getCurrentPriceFromDB()
    func requestLocationPermission()
    func getTotalPriceIndex() -> Int
    func populateChartDataEntry() -> [ChartDataEntry]
    func getMaxAxis() -> Double
    func getTimePriceIndex(index: Int) -> String
    func getCurrentPriceIndex(index: Int) -> String
    func getLongitudePriceIndex(index: Int) -> String
    func getLatitudePriceIndex(index: Int) -> String
    func getCurrentPriceApi()
}

protocol DashboardInteractorToPresenter: AnyObject {
    func didSuccessGetCurrentPrice(response: CurrentPriceResponse)
    func didFailedGetCurrentPrice(error: NetworkError)

    func didLoadCurrencyIndexSuccess(priceIndex: PriceIndex)
}
