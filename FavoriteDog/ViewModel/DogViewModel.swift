//
//  DogViewModel.swift
//  FavoriteDog
//
//  Created by Manjunath Anawal on 21/02/24.
//

import SwiftUI

class DogViewModel: ObservableObject {
    @Published var favoriteDog: DogModel?
    @Published var randomDogImage: UIImage?
    @Published var breedsName: [String] = []
    
    private let networkService = NetworkService.shared
    
    func fetchRandomDogImage() async throws  {
        do {
            let dogImage = try await networkService.fetchRandomDogImage()
            guard let url = URL(string: dogImage.message ?? "") else {
                throw NetworkError.invalidURL
            }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                throw NetworkError.invalidData
            }
            
            randomDogImage = image
        } catch {
            throw error
        }
    }
    
    func fetchBreeds() async {
        do {
            let allBreeds =  try await networkService.fetchBreeds()
            for (name, _) in allBreeds.message {
                self.breedsName.append(name)
            }
            
        } catch {
            print("Error decoding breeds: \(error)")
            return
        }
    }

}
