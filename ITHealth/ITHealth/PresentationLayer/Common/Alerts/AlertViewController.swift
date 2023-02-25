//
//  AlertViewController.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.02.2023.
//

import UIKit
import SwiftUI

enum State {
  case open
  case closed
  
  var opposite: State {
    switch self {
      case .open:
        return .closed
      case .closed:
        return .open
    }
  }
}

class AlertViewController: InitViewController {
  
  // MARK: - Private variables
  private let selfView: AlertView
  private var currentState: State = .closed
  private var transitionAnimator: UIViewPropertyAnimator?
  private var animationProgress: CGFloat = 0
  private let duration = 0.4
  
  // MARK: - Life cycle
  init(view: AlertViewProtocol) {
    selfView = AlertView(view: view)
    super.init()
    selfView.containerView.delegate = self
  }
  
  override func loadView() {
    view = selfView
  }
  
  override func initConfigure() {
    super.initConfigure()
    addGesture()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    animateTransitionIfNeeded(to: .open, duration: duration)
  }
  
  // MARK: - Animation
  
  private func addGesture() {
    let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(popupViewPanned(recognizer:)))
    selfView.containerView.addGestureRecognizer(panRecognizer)
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideAlert))
    selfView.blurView.addGestureRecognizer(tapRecognizer)
  }
  
  private func animateTransitionIfNeeded(to state: State,
                                         duration: TimeInterval,
                                         completion: @escaping (() -> Void) = {}) {
    if transitionAnimator != nil { return }
    transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
      switch state {
        case .open:
          self.selfView.blurView.alpha = 0.7
          self.selfView.showView()
        case .closed:
          self.selfView.hideView()
          self.selfView.blurView.alpha = 0
      }
      self.view.layoutIfNeeded()
    })
    
    transitionAnimator?.addCompletion { position in
      switch position {
        case .start:
          self.currentState = state.opposite
        case .end:
          self.currentState = state
        case .current:
          ()
        @unknown default:
          ()
      }
      switch self.currentState {
        case .open:
          self.selfView.showView()
        case .closed:
          self.selfView.hideView()
      }
      self.transitionAnimator = nil
      completion()
      if self.currentState == .closed {
        self.dismiss(animated: false)
      }
    }
    
    transitionAnimator?.startAnimation()
  }
  
  @objc
  private func hideAlert() {
    animateTransitionIfNeeded(to: .closed, duration: duration)
  }
  
  @objc private func popupViewPanned(recognizer: UIPanGestureRecognizer) {
    switch recognizer.state {
      case .began:
        animateTransitionIfNeeded(to: currentState.opposite, duration: duration)
        transitionAnimator?.pauseAnimation()
        animationProgress = transitionAnimator?.fractionComplete ?? .zero
      case .changed:
        guard let transitionAnimator = transitionAnimator else { return }
        let translation = recognizer.translation(in: selfView.containerView)
        var fraction = -translation.y / selfView.containerView.bounds.height
        
        if currentState == .open { fraction *= -1 }
        if transitionAnimator.isReversed { fraction *= -1 }
        
        transitionAnimator.fractionComplete = fraction + animationProgress
      case .ended:
        guard let transitionAnimator = transitionAnimator else { return }
        let yVelocity = recognizer.velocity(in: selfView.containerView).y
        let shouldClose = yVelocity > 0
        
        if yVelocity == 0 {
          transitionAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
          break
        }
        
        switch currentState {
          case .open:
            if !shouldClose && !transitionAnimator.isReversed { transitionAnimator.isReversed.toggle() }
            if shouldClose && transitionAnimator.isReversed { transitionAnimator.isReversed.toggle() }
          case .closed:
            if shouldClose && !transitionAnimator.isReversed { transitionAnimator.isReversed.toggle() }
            if !shouldClose && transitionAnimator.isReversed { transitionAnimator.isReversed.toggle() }
        }
        transitionAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        
      default:
        ()
    }
  }
}

// MARK: - AlertViewDelegate
extension AlertViewController: AlertViewDelegate {
  func hideView(completion: @escaping () -> Void) {
    animateTransitionIfNeeded(to: .closed, duration: duration, completion: completion)
  }
}
