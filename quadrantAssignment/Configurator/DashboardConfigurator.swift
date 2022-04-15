//
//  DashboardConfigurator.swift
//  quadrantAssignment
//
//  Created by Daniel Wijono on 14/04/22.
//

import Foundation
import UIKit

final class DashboardConfigurator {
    static func configureDashboard(navigationController: UINavigationController) -> UIViewController {
        let view: UIViewController & DashboardPresenterToView = DashboardViewController()
        let presenter: DashboardViewToPresenter & DashboardInteractorToPresenter = DashboardPresenter()
//        let worker: DashboardWorker?
        let interactor: DashboardPresenterToInteractor = DashboardInteractor()
        let router: DashboardPresenterToRouter = DashboardRouter()

        view.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view

        return view
    }
}
