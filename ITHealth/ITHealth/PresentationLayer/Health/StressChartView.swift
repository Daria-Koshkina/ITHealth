//
//  StressChartView.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.05.2023.
//

import Foundation
import Charts

class StressChartView: InitView {
  
  // MARK: - Public variables
  let topBoundaryView = ChartBoundaryView()
  let centerBoundaryView = ChartBoundaryView()
  let lineChartView = LineChartView()
  let bottomBoundaryView = ChartBoundaryView()
  
  // MARK: Private variables
  private let containerView = UIView()
  
  // MARK: - Life cycle
  override func initConfigure() {
    super.initConfigure()
    backgroundColor = .clear
    configureContainerView()
    configureLineChartView()
  }
  
  func configure(startDate: Date, endDate: Date, stressBound: Double, points: [Double]) {
    let startDateString = DateFormatsFactory.getStressChartDateFormat().string(from: startDate)
    let endDateString = DateFormatsFactory.getStressChartDateFormat().string(from: endDate)
    centerBoundaryView.configure(position: .top, color: UIConstants.boundaryRedColor)
    centerBoundaryView.configure(leftTitle: Localizator.standard.localizedString("stress.chart.stress_bound"), rightTitle: StringComposer.shared.getStressString(from: stressBound))
    topBoundaryView.configure(position: .bottom, color: UIConstants.boundaryBlueColor)
    topBoundaryView.configure(leftTitle: Localizator.standard.localizedString("stress.chart.top"), rightTitle: StringComposer.shared.getStressString(from: points.max() ?? .zero))
    bottomBoundaryView.configure(position: .top, color: UIConstants.boundaryBlueColor)
    bottomBoundaryView.configure(leftTitle: startDateString, rightTitle: endDateString)
    lineChartView.xAxis.axisMaximum = 7
    lineChartView.xAxis.axisMinimum = .zero
    configureChart(points: points, stressBound: stressBound)
  }
  
  private func getOffsetForPoint(_ point: Double, maxValue: Double, minValue: Double) -> CGFloat {
    let diff = maxValue - minValue
    let pointDiff = maxValue - point
    let percent = diff.isZero ? .zero : (pointDiff * 100) / diff
    let result = percent / 50
    return CGFloat(Double(result))
  }
  
  private func setBoundaries(points: [Double], stressBound: Double) {
    containerView.subviews.filter { $0.isKind(of: ChartBoundaryView.self) }.forEach { view in
      view.snp.removeConstraints()
      view.removeFromSuperview()
    }
    let maxValue = points.map { $0 }.max() ?? .zero
    var maxBoundaryValue = max(maxValue, stressBound)
    var minBoundaryValue = Double.zero
    if minBoundaryValue == maxBoundaryValue {
      minBoundaryValue -= 10
      maxBoundaryValue += 10
    }
    lineChartView.leftAxis.axisMaximum = maxBoundaryValue
    lineChartView.leftAxis.axisMinimum = minBoundaryValue
    addBoundaryView(topBoundaryView, offset: getOffsetForPoint(maxValue, maxValue: maxBoundaryValue, minValue: minBoundaryValue))
    addBoundaryView(centerBoundaryView, offset: getOffsetForPoint(stressBound, maxValue: maxBoundaryValue, minValue: minBoundaryValue))
    addBoundaryView(bottomBoundaryView, offset: getOffsetForPoint(minBoundaryValue, maxValue: maxBoundaryValue, minValue: minBoundaryValue))
  }
  
  private func configureChart(points: [Double], stressBound: Double) {
    setBoundaries(points: points, stressBound: stressBound)
    var entries = [ChartDataEntry]()
    for (index, point) in points.enumerated() {
      entries.append(ChartDataEntry(x: Double(index), y: Double(point)))
    }
    let set = LineChartDataSet(entries: entries)
    set.axisDependency = .left
    set.drawFilledEnabled = true
    set.highlightEnabled = false
    set.setColor(UIConstants.lineColor)
    if let gradient = CGGradient(colorsSpace: nil, colors: UIConstants.gradientColors as CFArray, locations: [0.0, 1.0]) {
      set.fill = LinearGradientFill(gradient: gradient, angle: 90.0)
    }
    set.drawCirclesEnabled = true
    set.drawOnlyFirstAndLastCirclesEnabled = true
    set.canCirclesOverlay = true
    set.lineWidth = UIConstants.lineWidth
    set.circleRadius = UIConstants.circleRadius
    set.circleColors = [UIConstants.lineColor]
    set.mode = .horizontalBezier
    let data = LineChartData(dataSet: set)
    data.setDrawValues(false)
    lineChartView.data = data
  }
  
  private func configureContainerView() {
    addSubview(containerView)
    containerView.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
      make.top.bottom.equalToSuperview()
        .inset(UIConstants.verticalOffset)
    }
    containerView.layer.masksToBounds = false
    containerView.clipsToBounds = false
  }
  
  private func configureLineChartView() {
    addSubview(lineChartView)
    lineChartView.backgroundColor = .clear
    lineChartView.leftAxis.drawLabelsEnabled = false
    lineChartView.minOffset = .zero
    lineChartView.rightAxis.drawAxisLineEnabled = false
    lineChartView.leftAxis.drawAxisLineEnabled = false
    lineChartView.leftAxis.drawGridLinesEnabled = false
    lineChartView.rightAxis.drawGridLinesEnabled = false
    lineChartView.rightAxis.drawLabelsEnabled = false
    lineChartView.xAxis.drawGridLinesEnabled = false
    lineChartView.xAxis.drawAxisLineEnabled = false
    lineChartView.xAxis.drawLabelsEnabled = false
    lineChartView.legend.enabled = false
    lineChartView.pinchZoomEnabled = false
    lineChartView.dragEnabled = false
    lineChartView.setScaleEnabled(false)
    lineChartView.extraTopOffset = UIConstants.verticalOffset
    lineChartView.extraBottomOffset = UIConstants.verticalOffset
    lineChartView.extraLeftOffset = UIConstants.circleRadius
    lineChartView.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
      make.top.bottom.equalToSuperview()
    }
  }
  
  private func addBoundaryView(_ view: ChartBoundaryView, offset: CGFloat) {
    containerView.addSubview(view)
    view.snp.makeConstraints { make in
      if offset.isZero {
        make.bottom.equalTo(containerView.snp.top)
      } else {
        switch view.position {
        case .top:
          make.top.equalTo(containerView.snp.centerY).multipliedBy(offset)
        case .bottom:
          make.bottom.equalTo(containerView.snp.centerY).multipliedBy(offset)
        }
      }
      make.left.right.equalToSuperview()
    }
  }
}

private enum UIConstants {
  static let boundaryGreenColor = UIColor.systemGreen
  static let boundaryRedColor = UIColor.systemRed.withAlphaComponent(0.6)
  static let boundaryBlueColor = UIColor.lightGray
  static let boundaryLightBlueColor = UIColor.systemBlue
  static let verticalOffset: CGFloat = 29
  static let gradientColors = [UIColor.clear.cgColor, UIColor.lightGray.withAlphaComponent(0.4).cgColor]
  static let lineColor = UIColor.darkGray.withAlphaComponent(0.7)
  static let lineWidth: CGFloat = 2
  static let circleRadius: CGFloat = 3
}

extension CGFloat {
  var radians: CGFloat {
    return self * .pi / 180.0
  }
}

extension Double {
 func rounded(toPlaces places: Int) -> Double {
   let divisor = pow(10.0, Double(places))
   return (self * divisor).rounded() / divisor
 }
 
 init(_ decimal: Decimal) {
   self = Double(truncating: decimal as NSNumber)
 }
}
