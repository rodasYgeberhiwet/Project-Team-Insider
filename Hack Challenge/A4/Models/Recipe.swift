//
//  Recipe.swift
//  A4
//
//  Created by Paul Ng on 11/16/25.
//

import Foundation

struct Recipe: Codable {
    // TODO: Create a Post Struct here
    let id: String
    let description: String
    let difficulty: String
    let image_url: String
    let name: String
    let rating: Float
    
}
