//
//  QuadrantTest.swift
//  quadrantAssignmentTests
//
//  Created by Daniel Wijono on 16/04/22.
//

import Quick
import Nimble
import Moya
import Charts

@testable import quadrantAssignment

class QuadrantTests: QuickSpec {
    class DashboardViewMock: DashboardPresenterToView {
        var presenter: DashboardViewToPresenter?

        var isReloadDataTableViewCalled = false
        func reloadDataTableView() {
            isReloadDataTableViewCalled = true
        }

        var isShowLoadingCalled = false
        func showLoading() {
            isShowLoadingCalled = true
        }

        var isDismissLoadingCalled = false
        func dismissLoading() {
            isDismissLoadingCalled = true
        }

        var isUpdateChartCalled = false
        func updateChart() {
            isUpdateChartCalled = true
        }

        var isUpdateDateTitleCalled = false
        func updateDateTitle(value: String) {
            isUpdateDateTitleCalled = true
        }
    }

    class DashboardInteractorMock: DashboardPresenterToInteractor {
        var presenter: DashboardInteractorToPresenter?

        var isLoadCurrencyPriceIndexCalled = false
        func loadCurrenctPriceIndex() -> [PriceIndex] {
            isLoadCurrencyPriceIndexCalled = true
            return []
        }

        var isRequestLocationPermissionCalled = false
        func requestLocationPermission() {
            isRequestLocationPermissionCalled = true
        }

        var isGetDailyCurrencyIndexCalled = false
        func getDailyCurrencyIndex() {
            isGetDailyCurrencyIndexCalled = true
        }

        var isGetCurrencyPriceIndexApiCalled = false
        func getCurrencyPriceIndexApi() {
            isGetCurrencyPriceIndexApiCalled = true
        }
    }

    class DashboardPresenterMock: DashboardInteractorToPresenter {
        var isDidSuccessGetCurrentPriceCalled = false
        func didSuccessGetCurrentPrice(response: CurrentPriceResponse) {
            isDidSuccessGetCurrentPriceCalled = true
        }

        var isDidFailedGetCurrentPriceCalled = false
        func didFailedGetCurrentPrice(error: NetworkError) {
            isDidFailedGetCurrentPriceCalled = true
        }

        var isDidLoadCurrencyIndexSuccessCalled = false
        func didLoadCurrencyIndexSuccess(priceIndex: PriceIndex) {
            isDidLoadCurrencyIndexSuccessCalled = true
        }
    }

    class NetworkServiceMock: NetworkServiceProtocol {
        var isNetworkRequestCalled = false
        func request<T, C>(_ t: T, c: C.Type, completion: @escaping (Result<C, NetworkError>) -> Void) where T : TargetType, C : Decodable {
            isNetworkRequestCalled = true
        }
    }

    class DataServiceMock: DataServiceProtocol {
        var isSaveDataCalled = false
        func save<T>(data: [T], key: String) throws where T : Decodable, T : Encodable {
            isSaveDataCalled = true
        }

        var isLoadDataCalled = false
        func load(key: String) throws -> Data {
            isLoadDataCalled = true
            return Data()
        }

        var isRemoveDataCalled = false
        func remove(key: String) throws {
            isRemoveDataCalled = true
        }
    }

    class LocationServiceMock: LocationServiceProtocol {
        var isGetLatitudeCalled = false
        func getLatitude() -> Double {
            isGetLatitudeCalled = true
            return 0
        }

        var isGetLongitudeCalled = false
        func getLongitude() -> Double {
            isGetLongitudeCalled = true
            return 0
        }

        var isRequestLocationCalled = false
        func requestLocation() {
            isRequestLocationCalled = true
        }
    }

    override func spec() {
        describe("DashboardPresenter") {
            var sut: DashboardPresenter!
            var viewMock: DashboardViewMock!
            var interactorMock: DashboardInteractorMock!

            beforeEach {
                sut = DashboardPresenter()
                viewMock = DashboardViewMock()
                interactorMock = DashboardInteractorMock()
                sut.interactor = interactorMock
                sut.view = viewMock
                sut.listPriceIndex = [PriceIndex(updatedDateTime: "2021-12-05T10:22:08+00:00", longitude: "8397.234897", latitude: "9082.389465", value: 48394.3783)]
            }
            afterEach {
                sut.listPriceIndex = []
            }

            context("get total price index") {
                it("function called") {
                    expect(sut.getTotalPriceIndex()).to(equal(1))
                }
            }

            context("get time price index") {
                it("function called") {
                    expect(sut.getTimePriceIndex(index: 0)).to(equal("Time: 17.22"))
                }
            }

            context("get latitude price index") {
                it("function called") {
                    expect(sut.getLatitudePriceIndex(index: 0)).to(equal("9082.389465"))
                }
            }

            context("get longitude price index") {
                it("function called") {
                    expect(sut.getLongitudePriceIndex(index: 0)).to(equal("8397.234897"))
                }
            }

            context("get current price index") {
                it("function called") {
                    expect(sut.getCurrentPriceIndex(index: 0)).to(equal("USD: 48394.3783"))
                }
            }

            context("refresh view") {
                it("function called") {
                    sut.refreshView()
                    expect(viewMock.isUpdateChartCalled).to(beTrue())
                    expect(viewMock.isReloadDataTableViewCalled).to(beTrue())
                }
            }

            context("get current price api") {
                it("function called") {
                    sut.getCurrentPriceApi()
                    expect(interactorMock.isGetCurrencyPriceIndexApiCalled).to(beTrue())
                }
            }

            context("get total price index") {
                it("function called") {
                    expect(sut.getTotalPriceIndex()).to(equal(1))
                }
            }
        }

        describe("DashbaordInteractor") {
            var sut: DashboardInteractor!
            var presenterMock: DashboardPresenterMock!
            var dataServiceMock: DataServiceMock!
            var locationServiceMock: LocationServiceMock!

            beforeEach {
                sut = DashboardInteractor(worker: DashboardWorker())
                presenterMock = DashboardPresenterMock()
                dataServiceMock = DataServiceMock()
                locationServiceMock = LocationServiceMock()
                sut.presenter = presenterMock
                sut.dataService = dataServiceMock
                sut.locationService = locationServiceMock
            }

            context("getCurrencyIndex function") {
                it("function called") {
                    sut.requestLocationPermission()
                    expect(locationServiceMock.isRequestLocationCalled).to(beTrue())
                }
            }

            context("get daily current index function") {
                it("function called") {
                    sut.getDailyCurrencyIndex()
                    expect(dataServiceMock.isSaveDataCalled).to(beTrue())
                }
            }

            context("get daily current index success function") {
                it("function called") {
                    sut.didSuccessGetCurrentPrice(response: CurrentPriceResponse.init(time: Time(updated: "", updatedISO: "", updateduk: ""), disclaimer: "", chartName: "", bpi: Bpi(usd: .init(code: "", symbol: "", rate: "", description: "", rateFloat: .zero), gbp: .init(code: "", symbol: "", rate: "", description: "", rateFloat: .zero), eur: .init(code: "", symbol: "", rate: "", description: "", rateFloat: .zero))))
                    expect(presenterMock.isDidSuccessGetCurrentPriceCalled).to(beTrue())
                }
            }

            context("get daily current index failed function") {
                it("function called") {
                    sut.didFailedGetCurrentPrice(error: NetworkError(error: NSError()))
                    expect(presenterMock.isDidFailedGetCurrentPriceCalled).to(beTrue())
                }
            }
        }
    }
}

