//
//  ProfileService.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.02.2023.
//

import KeychainAccess
import HealthKit

typealias JWTToken = String

class ProfileService {
  
  // MARK: - Public variables
  static let shared = ProfileService()
  
  // MARK: - Private variables
  private(set) var token: JWTToken? {
    get {
      return keychain[Constants.Keychain.token]
    }
    set {
      keychain[Constants.Keychain.token] = newValue
    }
  }
  
  private(set) var user: User? {
    get {
      return fetchedUser
    }
    set {
      let oldValue = fetchedUser
      if let newUser = newValue {
        fetchedUser = newUser
        CoreDataService.shared.save(user: newUser) { _ in }
      } else {
        fetchedUser = nil
        CoreDataService.shared.clearUserData { _ in }
      }
      if oldValue == nil {
        NotificationCenter.default.post(name: .userWasAuthorized, object: nil)
      }
      NotificationCenter.default.post(
        name: .userWasUpdated, object: nil,
        userInfo: [Notification.Key.isUserWasUpdated: newValue != nil && oldValue != nil])
    }
  }
    
  public var isUserAuthorized: Bool {
    return !token.isNilOrEmpty
  }
  
  // MARK: - Private variables
  private static let wasLoadedUserDefaultsKey = "wasLoadedUserDefaultsKey"
  private let keychain = Keychain(service: Constants.Keychain.name)
  private var fetchedUser = CoreDataService.shared.fetchUser()
  
  // MARK: - Life cycle
  private init() {
    if !UserDefaults.standard.bool(forKey: ProfileService.wasLoadedUserDefaultsKey) {
      keychain[Constants.Keychain.token] = nil
    }
    token = keychain[Constants.Keychain.token]
    UserDefaults.standard.set(true, forKey: ProfileService.wasLoadedUserDefaultsKey)
  }
  
  func auth(email: String,
            password: String,
            completion: @escaping (_ response: Result<User, Error>) -> Void) {
    AuthAPI.shared.auth(email: email, password: password) { result in
      switch result {
      case .success(let token):
        self.token = token
        self.getUser(completion: completion)
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  func register(email: String,
                password: String,
                nick: String,
                role: Role,
                fullName: String,
                birthday: String,
                gender: Gender,
                bloodType: HKBloodType,
                averagePressure: Double,
                workHoursCount: Int, completion: @escaping (_ response: Result<Any? , Error>) -> Void) {
    AuthAPI.shared.register(email: email, password: password, nick: nick, role: role, fullName: fullName, birthday: birthday, gender: gender, bloodType: bloodType, averagePressure: averagePressure, workHoursCount: workHoursCount) { result in
      switch result {
      case .success:
        completion(.success(nil))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  func getUser(completion: @escaping (_ response: Result<User, Error>) -> Void) {
    AuthAPI.shared.getUser { result in
      switch result {
      case .success(let user):
        self.user = user
        completion(.success(user))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  func update(email: String,
              nick: String,
              role: Role,
              fullName: String,
              birthday: String,
              gender: Gender,
              bloodType: HKBloodType,
              averagePressure: Double,
              workHoursCount: Int, completion: @escaping (_ response: Result<User , Error>) -> Void) {
    AuthAPI.shared.update(email: email, nick: nick, fullName: fullName, birthday: birthday, averagePressure: averagePressure, workHoursCount: workHoursCount, role: role, gender: gender, bloodType: bloodType) { result in
      switch result {
      case .success(let user):
        self.user = user
        completion(.success(user))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  func changePassword(password: String, completion: @escaping (_ response: Result<User , Error>) -> Void) {
    guard let user = ProfileService.shared.user else {
      completion(.failure(ServerError.unknown))
      return
    }
    let format = DateFormatter()
    format.dateFormat = "yyyy-MM-dd"
    AuthAPI.shared.changePassword(email: user.email, nick: user.nick, fullName: user.fullName, birthday: format.string(from: user.birthday), averagePressure: user.averagePressure, workHoursCount: user.workHoursCount, role: user.role, gender: user.gender, bloodType: user.bloodType, password: password) { result in
      switch result {
      case .success(let user):
        self.user = user
        completion(.success(user))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  func logout() {
    resetUser()
  }
  
  // MARK: - Private methods
  private func resetUser() {
    user = nil
    token = nil
    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    DispatchQueue.main.async {
      NotificationCenter.default.post(name: .logout, object: nil)
    }
  }
}
