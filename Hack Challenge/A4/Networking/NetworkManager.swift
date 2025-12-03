//
//  NetworkManager.swift
//  A4
//
//  Created by Paul Ng on 11/19/25.
//
/*
import Alamofire
import Foundation

class NetworkManager {

    /// Shared singleton instance
    static let shared = NetworkManager()

    private init() { }

    /// Endpoint
    private let devEndpoint: String = "https://ios-course-backend.cornellappdev.com"
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
 
 func fetchRoster(completion: @escaping ([Post]) -> Void) {
     // Create the request
     decoder.dateDecodingStrategy = .iso8601
     AF.request(endpoint, method: .get)
         .validate()
         .responseDecodable(of: [Post].self, decoder: decoder) { response in
             // Handle the response
             switch response.result {
             case .success(let posts):
                 print("Successfully fetched \(posts.count) posts") // debugging
                 completion(posts)
             case .failure(let error):
                 print("Error in NetworkManager.fetchRoster: \(error.localizedDescription)")
             }
         }
 }
 
     func addToRoster(message: String, completion: @escaping (Post) -> Void) {
         decoder.dateDecodingStrategy = .iso8601
         // Define the request body
         let parameters: Parameters = [
             "message": message
         ]

         // Make the request
         AF.request("\(endpoint)create/", method: .post, parameters: parameters, encoding: JSONEncoding.default)
             .validate()
             .responseDecodable(of: Post.self, decoder: decoder) { response in
                 // Handle the response
                 switch response.result{
                 case .success(let post):
                     print("Successfully added post \(post.id)")
                     completion(post)
                 case .failure(let error):
                     print("Error in NetworkManager.addToRoster \(error.localizedDescription)")
                 }
             }
         
     }
     
     func updateRosterLikes(netId: String, postId: String, completion: @escaping (Post) -> Void) {
         decoder.dateDecodingStrategy = .iso8601
         // Define the request body
         let parameters: Parameters = [
             "netId": netId,
         ]

         // Make the request
         AF.request("\(endpoint)\(postId)/like/", method: .post, parameters: parameters, encoding: JSONEncoding.default)
             .validate()
             .responseDecodable(of: Post.self, decoder: decoder) { response in
                 print("response decoded")
                 // Handle the response
                 switch response.result{
                 case .success(let post):
                     print("Successfully updated likes of post \(post.id)")
                     completion(post)
                 case .failure(let error):
                     print("Error in NetworkManager.updateRosterLikes \(error.localizedDescription)")
                 }
             }
         
     }

}
*/
