//
//  Repository.swift
//  DigybiteTask
//
//  Created by Adel Aref on 29/11/2023.
//

import Foundation
import UIKit
import Alamofire

protocol Repository {
    var networkClient: APIRouter { get }
    func getData<T: Codable>(withRequest: URLRequest,
                              name: String?,
                              decodingType: T.Type,
                              completion: @escaping RepositoryCompletion)
}

extension Repository {
    typealias RepositoryCompletion = (RequestResult<Codable, RequestError>) -> Void
    func getData<T: Codable>(withRequest: URLRequest,
                              name: String?,
                              decodingType: T.Type,
                             completion: @escaping RepositoryCompletion) {
        networkClient.makeRequest(withRequest: withRequest, decodingType: decodingType) { (result) in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(.timeOut):
                showAlertConnectionError(withMessege: "The request timed out.")
            case .failure(.connectionError):
                showAlertConnectionError(withMessege: "No Internet connection.")
            case .failure(.jsonConversionFailure):
                print("jsonConversionFailure")
            default :
                completion(.failure(.invalidRequest))
                return
            }
            completion(result)
        }
    }
}
func showAlertConnectionError(withMessege: String) {
    let alertController =
        UIAlertController(title: nil, message: withMessege, preferredStyle: UIAlertController.Style.alert)
    let okAction =
        UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil)
    alertController.addAction(okAction)
    UIApplication.getTopViewController()?.present(alertController, animated: true, completion: nil)
}
