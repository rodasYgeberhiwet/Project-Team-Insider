//
//  Recipe.swift
//  A4
//
//  Created by Paul Ng on 11/16/25.
//

import Foundation

struct Team: Codable {
    let id: String
    let name: String
    let description: String
    let comp: String
    let reviews: [String]
    let hours: String
    let category: String
    let website: String?
    
}
