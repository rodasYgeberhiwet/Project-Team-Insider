//
//  NetworkManager.swift
//  A4
//
//  Created by Paul Ng on 11/19/25.
//

import Alamofire
import Foundation

class NetworkManager {

    /// Shared singleton instance
    static let shared = NetworkManager()

    private init() { }

    /// Endpoint
    
    private let endpoint = "https://api.jsonbin.io/v3/b/64d033f18e4aa6225ecbcf9f?meta=false"
    
    private let decoder = JSONDecoder()
    
    // MARK: - Requests
    
    func fetchRecipes(completion: @escaping ([Recipe]) -> Void) {
        // Create the request

        AF.request(endpoint, method: .get)
            .validate()
            .responseDecodable(of: [Recipe].self, decoder: decoder) { response in
                // Handle the response
                switch response.result {
                case .success(let recipes):
                    print("Successfully fetched \(recipes.count) recipes") // debugging
                    completion(recipes)
                case .failure(let error):
                    print("Error in NetworkManager.fetchRecipes: \(error.localizedDescription)")
                }
            }
    }

}
