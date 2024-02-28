//
//  FavoritesViewController.swift
//  MarvelAPI
//
//  Created by Victor Luni on 27/02/24.
//

import Foundation
import UIKit
import CoreData

class FavoritesTableViewController: UITableViewController {

    let viewModel = FavoriteViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: "FavoriteCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchFavorites()
    }

    func fetchFavorites() {
        // Fetch favorites from CoreData and update the favorites array
        // Example:
        // favorites = CoreDataHelper.fetchFavorites()
        // Reload table view after fetching
        viewModel.fetchFavorites()
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favorites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! CharacterTableViewCell
        let favorite = viewModel.favorites[indexPath.row]
        cell.setup(dto: favorite)
        cell.delegate = self
        cell.handleFavorite(hasFavorited: favorite.hasFavorited)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = viewModel.favorites[indexPath.row]
        
        let detailVC = CharacterDetailViewController()
        detailVC.character = character
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension FavoritesTableViewController: CharacterDetailViewControllerDelegate {
    func updateFavorite(character: HomeCellDTO) {
        guard let indexPath = viewModel.handleFavorite(character: character) else { return }
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
}

extension FavoritesTableViewController: CharacterTableViewCellDelegate {
    func handleTap(character: HomeCellDTO, cell: UITableViewCell) {
        guard let indexPathTapped = tableView.indexPath(for: cell) else { return }
        viewModel.handleFavorite(index: indexPathTapped.row)
        tableView.reloadRows(at: [indexPathTapped], with: .fade)
    }
}
