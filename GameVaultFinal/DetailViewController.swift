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
    @IBOutlet weak var favoriteButton: UIButton!

    // We’ll also store the full detail struct
    private var gameDetail: GameDetail?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Basic UI styling
        view.backgroundColor = UIColor(named: "DarkBrown")

        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = .white

        descriptionTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descriptionTextView.textColor = .white
        descriptionTextView.backgroundColor = .clear

        favoriteButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        favoriteButton.setTitleColor(.white, for: .normal)
        favoriteButton.backgroundColor = UIColor(named: "AccentColor")
        favoriteButton.layer.cornerRadius = 8

        // Show partial data from the list’s Game object
        if let game = game {
            titleLabel.text = game.name
            if let urlString = game.backgroundImageURL, let url = URL(string: urlString) {
                loadImage(from: url, into: coverImageView)
            } else {
                coverImageView.image = UIImage(named: "placeholder")
            }
        }

        updateFavoriteButton()

        // Now fetch the real, expanded details (including the actual description)
        fetchDetailData()
    }

    private func fetchDetailData() {
        guard let gameId = game?.id else {
            print("DetailViewController: game id is nil, can't fetch details.")
            return
        }
        APIService.shared.fetchGameDetails(gameId: gameId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let detail):
                    self?.gameDetail = detail
                    self?.updateUI(with: detail)
                case .failure(let error):
                    print("Failed to fetch game detail:", error.localizedDescription)
                    self?.descriptionTextView.text = "No description available"
                }
            }
        }
    }

    private func updateUI(with detail: GameDetail) {
        // detail.name might match, or could be more complete
        titleLabel.text = detail.name
        // Show the real description from description_raw
        descriptionTextView.text = detail.descriptionRaw ?? "No description available"

        // Possibly a better or different background image
        if let bgURLString = detail.backgroundImageURL, let bgURL = URL(string: bgURLString) {
            loadImage(from: bgURL, into: coverImageView)
        }
    }

    private func loadImage(from url: URL, into imageView: UIImageView) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }.resume()
    }

    // MARK: - Favorites Logic
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
        let isFav = FavoritesManager.shared.isFavorite(game)
        favoriteButton.setTitle(isFav ? "Remove Favorite" : "Add to Favorites", for: .normal)
    }
}
