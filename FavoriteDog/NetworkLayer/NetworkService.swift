//
//  NetworkService.swift
//  FavoriteDog
//
//  Created by Manjunath Anawal on 21/02/24.
//

import UIKit

//class NetworkService {
//    static let shared = NetworkService()
//
//    private init() {}
//    func fetchRandomDogImage() async throws -> DogImage {
//        let urlString = "https://dog.ceo/api/breeds/image/random"
//        guard let url = URL(string: urlString) else {
//            throw NetworkError.invalidURL
//        }
//
//        let (data, _) = try await URLSession.shared.data(from: url)
//
//        do {
//            let dogImage = try JSONDecoder().decode(DogImage.self, from: data)
//            return dogImage
//        } catch {
//            throw error
//        }
//    }
//    func fetchBreeds() async throws -> BreedsResponse {
//        let urlString = "https://dog.ceo/api/breeds/list/all"
//        guard let url = URL(string: urlString) else {
//            throw NetworkError.invalidURL
//        }
//
//        let (data, _) = try await URLSession.shared.data(from: url)
//
//        do {
//            let breeds = try JSONDecoder().decode(BreedsResponse.self, from: data)
//            return breeds
//        } catch {
//            throw error
//        }
//    }
//}

enum NetworkError: Error {
    case invalidURL
    case noData
    case invalidData
}

protocol NetworkServiceDelegate {
    func requestRandomImage() async throws -> DogImage
    func requestBreedsList() async throws -> [String]
    func requestRandomImage(breed: String) async throws -> DogImage
    func requestImageFile(url: URL) async throws -> UIImage
}
class NetworkService: NetworkServiceDelegate {
    enum Endpoint {
        case randomImageFromAllDogsCollection
        case randomImageForBreed(String)
        case listAllBreeds
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
        
        var stringValue: String {
            switch self {
            case .randomImageFromAllDogsCollection:
                return "https://dog.ceo/api/breeds/image/random"
            case .randomImageForBreed(let breed):
                return "https://dog.ceo/api/breed/\(breed)/images/random"
            case .listAllBreeds:
                return "https://dog.ceo/api/breeds/list/all"
            }
        }
    }
    
    func requestBreedsList() async throws -> [String] {
        let (data, _) = try await URLSession.shared.data(from: Endpoint.listAllBreeds.url)
        let decoder = JSONDecoder()
        let breedsResponse = try decoder.decode(BreedsResponse.self, from: data)
        let breeds = breedsResponse.message.keys.map { $0 }
        return breeds
    }
    
    func requestRandomImage(breed: String) async throws -> DogImage {
        let randomImageEndpoint = Endpoint.randomImageForBreed(breed).url
        let (data, _) = try await URLSession.shared.data(from: randomImageEndpoint)
        let decoder = JSONDecoder()
        let imageData = try decoder.decode(DogImage.self, from: data)
        return imageData
    }
    
    func requestRandomImage() async throws -> DogImage {
        let randomImageEndpoint = Endpoint.randomImageFromAllDogsCollection.url
        let (data, _) = try await URLSession.shared.data(from: randomImageEndpoint)
        let decoder = JSONDecoder()
        let imageData = try decoder.decode(DogImage.self, from: data)
        return imageData
    }
    
    func requestImageFile(url: URL) async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let downloadedImage = UIImage(data: data) else {
            throw NetworkError.invalidData
        }
        return downloadedImage
    }
    
}
