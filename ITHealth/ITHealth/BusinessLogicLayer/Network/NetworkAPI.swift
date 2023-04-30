//
//  NetworkAPI.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 19.02.2023.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkAPI: NSObject {
  
  // MARK: - Public methods
  func alamofireRequest(endpoint: String,
                        method: HTTPMethod,
                        parameters: [String: Any],
                        headers: HTTPHeaders = HTTPHeaders([]),
                        isRefresh: Bool = false,
                        completion: @escaping (AFDataResponse<Any>) -> Void) {
    let encodingType: ParameterEncoding = (method == .get) ? URLEncoding.default : JSONEncoding.default
    let requestURL = Constants.baseURL + endpoint
    var headers = headers
    //    headers[NetworkRequestKey.acceptLanguage] = LocalizationService.shared.language.languageCode
    if let token = ProfileService.shared.token {
      headers[NetworkRequestKey.authorization] = "Bearer " + token
    } else {
      headers[NetworkRequestKey.authorization] = nil
    }
    headers["Accept-Language"] = "uk-UA"
    debugPrint(" ☄️ REQUEST >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
    debugPrint(" ☄️ >>> Path >>>:", requestURL)
    debugPrint(" ☄️ >>> Headers >>>:", headers)
    debugPrint(" ☄️ >>> Parameters >>>:", parameters)
    AF.request(requestURL,
               method: method,
               parameters: parameters,
               encoding: encodingType,
               headers: headers).responseJSON { [weak self] dataResponse in
      guard let self = self else { return }
      let parsedResult = self.parseResponse(dataResponse, showDebugInfo: true)
      completion(dataResponse)
    }
  }
  
  func parseResponse(_ response: DataResponse<Any, AFError>, showDebugInfo: Bool = false) -> Result<JSON, Error> {
    let data = JSON(response.value as Any)
    guard let statusCode = response.response?.statusCode else {
      return .failure(ServerError.unknown)
    }
    if showDebugInfo {
      debugPrint("⬇️ RESPONSE: \(response.request?.url?.absoluteString ?? "") Code – [ \(statusCode) ] >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
    }
    if !(200..<300).contains(statusCode) {
      let error = ServerError(type: statusCode, json: data)
      if showDebugInfo {
        debugPrint("❌ FAILURE: Error – \(error.title) >>> \(error.description) >>> \(String(describing: response.error))")
        print("\n\n\n\n\n\n")
      }
      return .failure(error)
    }
    if showDebugInfo {
      debugPrint("✅ SUCCESS: JSON")
      debugPrint(data)
      debugPrint("⬆️ END RESPONSE >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
      print("\n\n\n\n\n\n")
    }
    return .success(data)
  }
}

