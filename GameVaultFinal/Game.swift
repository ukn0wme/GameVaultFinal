//
//  Game.swift
//  GameVaultFinal
//
//  Created by Daniyal Nurgazinov on 25.12.2024.
//

import Foundation

struct Game: Codable, Equatable {
    let id: Int
    let name: String
    let description: String?  // RAWG doesn’t always return the full description here
    let released: String?
    let backgroundImageURL: String?
    
    // Map "background_image" in JSON to "backgroundImageURL" in Swift
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case released
        case backgroundImageURL = "background_image"
    }
}
