//
//  FavoritesViewController.swift
//  GameVaultFinal
//
//  Created by Daniyal Nurgazinov on 25.12.2024.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    // This array holds the user’s favorited games
    var favoriteGames: [Game] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // -- TABLE VIEW SETUP --
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100

        // (A) Make the TableView background DarkBrown
        tableView.backgroundColor = UIColor(named: "DarkBrown")
        // Additionally, if you want the cell background to blend in,
        // in GameTableViewCell, do: contentView.backgroundColor = .clear or a matching color.

        // -- BACKGROUND COLOR FOR ENTIRE VIEW (IF DESIRED) --
        view.backgroundColor = UIColor(named: "DarkBrown")

        // -- NAV BAR STYLING --
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 32, weight: .bold),
            .foregroundColor: UIColor.white
        ]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Each time this tab appears, load favorites from UserDefaults
        favoriteGames = FavoritesManager.shared.loadFavorites()
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {

    // Number of rows equals how many favorites the user has
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteGames.count
    }

    // Dequeue our custom cell (GameTableViewCell) and configure with the favorited game
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameTableViewCell", for: indexPath) as? GameTableViewCell else {
            return UITableViewCell()
        }
        let game = favoriteGames[indexPath.row]
        cell.configure(with: game)
        return cell
    }

    // When a row is tapped, go to the DetailViewController for that favorited game
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGame = favoriteGames[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailVC.game = selectedGame
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    // Optional: animate cells as they appear (fade in)
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.3,
                       delay: 0.05 * Double(indexPath.row),
                       options: .curveEaseIn,
                       animations: {
            cell.alpha = 1
        }, completion: nil)
    }

    // Optional: swipe to remove a favorite directly from this list
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let gameToRemove = favoriteGames[indexPath.row]
            // Remove from FavoritesManager
            FavoritesManager.shared.removeFavorite(gameToRemove)
            // Update local array
            favoriteGames.remove(at: indexPath.row)
            // Delete row with an animation
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
