//
//  HomeCharacterCell.swift
//  MarvelAPI
//
//  Created by Victor Luni on 23/02/24.
//

import Foundation
import UIKit
import Kingfisher

protocol CharacterTableViewCellDelegate: AnyObject {
    func handleTap(character: HomeCellDTO, cell: UITableViewCell)
}

class CharacterTableViewCell: UITableViewCell {
    // MARK: - Properties
    private lazy var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var characterTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        return button
    }()
    
    
    weak var delegate: CharacterTableViewCellDelegate?
    private var data: HomeCellDTO?
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(dto: HomeCellDTO) {
        characterTitleLabel.text = dto.title
        guard let url = URL(string: dto.image) else { return }
        handleFavorite(hasFavorited: dto.hasFavorited)
        characterImageView.kf.setImage(with: url)
        data = dto
    }
    
    func handleFavorite(hasFavorited: Bool) {
        if hasFavorited {
            favoriteButton.setImage(UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    @objc func handleTap() {
        guard let data = data else { return }
        delegate?.handleTap(character: data, cell: self)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        contentView.addSubview(characterImageView)
        contentView.addSubview(characterTitleLabel)
        contentView.addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            // Image View
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            characterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            characterImageView.widthAnchor.constraint(equalToConstant: 80),
            characterImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Title Label
            characterTitleLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 16),
            characterTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            characterTitleLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -16),
            
            // Favorite Button
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favoriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}

