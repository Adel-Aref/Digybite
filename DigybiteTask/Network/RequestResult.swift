//
//  RequestResult.swift
//  DigybiteTask
//
//  Created by Adel Aref on 29/11/2023.
//

import Foundation

public enum RequestResult<T, U> where U: Error {
    case success(T?)
    case failure(U)
}

enum HTTPMethod: String {
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

enum RequestError: Error {
    case unknownError
    case connectionError
    case authorizationError
    case invalidRequest
    case notFound
    case invalidResponse
    case serverError
    case serverUnavailable
    case jsonConversionFailure
    case timeOut
}
enum Strategy: String {
    case networkOnly
    case offlineOnly
    case offlineFirstFile
    case offlineFirstDatabase
}
