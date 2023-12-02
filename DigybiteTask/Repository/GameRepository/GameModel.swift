//
//  GameModel.swift
//  DigybiteTask
//
//  Created by Adel Aref on 30/11/2023.
//

import Foundation
import CoreData

struct GameModel: Codable {
    var id: Int32 = 0
    var name: String?
    var backgroundImage: String?
    var description: String?
    var website: String?
    var redditUrl: String?
    var genres: [GenreModel]?
    var isFavorite: Bool? = false
    var isRead: Bool? = false
    enum CodingKeys: String, CodingKey {
        case id, name, description, website, genres
        case backgroundImage = "background_image"
        case redditUrl = "reddit_url"
    }
}

struct GenreModel: Codable {
    let id: Int32
    let name: String?
    
    init(from entity: GenreEntity) {
        self.id = entity.id
        self.name = entity.name
    }
}
