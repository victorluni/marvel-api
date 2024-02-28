//
//  FavoriteViewModel.swift
//  MarvelAPI
//
//  Created by Victor Luni on 27/02/24.
//

import Foundation

final class FavoriteViewModel {
    
    var favorites: [HomeCellDTO] = []
    
    func fetchFavorites() {
        favorites = FavoriteHandler.shared.retrieveFavorites()
    }
    
    func handleFavorite(index: Int) {
        let characterSelected = favorites[index].hasFavorited
        favorites[index].hasFavorited = !characterSelected
        
        if favorites[index].hasFavorited {
            FavoriteHandler.shared.saveFavorite(character: favorites[index])
        } else {
            FavoriteHandler.shared.removeFavorite(character: favorites[index])
        }
    }
    
    
    func handleFavorite(character: HomeCellDTO) -> IndexPath? {
        
        if let index = favorites.firstIndex(where: { $0.id == character.id }) {
            favorites[index] = character
            let indexPath = IndexPath(row: index, section: 0)
            
            if favorites[index].hasFavorited {
                FavoriteHandler.shared.saveFavorite(character: favorites[index])
            } else {
                FavoriteHandler.shared.removeFavorite(character: favorites[index])
            }
            return indexPath
        }
        return nil
    }
}
