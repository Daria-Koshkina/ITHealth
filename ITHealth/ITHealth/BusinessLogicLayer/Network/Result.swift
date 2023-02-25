//
//  Result.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 19.02.2023.
//

import Foundation

enum Result<T, Error> {
  case success(T)
  case failure(Error)
  
  var isSuccess: Bool {
    switch self {
    case .success:
      return true
    case .failure:
      return false
    }
  }
  
  public var isFailure: Bool {
    return !isSuccess
  }
  
  var error: Error? {
    switch self {
    case .success:
      return nil
    case .failure(let error):
      return error
    }
  }
  
  var value: T? {
    switch self {
    case .success(let value):
      return value
    case .failure:
      return nil
    }
  }
}
