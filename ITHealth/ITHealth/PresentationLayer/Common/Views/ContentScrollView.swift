//
//  ContentScrollView.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 30.04.2023.
//

import UIKit
import SnapKit

class ContentScrollView: InitView {
  
  // MARK: Elements
  let contentView = UIView()
  let scrollView = UIScrollView()
  
  // MARK: Init configure
  override func initConfigure() {
    super.initConfigure()
    configureScrollView()
    configureContentView()
  }
  
  private func configureScrollView() {
    addSubview(scrollView)
    scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    scrollView.showsVerticalScrollIndicator = false
    scrollView.keyboardDismissMode = .onDrag
  }
  
  private func configureContentView() {
    scrollView.addSubview(contentView)
    contentView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
      make.width.equalToSuperview()
    }
  }
  
}

