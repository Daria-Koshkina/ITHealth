//
//  ReachabilityService.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 19.02.2023.
//

import Reachability

class ReachabilityService {
  
  // MARK: - Public variables
  static let shared = ReachabilityService()
  
  var isInternetAvailable: Bool {
    guard let reachability = reachability else { return false }
    return reachability.connection != .unavailable
  }
  
  // MARK: - Private variables
  private let reachability = try? Reachability()
  
  // MARK: - Life cycle
  init() {
    setup()
    startListenReachabilityStatus()
    setupAppStateListeners()
  }
  
  // MARK: - Init configure
  
  private func setup() {
    reachability?.allowsCellularConnection = true
    do {
      try reachability?.startNotifier()
    } catch {
      print("Unable to start notifier")
    }
  }
  
  // MARK: - Private
  private func startListenReachabilityStatus() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(reachabilityChanged),
                                           name: Notification.Name.reachabilityChanged,
                                           object: nil)
  }
  
  private func setupAppStateListeners() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(appDidBecomeActive),
                                           name: UIApplication.didBecomeActiveNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(appDidEnterBackground),
                                           name: UIApplication.didEnterBackgroundNotification,
                                           object: nil)
  }
  
  @objc
  private func reachabilityChanged(note: Notification) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      if self.isInternetAvailable {
        self.postNetworkBecomeAvailable()
      } else {
        self.postNetworkBecomeNotAvailable()
      }
    }
  }
  
  @objc
  private func appDidBecomeActive() {
    try? reachability?.startNotifier()
  }
  
  @objc
  private func appDidEnterBackground() {
    reachability?.stopNotifier()
  }
  
  private func postNetworkBecomeAvailable() {
    NotificationCenter.default.post(name: Notification.Name.networkBecomeAvailable,
                                    object: nil)
  }
  
  private func postNetworkBecomeNotAvailable() {
    NotificationCenter.default.post(name: Notification.Name.networkBecomeNotAvailable,
                                    object: nil)
  }
}

