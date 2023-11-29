//
//  APIRouter.swift
//  DigybiteTask
//
//  Created by Adel Aref on 29/11/2023.
//

import Foundation

import Alamofire
// swiftlint:disable all
protocol APIRouter {
    func makeRequest<T: Codable>(withRequest: URLRequest,
                                  decodingType: T.Type,
                                  completion: @escaping JSONTaskCompletionHandler)  where T: Codable
}

extension APIRouter {
    typealias JSONTaskCompletionHandler = (RequestResult<Codable, RequestError>) -> Void
    
    func makeRequest<T: Codable>(withRequest: URLRequest,
                                  decodingType: T.Type,
                                  completion: @escaping JSONTaskCompletionHandler)  where T: Codable {
        AF.request(withRequest)
            .responseJSON(completionHandler: { (response) in
                if let error = response.error {
                    if error.localizedDescription == "The request timed out." {
                        completion(.failure(.timeOut))
                    } else {
                        completion(.failure(.connectionError))
                    }
                } else if let data = response.data {
                    print(response)
                    if let code = response.response?.statusCode {
                        switch code {
                        case 200:
                            self.decodeJsonResponse(
                                decodingType: decodingType,
                                jsonObject: data,
                                completion: completion)
                        case 400 ... 499:
                            completion(.failure(.authorizationError))
                        case 500 ... 599:
                            completion(.failure(.serverError))
                        default:
                            completion(.failure(.unknownError))
                        }
                    }
                }
            })
    }
    func decodeJsonResponse<T: Codable>(decodingType: T.Type,
                                         jsonObject: Data,
                                         completion: @escaping JSONTaskCompletionHandler) where T: Codable {
        do {
            var genericModel = try JSONDecoder().decode(decodingType, from: jsonObject)
            completion(.success(genericModel))
        } catch {
            completion(.failure(.jsonConversionFailure))
        }
    }
}

// flyable make request function to prepare the request
func makeRequest(url: URL, headers: Any?, parameters: Any?, query: [URLQueryItem]?, type: HTTPMethod) -> URLRequest? {
    print(url.absoluteURL)


    var urll = URLComponents(url: url, resolvingAgainstBaseURL: true)
    if let query = query {
        urll?.queryItems = query
    }
    guard let finalURL = urll?.url else { return nil }
    var urlRequest = URLRequest(url: finalURL, timeoutInterval: 10)
    do {
        urlRequest.httpMethod = type.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let parameters = parameters {
            urlRequest.httpBody   = try JSONSerialization.data(withJSONObject: parameters)
        }
        if let headers = headers as? [String: String] {
            urlRequest.allHTTPHeaderFields = headers
        }
        return urlRequest
    } catch let error {
        print("Error : \(error.localizedDescription)")
    }
    return urlRequest
}
