//
//  APIService.swift
//  GameVaultFinal
//
//  Created by Daniyal Nurgazinov on 25.12.2024.
//

import Foundation

struct GamesResponse: Codable {
    let results: [Game]
}

class APIService {
    static let shared = APIService()
    private init() {}
    
    func fetchGames(completion: @escaping (Result<[Game], Error>) -> Void) {
        // Use your real key below
        let urlString = "https://api.rawg.io/api/games?key=db2267db73124ba4847c42a85449c8cf&page_size=20"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                // No data, construct a simple error or handle gracefully
                return
            }
            
            do {
                let decoder = JSONDecoder()
                // If the date format is relevant, you can set decoder.dateDecodingStrategy
                // but we’ll assume Strings are fine
                let responseData = try decoder.decode(GamesResponse.self, from: data)
                completion(.success(responseData.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchGameDetails(gameId: Int, completion: @escaping (Result<GameDetail, Error>) -> Void) {
        let urlString = "https://api.rawg.io/api/games/\(gameId)?key=db2267db73124ba4847c42a85449c8cf"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                // Construct a custom error or handle gracefully
                return
            }

            do {
                let detail = try JSONDecoder().decode(GameDetail.self, from: data)
                completion(.success(detail))
            } catch {
                completion(.failure(error))
            }
            
            // Print the entire JSON for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON for gameId \(gameId):", jsonString)
            }

            do {
                let detail = try JSONDecoder().decode(GameDetail.self, from: data)
                completion(.success(detail))
            } catch {
                // Print the error as well
                print("Decoding error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}
extension APIService {
    
    func searchGames(query: String, completion: @escaping (Result<[Game], Error>) -> Void) {
        // Handle spaces, special chars
        let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        
        let urlString = "https://api.rawg.io/api/games?key=db2267db73124ba4847c42a85449c8cf&search=\(escapedQuery)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(GamesResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
