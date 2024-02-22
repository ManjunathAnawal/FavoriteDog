//
//  DogViewModel.swift
//  FavoriteDog
//
//  Created by Manjunath Anawal on 21/02/24.
//

import SwiftUI

class DogViewModel: ObservableObject {
    @Published var favoriteDog: DogImage?
    @Published var randomDogImage: UIImage?
    @Published var breedsName: [String] = []
    
    private let networkService: NetworkServiceDelegate?
    
    init(favoriteDog: DogImage? = nil, randomDogImage: UIImage? = nil, breedsName: [String] = [], networkService: NetworkServiceDelegate = NetworkService() ) {
        self.favoriteDog = favoriteDog
        self.randomDogImage = randomDogImage
        self.breedsName = breedsName
        self.networkService = networkService
    }
    
    @MainActor
    func fetchRandomDogImage() async throws  {
        do {
            let dogImage = try await networkService?.requestRandomImage()
            guard let url = URL(string: dogImage?.message ?? "") else {
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
    
    @MainActor
    func fetchBreeds() async {
        do {
            if let breedsName =  try await networkService?.requestBreedsList() {
                self.breedsName = breedsName
            }
           
        } catch {
            print("Error decoding breeds: \(error)")
            return
        }
    }

}
