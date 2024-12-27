//
//  GameTableViewCell.swift
//  GameVaultFinal
//
//  Created by Daniyal Nurgazinov on 25.12.2024.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    // Called when the cell is loaded from nib/storyboard
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // To get the BKG from white to the one I have in TableView
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        // Rounded corners on the cell’s content
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true

        // Drop shadow around the cell (on the cell’s own layer)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 4
        layer.masksToBounds = false

        // System font styling for the label
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .white  // choose your color
    }

    // We'll call this from LoreViewController / FavoritesViewController
    func configure(with game: Game) {
        titleLabel.text = game.name
        // If you have an image URL
        if let urlString = game.backgroundImageURL, let url = URL(string: urlString) {
            loadImage(from: url, into: coverImageView)
        } else {
            coverImageView.image = UIImage(named: "placeholder")
        }
    }

    private func loadImage(from url: URL, into imageView: UIImageView) {
        // Basic approach with no caching
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }.resume()
    }
}
