//
//  CharacterDetailViewController.swift
//  MarvelAPI
//
//  Created by Victor Luni on 26/02/24.
//

import UIKit
import Kingfisher

protocol CharacterDetailViewControllerDelegate: AnyObject {
    func updateFavorite(character: HomeCellDTO)
}

class CharacterDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var character: HomeCellDTO?
    weak var delegate: CharacterDetailViewControllerDelegate?
    
    // MARK: - UI Components
    
    private lazy var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(configureFavoriteButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        populateCharacterDetails()
        configureButtons()
        configureFavoriteButton()
    }
    
    // MARK: - UI Setup
    
    private func setupViews() {
        view.addSubview(characterImageView)
        view.addSubview(favoriteButton)
        view.addSubview(nameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(shareButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            characterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            characterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            characterImageView.heightAnchor.constraint(equalToConstant: 200),
            
            favoriteButton.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 20),
            favoriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30),
            
            nameLabel.topAnchor.constraint(equalTo: favoriteButton.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -10),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: characterImageView.trailingAnchor),
            
            shareButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shareButton.widthAnchor.constraint(equalToConstant: 30),
            shareButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func populateCharacterDetails() {
        guard let character = character else { return }
        nameLabel.text = character.title
        descriptionLabel.text = character.description
        guard let url = URL(string: character.image) else { return }
        characterImageView.kf.setImage(with: url)
    }
    
    @objc private func configureFavoriteButton() {
        if character!.hasFavorited {
            favoriteButton.setImage(UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    private func configureButtons() {
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Button Actions
    
    @objc private func favoriteButtonTapped() {
        guard var character = character else { return }
        let hasFavorited = character.hasFavorited
        character.hasFavorited = !hasFavorited
        if character.hasFavorited {
            favoriteButton.setImage(UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        
        delegate?.updateFavorite(character: character)
    }
    
    @objc private func shareButtonTapped() {
        guard let character = character, let image = characterImageView.image else { return }
        
        let activityViewController = UIActivityViewController(activityItems: [character.title, image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
        present(activityViewController, animated: true, completion: nil)
    }
}

