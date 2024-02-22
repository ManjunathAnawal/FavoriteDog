//
//  FavoriteDogTests.swift
//  FavoriteDogTests
//
//  Created by Manjunath Anawal on 21/02/24.
//

import XCTest
@testable import FavoriteDog

class DogViewModelTests: XCTestCase {
    var viewModel: DogViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = DogViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchRandomDogImage() async throws {
        let expectation = XCTestExpectation(description: "Fetch random dog image")
        
        do {
            try await viewModel.fetchRandomDogImage()
//            try await viewModel.fetchBreeds()

            
            // Assert that the randomDogImage is not nil after fetching
            XCTAssertNotNil(viewModel.randomDogImage)
//            XCTAssertEqual(viewModel.breedsName.count, 20)
            
            expectation.fulfill()
        } catch {
            XCTFail("Failed to fetch random dog image: \(error)")
        }
        
        // Wait for the expectation to be fulfilled with a timeout
        wait(for: [expectation], timeout: 10)
    }
}
