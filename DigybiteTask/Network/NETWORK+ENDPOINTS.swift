//
//  NETWORK+ENDPOINTS.swift
//  DigybiteTask
//
//  Created by Adel Aref on 29/11/2023.
//

import Foundation

extension Endpoint {
    static func getMovies(page: Int) -> Endpoint {
        let path = "/movie/now_playing?api_key=\(Environment.apiKey)&page=\(page)"
        return Endpoint(base: Environment.baseURL, path: path)
    }
}
