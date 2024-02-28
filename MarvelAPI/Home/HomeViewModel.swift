//
//  HomeViewModel.swift
//  MarvelAPI
//
//  Created by Victor Luni on 23/02/24.
//

import Foundation
import UIKit

public class HomeViewModel {
    
    private let networkManager = NetworkManager()
    let endpoint = HomeEndpoint(offset: 0)
    var offset: Int = 0
    var characters: [HomeCellDTO] = []
    
    func filterFetchedDataWithFavorites(_ fetchedData: [HomeCellDTO]) -> [HomeCellDTO] {
        let favorites = FavoriteHandler.shared.retrieveFavorites()
        let favoriteIDs = Set(favorites.map { $0.id })
        let filteredData = fetchedData.map { character -> HomeCellDTO in
            if favoriteIDs.contains(character.id) {
                if let favorite = favorites.first(where: { $0.id == character.id }) {
                    return favorite
                }
            }
            return character
        }
        
        return filteredData
    }

    
    func fetchCharactersIfNeeded(offset: Int, query: String = "", completion: @escaping (Result<[HomeCellDTO], NetworkError>) -> Void) {
        var dtoList: [HomeCellDTO] = []
        
        guard let url = endpoint.getRequestURL(offset: offset, query: query) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        networkManager.makeRequest(to: url, offset: offset) { [weak self] (result: Result<MarvelCharacterResponse, NetworkError>) in
            switch result {
            case .success(let response):
                for character in response.data.results {
                    dtoList.append(HomeCellDTO(id: character.id,
                                               image: "\(character.thumbnail.path).\(character.thumbnail.extension)",
                                               title: character.name,
                                               description: character.description,
                                               hasFavorited: false))
                }
                let filteredData = self?.filterFetchedDataWithFavorites(dtoList)
                
                self?.handleResponse(query: query, data: filteredData ?? [])
                
                completion(.success(self?.characters ?? []))
            case .failure(let err):
                print(err)
                completion(.failure(err))
            }
        }
    }
    
    func handleResponse(query: String, data: [HomeCellDTO]) {
        if offset == 0 {
            characters = data
        } else {
            characters.append(contentsOf: data)
        }
    }
    
    func handleFavorite(index: Int) {
        let characterSelected = characters[index].hasFavorited
        characters[index].hasFavorited = !characterSelected
        
        if characters[index].hasFavorited {
            FavoriteHandler.shared.saveFavorite(character: characters[index])
        } else {
            FavoriteHandler.shared.removeFavorite(character: characters[index])
        }
    }
    
    func handleFavorite(character: HomeCellDTO) -> IndexPath? {
        if let index = characters.firstIndex(where: { $0.id == character.id }) {
            characters[index] = character
            let indexPath = IndexPath(row: index, section: 0)
            
            if characters[index].hasFavorited {
                FavoriteHandler.shared.saveFavorite(character: characters[index])
            } else {
                FavoriteHandler.shared.removeFavorite(character: characters[index])
            }
            
            return indexPath
            
        }
        return nil
    }
}
