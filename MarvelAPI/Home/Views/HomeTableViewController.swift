import Foundation
import UIKit

class HomeTableViewController: UIViewController {
    
    let viewModel = HomeViewModel()
    let favoriteViewModel = FavoriteViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    
    var errorView: ErrorView?
    
    private let tabBar: UITabBar = {
        let tabBar = UITabBar()
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        return tabBar
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.register(CharacterTableViewCell.self, forCellReuseIdentifier: "CharacterCell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backgroundColor = .white
        setupViews()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
            self.fetchIfNeeded()
    }
    
    func setupViews() {
        view.addSubview(tableView)
        view.addSubview(tabBar)
        
        setupViewConstraints()
        setupSearchBar()
        tableView.contentInsetAdjustmentBehavior = .automatic
    }
    
    func load() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    internal func dismissAlert() {
        if let vc = self.presentedViewController, vc is UIAlertController {
            dismiss(animated: false, completion: nil)
        }
    }
    
    func setupViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func setupSearchBar() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Characters"
        searchController.searchBar.backgroundColor = .white
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    
    func setupErrorView(errorType: NetworkError) {
        errorView = ErrorView()
        guard let errorView = errorView else { return }
        
        errorView.configure(with: errorType)
        errorView.delegate = self
        errorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorView)
        
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
    }
    
    func removeErrorView() {
        guard let errorView = errorView else { return }
        if errorView.isDescendant(of: view) {
            errorView.removeFromSuperview()
        }
    }
    
    func fetchIfNeeded(withQuery query: String = "") {
        removeErrorView()
        load()
        viewModel.fetchCharactersIfNeeded(offset: viewModel.offset, query: query) { [weak self] result in
            switch result {
            case .success:
                self?.tableView.reloadData()
                self?.dismissAlert()
            case .failure(let err):
                self?.setupErrorView(errorType: err)
                self?.dismissAlert()
            }
        }
    }
}

extension HomeTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as! CharacterTableViewCell
        let character = viewModel.characters[indexPath.row]
        cell.setup(dto: character)
        cell.delegate = self
        cell.handleFavorite(hasFavorited: character.hasFavorited)
        var queryIsEmpty = true
        if let query = searchController.searchBar.text?.isEmpty {
            queryIsEmpty = query
        }
        if viewModel.characters.count != 0 && viewModel.characters.count != 1 {
            if indexPath.row == viewModel.characters.count - 1 && queryIsEmpty { // last cell
                viewModel.offset += 20
                fetchIfNeeded()
            }
        }
        return cell
    }
}

extension HomeTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = viewModel.characters[indexPath.row]
        let detailVC = CharacterDetailViewController()
        detailVC.character = character
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension HomeTableViewController: CharacterTableViewCellDelegate {
    func handleTap(character: HomeCellDTO, cell: UITableViewCell) {
        guard let indexPathTapped = tableView.indexPath(for: cell) else { return }
        viewModel.handleFavorite(index: indexPathTapped.row)
        tableView.reloadRows(at: [indexPathTapped], with: .fade)
    }
}

extension HomeTableViewController: CharacterDetailViewControllerDelegate {
    func updateFavorite(character: HomeCellDTO) {
       guard let indexPath = viewModel.handleFavorite(character: character) else { return }
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
}

extension HomeTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.offset = 0
        fetchIfNeeded(withQuery: searchText)
    }
}

extension HomeTableViewController: ErrorViewDelegate {
    func retryButtonTapped() {
        viewModel.offset = 0
        fetchIfNeeded()
    }
}
