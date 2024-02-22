//
//  DogModel.swift
//  FavoriteDog
//
//  Created by Manjunath Anawal on 21/02/24.
//

import Foundation

struct DogImage: Codable {
    let message: String?
    let status: String?
    let id: String?
}

struct BreedsResponse: Codable {
    let message: [String: [String]]
    let status: String
}



struct Breed: Codable, Identifiable, Hashable {
    let id = UUID()
    let name: String
    let subBreeds: [String]?
}


