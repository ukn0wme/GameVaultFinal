//
//  LoreViewController.swift
//  GameVaultFinal
//
//  Created by Daniyal Nurgazinov on 25.12.2024.
//

import UIKit

class LoreViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var games: [Game] = []
    let searchBar = UISearchBar()

    // 1) Activity Indicator for showing a "fancy" loading animation
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white    // spinner color
        indicator.hidesWhenStopped = true
        return indicator
    }()

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

        // (B) Add the activity indicator as a subview
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center  // or use Auto Layout if you prefer

        // -- BACKGROUND COLOR FOR ENTIRE VIEW --
        view.backgroundColor = UIColor(named: "DarkBrown")

        // -- NAV BAR STYLING --
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 32, weight: .bold),
            .foregroundColor: UIColor.white
        ]

        // -- SEARCH BAR IN TITLE VIEW --
        navigationItem.titleView = searchBar
        searchBar.delegate = self

        // (C) Make the search bar text white
        if #available(iOS 13.0, *) {
            // iOS 13+ can directly access the searchTextField
            searchBar.searchTextField.textColor = .white
        } else {
            // Fallback for iOS 12 or below
            if let textField = searchBar.value(forKey: "searchField") as? UITextField {
                textField.textColor = .white
            }
        }

        // Fetch initial games (popular/recent)
        fetchInitialGames()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // If you want to ensure the spinner stays centered on rotations
        activityIndicator.center = view.center
    }

    // MARK: - API Calls

    private func fetchInitialGames() {
        // Show loading
        startLoadingAnimation()

        APIService.shared.fetchGames { [weak self] result in
            DispatchQueue.main.async {
                // Stop loading
                self?.stopLoadingAnimation()

                switch result {
                case .success(let fetchedGames):
                    self?.games = fetchedGames
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Failed to fetch initial games: \(error.localizedDescription)")
                }
            }
        }
    }

    private func performSearch(_ query: String) {
        // Show loading
        startLoadingAnimation()

        APIService.shared.searchGames(query: query) { [weak self] result in
            DispatchQueue.main.async {
                // Stop loading
                self?.stopLoadingAnimation()

                switch result {
                case .success(let searchedGames):
                    self?.games = searchedGames
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Failed to search games: \(error.localizedDescription)")
                }
            }
        }
    }

    // MARK: - Loading Animation Helpers

    private func startLoadingAnimation() {
        activityIndicator.startAnimating()
        // Optionally dim the tableView or disable interactions
        tableView.isUserInteractionEnabled = false
    }

    private func stopLoadingAnimation() {
        activityIndicator.stopAnimating()
        tableView.isUserInteractionEnabled = true
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension LoreViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameTableViewCell", for: indexPath) as? GameTableViewCell else {
            return UITableViewCell()
        }
        let game = games[indexPath.row]
        cell.configure(with: game)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGame = games[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailVC.game = selectedGame
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    // optional fade-in animation as cells appear
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.3,
                       delay: 0.05 * Double(indexPath.row),
                       options: .curveEaseIn,
                       animations: {
            cell.alpha = 1
        }, completion: nil)
    }
}

// MARK: - UISearchBarDelegate
extension LoreViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        performSearch(query)
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
    }
}
