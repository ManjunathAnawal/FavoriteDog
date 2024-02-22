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
            if !viewModel.breedsName.isEmpty {
                BreedSelectionView(breeds: viewModel.breedsName)
            }
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
                    try? await viewModel.fetchBreeds()
                    
                }
            }
        }
    }
}

#Preview {
    VStack {
        ContentView()
    }
}



struct BreedSelectionView: View {
    @State private var selectedBreedIndex = 0
    private let breeds: [String]
    
    init(breeds: [String]) {
        self.breeds = breeds
    }
    
    var body: some View {
        VStack {
            Picker(selection: $selectedBreedIndex, label: Text("Select Breed")) {
                ForEach(0..<breeds.count, id: \.self) { index in
                    Text(self.breeds[index])
                        .tag(index)
                }
            }.onTapGesture {
                
            }
            
            Text("Selected Breed: \(breeds[selectedBreedIndex])")
        }
        .padding()
    }
}


struct BreedSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        let mockBreeds = [
             "Labrador", "Golden", "Black", "Chocolate"
            , "Poodle","Standard", "Miniature", "Toy", "German Shepherd"]
        
        
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
