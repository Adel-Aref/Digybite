//
//  GameModel.swift
//  DigybiteTask
//
//  Created by Adel Aref on 30/11/2023.
//

import Foundation
import RealmSwift

struct GameModel: Codable {
    let id: Int
    let name: String?
    let backgroundImage: String?
    let description: String?
    let website: String?
    let redditUrl: String?
    let genres: [GenreModel]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, website, genres
        case backgroundImage = "background_image"
        case redditUrl = "reddit_url"
    }
    
    func mapToGameRealmModel() -> GameRealmModel {
        let gameRealm: GameRealmModel = GameRealmModel()
        gameRealm.id = String(id)
        gameRealm.name = name
        gameRealm.backgroundImage = backgroundImage
        gameRealm.gameDescription = description
        gameRealm.website = website
        gameRealm.redditUrl = redditUrl
        gameRealm.genres = genres
        return gameRealm
    }
}

struct GenreModel: Codable {
    let id: Int
    let name: String?
}

class GameRealmModel: Object, Codable {
    @objc dynamic var id = ""
    @objc dynamic var name: String?
    @objc dynamic var backgroundImage: String?
    @objc dynamic var gameDescription: String?
    @objc dynamic var website: String?
    @objc dynamic var redditUrl: String?
    var genres: [GenreModel]?

    override class func primaryKey() -> String? {
        return "id"
    }
}

