//
//  FavoritesManager.swift
//  GameVaultFinal
//
//  Created by Daniyal Nurgazinov on 25.12.2024.
//

import Foundation

class FavoritesManager {
    static let shared = FavoritesManager()
    private init() {}
    
    private let favoritesKey = "favoriteGames" // Key used in UserDefaults
    private let defaults = UserDefaults.standard
    
    // 1) Load favorites from UserDefaults
    func loadFavorites() -> [Game] {
        guard let data = defaults.data(forKey: favoritesKey),
              let games = try? JSONDecoder().decode([Game].self, from: data) else {
            return []
        }
        return games
    }
    
    // 2) Save an array of Game objects to UserDefaults
    func saveFavorites(_ games: [Game]) {
        if let data = try? JSONEncoder().encode(games) {
            defaults.set(data, forKey: favoritesKey)
        }
    }
    
    // 3) Check if a game is already in favorites
    func isFavorite(_ game: Game) -> Bool {
        let favorites = loadFavorites()
        return favorites.contains { $0.id == game.id }
    }
    
    // 4) Add a new game to favorites
    func addFavorite(_ game: Game) {
        var favorites = loadFavorites()
        // Only add if not already present
        if !favorites.contains(where: { $0.id == game.id }) {
            favorites.append(game)
            saveFavorites(favorites)
        }
    }
    
    // 5) Remove a game from favorites
    func removeFavorite(_ game: Game) {
        var favorites = loadFavorites()
        favorites.removeAll { $0.id == game.id }
        saveFavorites(favorites)
    }
}
