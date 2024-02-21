//
//  PersistenceService.swift
//  FavoriteDog
//
//  Created by Manjunath Anawal on 21/02/24.
//

import Foundation

class PersistenceService {
    static let shared = PersistenceService()
    private let favoritesKey = "favorites"
    
    private init() {}
    
    func saveFavoriteDog(_ dog: DogModel) {
        var favorites = loadFavorites()
        favorites.append(dog)
        saveFavorites(favorites)
    }
    
    func removeFavoriteDog(withID id: String) {
        var favorites = loadFavorites()
        favorites.removeAll { $0.id == id }
        saveFavorites(favorites)
    }
    
    func loadFavorites() -> [DogModel] {
        if let data = UserDefaults.standard.data(forKey: favoritesKey) {
            do {
                let decoder = JSONDecoder()
                return try decoder.decode([DogModel].self, from: data)
            } catch {
                print("Failed to decode favorites: \(error)")
                return []
            }
        }
        return []
    }
    
    private func saveFavorites(_ favorites: [DogModel]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(favorites)
            UserDefaults.standard.set(data, forKey: favoritesKey)
        } catch {
            print("Failed to encode favorites: \(error)")
        }
    }
}
