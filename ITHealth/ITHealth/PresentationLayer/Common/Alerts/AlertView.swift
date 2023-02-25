//
//  AlertView.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.02.2023.
//

import UIKit

protocol AlertViewDelegate: AnyObject {
  func hideView(completion: @escaping () -> Void)
}

protocol AlertViewProtocol where Self: InitView {
  var delegate: AlertViewDelegate? { get set }
}

class AlertView: InitView {
  
  // MARK: - Public variables
  let blurView = UIView()
  let containerView: AlertViewProtocol
  
  // MARK: - Life cycle
  init(view: AlertViewProtocol) {
    self.containerView = view
    super.init()
  }
  
  required init() {
    fatalError("init() has not been implemented")
  }
  
  override func initConfigure() {
    super.initConfigure()
    backgroundColor = .clear
    blurViewConfigure()
    containerViewConfigure()
  }
  
  private func blurViewConfigure() {
    insertSubview(blurView, at: 0)
    blurView.backgroundColor = .black
    blurView.alpha = .zero
    
    blurView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func containerViewConfigure() {
    addSubview(containerView)
    containerView.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
      make.bottom.equalToSuperview()
        .offset(UIScreen.main.bounds.height)
    }
  }
  
  // MARK: - Interface
  func showView() {
    containerView.snp.updateConstraints { make in
      make.bottom.equalToSuperview()
        .offset(0)
    }
  }
  
  func hideView() {
    containerView.snp.updateConstraints { make in
      make.bottom.equalToSuperview()
        .offset(containerView.bounds.height)
    }
  }
}
