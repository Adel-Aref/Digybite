//
//  NETWORK+ENDPOINTS.swift
//  DigybiteTask
//
//  Created by Adel Aref on 29/11/2023.
//

import Foundation

extension Endpoint {
    static func getGameList(page: Int, searchText: String) -> Endpoint {
        let path = "games?key=\(Environment.apiKey)&page_size=10&page=\(page)&search=\(searchText)"
        return Endpoint(base: Environment.baseURL, path: path)
    }
    
    static func getGameByGameID(id: Int) -> Endpoint {
        let path = "games/\(id)?key=\(Environment.apiKey)"
        return Endpoint(base: Environment.baseURL, path: path)
    }
}

