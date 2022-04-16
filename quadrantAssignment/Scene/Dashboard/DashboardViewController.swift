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
        presenter?.getCurrentPriceApi()
    }
    @IBOutlet weak var chartView: BarChartView!
    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var presenter: DashboardViewToPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView()
        setupChartView()
        setupLoadingIndicator()
        presenter?.getDailyCurrentPriceApi()
        presenter?.requestLocationPermission()
    }

    func setupLoadingIndicator() {
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
    }

    func registerTableView() {
        let dashboardCell = UINib(nibName: DashboardTableViewCell.className, bundle: Bundle(for: DashboardViewController.self))
        infoTableView.register(dashboardCell, forCellReuseIdentifier: DashboardTableViewCell.className)
        infoTableView.delegate = self
        infoTableView.dataSource = self
    }

    func setupChartView() {
        chartView.delegate = self

        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawAxisLineEnabled = true
        xAxis.gridLineWidth = .zero
        xAxis.axisMinimum = .zero

        let rightAxis = chartView.rightAxis
        rightAxis.enabled = false

        chartView.highlightPerTapEnabled = true
        chartView.highlightFullBarEnabled = true
        chartView.highlightPerDragEnabled = false
        // disable zoom function
        chartView.pinchZoomEnabled = false
        chartView.setScaleEnabled(false)
        chartView.doubleTapToZoomEnabled = false
        // Bar, Grid Line, Background
        chartView.drawBarShadowEnabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.drawBordersEnabled = false
        chartView.borderColor = .black
        // Legend
        chartView.legend.enabled = false
        // Chart Offset
        chartView.setExtraOffsets(left: QuadrantUIConstant.floatTen, top: .zero,
                                  right: QuadrantUIConstant.floatTwenty, bottom: QuadrantUIConstant.floatFifty)
    }
}

extension DashboardViewController: DashboardPresenterToView {
    func updateDateTitle(value: String) {
        dateLabel.text = value
    }

    func reloadDataTableView() {
        DispatchQueue.main.async {
            self.infoTableView.reloadData()
        }
    }

    func showLoading() {
        DispatchQueue.main.async {
            self.loadingIndicator.isHidden = false
            self.loadingIndicator.startAnimating()
        }
    }

    func dismissLoading() {
        DispatchQueue.main.async {
            self.loadingIndicator.isHidden = true
            self.loadingIndicator.stopAnimating()
        }
    }

    func updateChart() {
        var entries = [BarChartDataEntry]()
        let populateChartDataEntry = presenter?.populateChartDataEntry()
        for index in .zero..<(populateChartDataEntry?.count ?? .zero) {
            let xCoordinate = populateChartDataEntry?[index].x ?? .zero
            let yCoordinate = populateChartDataEntry?[index].y ?? .zero
            entries.append(BarChartDataEntry(x: xCoordinate, y: yCoordinate))
        }
        let set = BarChartDataSet(entries: entries, label: "Price")
        set.colors = ChartColorTemplates.colorful()
        let data = BarChartData(dataSet: set)
        data.setDrawValues(false)
        chartView.data = data
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
        return QuadrantUIConstant.intOne
    }
}

extension DashboardViewController: ChartViewDelegate {

}
