//
//  HomeModel.swift
//  MarvelAPI
//
//  Created by Victor Luni on 23/02/24.
//

import Foundation
import UIKit

struct MarvelCharacterResponse: Codable {
    let code: Int
    let status: String
    let copyright: String
    let attributionText: String
    let attributionHTML: String
    let data: CharacterDataContainer
    let etag: String
}

struct CharacterDataContainer: Codable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [MarvelCharacter]
}

struct MarvelCharacter: Codable {
    let id: Int
    let name: String
    let description: String
    let modified: String
    let resourceURI: String
    let urls: [MarvelCharacterURL]
    let thumbnail: MarvelCharacterThumbnail
    let comics: MarvelCharacterCollection
    let stories: MarvelCharacterCollection
    let events: MarvelCharacterCollection
    let series: MarvelCharacterCollection
}

struct MarvelCharacterURL: Codable {
    let type: String
    let url: String
}

struct MarvelCharacterThumbnail: Codable {
    let path: String
    let `extension`: String
}

struct MarvelCharacterCollection: Codable {
    let available: Int
    let returned: Int
    let collectionURI: String
    let items: [MarvelCharacterItem]
}

struct MarvelCharacterItem: Codable {
    let resourceURI: String
    let name: String
    let type: String?
}

struct HomeCellDTO: Codable, Equatable {
    let id: Int
    let image: String
    let title: String
    let description: String
    var hasFavorited: Bool
    
    // Implement Equatable
    static func == (lhs: HomeCellDTO, rhs: HomeCellDTO) -> Bool {
        return lhs.id == rhs.id // Compare based on ID
        // You may need to compare other properties if needed
    }
}
