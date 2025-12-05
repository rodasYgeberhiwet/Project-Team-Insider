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
    
    private let endpoint = "https://pastebin.com/jFKaKdcP"
    
    private let decoder = JSONDecoder()
    
    // MARK: - Requests
    
    func fetchTeams(completion: @escaping ([Team]) -> Void) {
        // Create the request for a team

        AF.request(endpoint, method: .get)
            .validate()
            .responseDecodable(of: [Team].self, decoder: decoder) { response in
                // Handle the response
                switch response.result {
                case .success(let teams):
                    print("Successfully fetched \(teams.count) teams") // debugging
                    completion(teams)
                case .failure(let error):
                    print("Error in NetworkManager.fetchTeams: \(error.localizedDescription)")
                }
            }
    }
 
    func addTeams(message: String, completion: @escaping (Team) -> Void) {
        decoder.dateDecodingStrategy = .iso8601
         let parameters: Parameters = [
             "message": message
         ]

         // Make the request
         AF.request("\(endpoint)create/", method: .post, parameters: parameters, encoding: JSONEncoding.default)
             .validate()
             .responseDecodable(of: Team.self, decoder: decoder) { response in
                 // Handle the response
                 switch response.result{
                 case .success(let team):
                     print("Successfully added team \(team.id)")
                     completion(team)
                 case .failure(let error):
                     print("Error in NetworkManager.addTeams \(error.localizedDescription)")
                 }
             }
         
     }
     /*
     func updateRosterLikes(netId: String, postId: String, completion: @escaping (Post) -> Void) {
         decoder.dateDecodingStrategy = .iso8601
         // Define the request body
         let parameters: Parameters = [
             "netId": netId
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
     */
}

