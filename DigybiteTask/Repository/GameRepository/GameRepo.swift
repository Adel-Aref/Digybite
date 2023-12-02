//
//  GameRepo.swift
//  DigybiteTask
//
//  Created by Adel Aref on 30/11/2023.
//

import Foundation
class GameRepo: Repository {
    var networkClient: APIRouter

    public init(_ client: APIRouter = NetworkClient()) {
        networkClient = client
    }
    
    func getGameList( searchText: String, completion: @escaping RepositoryCompletion) {
        guard let url = Endpoint.getGameList( searchText: searchText).url else { return }
        if let request = makeRequest(url: url, headers: nil, parameters: nil, query: nil, type: .get) {
            getData(withRequest: request,
                    decodingType: DigybiteResponse<[GameModel]>.self,
                    completion: completion)
        }
    }
    
    func getGameByGameID(id: Int32, completion: @escaping RepositoryCompletion) {
        guard let url = Endpoint.getGameByGameID(id: id).url else { return }
        if let request = makeRequest(url: url, headers: nil, parameters: nil, query: nil, type: .get) {
            getData(withRequest: request,
                    decodingType: GameModel.self,
                    completion: completion)
        }
    }
}
