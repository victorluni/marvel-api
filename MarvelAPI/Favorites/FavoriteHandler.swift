//
//  FavoriteHandler.swift
//  MarvelAPI
//
//  Created by Victor Luni on 27/02/24.
//

import Foundation
import UIKit
import CoreData

import Foundation

class FavoriteHandler {
    static let shared = FavoriteHandler()
    
    private let favoritesKey = "FavoriteCharacters"
    
    private init() {}
    
    func saveFavorite(character: HomeCellDTO) {
        var favorites = retrieveFavorites()
        if !favorites.contains(character) {
            favorites.append(character)
            saveFavorites(favorites)
        }
    }
    
    func removeFavorite(character: HomeCellDTO) {
        var favorites = retrieveFavorites()
        if let index = favorites.firstIndex(of: character) {
            favorites.remove(at: index)
            saveFavorites(favorites)
        }
    }
    
    func retrieveFavorites() -> [HomeCellDTO] {
        if let data = UserDefaults.standard.data(forKey: favoritesKey) {
            if let favorites = try? JSONDecoder().decode([HomeCellDTO].self, from: data) {
                return favorites
            }
        }
        return []
    }
    
    private func saveFavorites(_ favorites: [HomeCellDTO]) {
        if let encodedData = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encodedData, forKey: favoritesKey)
        }
    }
}
