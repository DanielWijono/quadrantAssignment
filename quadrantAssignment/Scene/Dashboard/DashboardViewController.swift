//
//  DashboardViewController.swift
//  quadrantAssignment
//
//  Created by Daniel Wijono on 14/04/22.
//

import Foundation
import UIKit
import Charts

class DashboardViewController: UIViewController {
    @IBOutlet weak var priceIndexLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        print("atpped")
    }

    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var infoTableView: UITableView!
    var presenter: DashboardViewToPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.getCurrentPrice()
        presenter?.requestLocationPermission()
    }
}

extension DashboardViewController: DashboardPresenterToView {

}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return .zero
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
