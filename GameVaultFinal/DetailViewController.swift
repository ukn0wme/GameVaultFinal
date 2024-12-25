//
//  DetailViewController.swift
//  GameVaultFinal
//
//  Created by Daniyal Nurgazinov on 25.12.2024.
//

import UIKit

class DetailViewController: UIViewController {
    
    var game: Game?

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var favoriteButton: UIButton!  // If you have a favorite button

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let game = game else { return }
        if FavoritesManager.shared.isFavorite(game) {
            favoriteButton.setTitle("Remove Favorite", for: .normal)
        } else {
            favoriteButton.setTitle("Add to Favorites", for: .normal)
        }
    }

    
    private func configureView() {
        // Set the text view to be read-only if you don't want the user to edit
        descriptionTextView.isEditable = false
        // If you’re not using the text view’s own scrolling:
        descriptionTextView.isScrollEnabled = false

        guard let game = game else { return }
        
        // Title
        titleLabel.text = game.name
        
        // Cover image (if needed, loaded asynchronously, e.g., via SDWebImage or Kingfisher)
        // if let urlString = game.backgroundImageURL, let url = URL(string: urlString) {
        //     coverImageView.kf.setImage(with: url)
        // }

        // Description
        descriptionTextView.text = game.description
    }

    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        guard let game = game else { return }
        
        if FavoritesManager.shared.isFavorite(game) {
            FavoritesManager.shared.removeFavorite(game)
        } else {
            FavoritesManager.shared.addFavorite(game)
        }
        updateFavoriteButton()
    }
    
    private func updateFavoriteButton() {
        guard let game = game else { return }
        
        if FavoritesManager.shared.isFavorite(game) {
            favoriteButton.setTitle("Remove Favorite", for: .normal)
        } else {
            favoriteButton.setTitle("Add to Favorites", for: .normal)
        }
    }
}
