//
//  ViewsFactory.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.05.2023.
//

import UIKit

class ViewsFactory {
  class func getEmptyChartBoundaryView(
    position: BoundaryLinePosition,
    color: UIColor = UIColor.darkGray) -> ChartBoundaryView {
      let view = ChartBoundaryView()
      view.configure(position: position, color: color)
      view.configure(leftTitle: nil, rightTitle: nil)
      return view
    }
}
