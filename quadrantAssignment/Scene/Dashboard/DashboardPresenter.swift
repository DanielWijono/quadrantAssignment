//
//  DashboardPresenter.swift
//  quadrantAssignment
//
//  Created by Daniel Wijono on 14/04/22.
//

import Foundation

class DashboardPresenter {
    var view: DashboardPresenterToView?
    var interactor: DashboardPresenterToInteractor?
    var router: DashboardPresenterToRouter?
}

extension DashboardPresenter: DashboardViewToPresenter {

}

extension DashboardPresenter: DashboardInteractorToPresenter {

}
