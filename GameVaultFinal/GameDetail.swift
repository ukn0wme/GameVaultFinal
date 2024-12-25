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
