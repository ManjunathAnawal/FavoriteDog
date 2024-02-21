//
//  NetworkService.swift
//  FavoriteDog
//
//  Created by Manjunath Anawal on 21/02/24.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    func fetchRandomDogImage() async throws -> DogModel {
        let urlString = "https://dog.ceo/api/breeds/image/random"
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        do {
            let dogImage = try JSONDecoder().decode(DogModel.self, from: data)
            return dogImage
        } catch {
            throw error
        }
    }
    func fetchBreeds() async throws -> BreedsResponse {
        let urlString = "https://dog.ceo/api/breeds/list/all"
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        do {
            let breeds = try JSONDecoder().decode(BreedsResponse.self, from: data)
            return breeds
        } catch {
            throw error
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case invalidData
}


