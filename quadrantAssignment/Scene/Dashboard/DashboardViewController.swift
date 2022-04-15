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
        registerTableView()
        setupChartView()
        presenter?.getCurrentPrice()
        presenter?.requestLocationPermission()
        infoTableView.reloadData()
    }

    func registerTableView() {
        let dashboardCell = UINib(nibName: DashboardTableViewCell.className, bundle: Bundle(for: DashboardViewController.self))
        infoTableView.register(dashboardCell, forCellReuseIdentifier: DashboardTableViewCell.className)
        infoTableView.delegate = self
        infoTableView.dataSource = self
    }

    func setupChartView() {
        chartView.delegate = self
        chartView.setScaleEnabled(true)

        let leftAxis = chartView.leftAxis
        leftAxis.axisMaximum = .zero
        leftAxis.axisMinimum = .zero
        leftAxis.gridLineWidth = .zero

        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawAxisLineEnabled = true
        xAxis.gridLineWidth = .zero
        xAxis.axisMinimum = .zero

        chartView.rightAxis.enabled = false
        chartView.legend.form = .empty
    }
}

extension DashboardViewController: DashboardPresenterToView {

    func reloadDataTableView() {
        infoTableView.reloadData()
    }

    func showLoading() {

    }

    func dismissLoading() {

    }

}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: DashboardTableViewCell.className, for: indexPath) as? DashboardTableViewCell else { return UITableViewCell() }

        cell.timeLabel.text = "time"
        cell.priceLabel.text = "pricing"
        cell.longitudeLabel.text = "longitude"
        cell.latitudeLabel.text = "latitude"

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension DashboardViewController: ChartViewDelegate {
    
}
