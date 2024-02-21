//
//  ContentView.swift
//  FavoriteDog
//
//  Created by Manjunath Anawal on 21/02/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = DogViewModel()
    
    
    var body: some View {
        VStack {
            if let randomDogImage = viewModel.randomDogImage {
                Image(uiImage: randomDogImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            Task {
               try? await viewModel.fetchRandomDogImage()
                
            }
        }
    }
}

#Preview {
    VStack {
        ContentView()
    }
}
import Foundation

struct Breed: Codable, Identifiable, Hashable {
    let id = UUID()
    let name: String
    let subBreeds: [String]?
}

struct BreedsResponse: Codable {
    let message: [String: [String]]
    let status: String
}




import SwiftUI

struct BreedSelectionView: View {
    @State private var selectedBreedIndex = 0
    private let breeds: [Breed]
    
    init(breeds: [Breed]) {
        self.breeds = breeds
    }
    
    var body: some View {
        VStack {
            Picker(selection: $selectedBreedIndex, label: Text("Select Breed")) {
                ForEach(0..<breeds.count, id: \.self) { index in
                    Text(self.breeds[index].name).tag(index)
                }
            }
            
            Text("Selected Breed: \(breeds[selectedBreedIndex].name)")
        }
        .padding()
    }
}


struct BreedSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        let mockBreeds = [
            Breed(name: "Labrador", subBreeds: ["Golden", "Black", "Chocolate"]),
            Breed(name: "Poodle", subBreeds: ["Standard", "Miniature", "Toy"]),
            Breed(name: "German Shepherd", subBreeds: nil)
        ]
        
        return BreedSelectionView(breeds: mockBreeds)
    }
}

struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(title)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}
