//
//  Post.swift
//  A4
//
//  Created by Amy Yang on 12/3/25.
//

import Foundation

struct Post: Codable {
    var likes: [String]
    let message: String
    let time: Date
    let id: String
    let profileImage: String
//    let overallRating = Float
//    let difficultyRating = Float
    let isMember: Bool
    let yearsMember: String
    let major: String
    let timesApplied: Int
    let timeCommitment: String //selected hours range?
}
