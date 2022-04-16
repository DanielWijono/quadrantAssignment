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
        print("tapped")
    }

    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var infoTableView: UITableView!
    var presenter: DashboardViewToPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView()
        setupChartView()
        presenter?.getDailyCurrentPriceApi()
        presenter?.requestLocationPermission()
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
    func updateDateTitle(value: String) {
        dateLabel.text = value
    }

    func reloadDataTableView() {
        infoTableView.reloadData()
    }

    func showLoading() {
        //TO DO
    }

    func dismissLoading() {
        //TO DO
    }

    func updateChart() {
        chartView.leftAxis.axisMaximum = presenter?.getMaxAxis() ?? .zero
        let dataSet = LineChartDataSet(entries: [], label: .emptyString)
        dataSet.drawIconsEnabled = false
        dataSet.setColor(.clear)
        dataSet.setCircleColor(.clear)
        dataSet.lineWidth = CGFloat(QuadrantUIConstant.lineWidthThin)
        dataSet.drawCircleHoleEnabled = false
        dataSet.valueFont = .systemFont(ofSize: .zero)
        dataSet.formLineWidth = CGFloat(QuadrantUIConstant.lineWidthThin)
        dataSet.formSize = CGFloat(QuadrantUIConstant.formSizeSmall)

        (presenter?.populateChartDataEntry() ?? []).forEach { (chartData) in dataSet.addEntryOrdered(chartData) }
        dataSet.mode = .cubicBezier
        dataSet.fillAlpha = QuadrantUIConstant.alphaMedium
        dataSet.fillColor = .green
        dataSet.drawFilledEnabled = true
        let data = LineChartData(dataSet: dataSet)
        chartView.data = data
        chartView.animate(xAxisDuration: QuadrantUIConstant.durationShort)
        chartView.setNeedsDisplay()
    }
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getTotalPriceIndex() ?? .zero
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: DashboardTableViewCell.className, for: indexPath) as? DashboardTableViewCell else { return UITableViewCell() }
        guard let presenter = presenter else { return UITableViewCell() }

        cell.timeLabel.text = presenter.getTimePriceIndex(index: indexPath.row)
        cell.priceLabel.text = presenter.getCurrentPriceIndex(index: indexPath.row)
        cell.longitudeLabel.text = presenter.getLongitudePriceIndex(index: indexPath.row)
        cell.latitudeLabel.text = presenter.getLatitudePriceIndex(index: indexPath.row)

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
