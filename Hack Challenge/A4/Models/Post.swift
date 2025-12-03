//
//  Post.swift
//  A4
//
//  Created by Amy Yang on 12/3/25.
//

import Foundation

struct Post: Codable {
    // TODO: Create a Post Struct here
    var likes: [String]
    let message: String
    let time: Date
    let id: String
}
