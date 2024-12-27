//
//  GameDetail.swift
//  GameVaultFinal
//
//  Created by Daniyal Nurgazinov on 25.12.2024.
//


struct GameDetail: Codable {
    let id: Int
    let name: String
    let descriptionRaw: String?
    let backgroundImageURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case descriptionRaw = "description_raw"
        case backgroundImageURL = "background_image"
    }
}
