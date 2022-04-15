//
//  DashboardProtocol.swift
//  quadrantAssignment
//
//  Created by Daniel Wijono on 14/04/22.
//

import Foundation
import UIKit

protocol DashboardPresenterToView: AnyObject {
    var presenter: DashboardViewToPresenter? { get set }
}

protocol DashboardPresenterToInteractor: AnyObject {
    var presenter: DashboardInteractorToPresenter? { get set }
}

protocol DashboardPresenterToRouter: AnyObject {}

protocol DashboardViewToPresenter: AnyObject {
    var view: DashboardPresenterToView? { get set }
    var interactor: DashboardPresenterToInteractor? { get set }
    var router: DashboardPresenterToRouter? { get set }
}

protocol DashboardInteractorToPresenter: AnyObject {}
