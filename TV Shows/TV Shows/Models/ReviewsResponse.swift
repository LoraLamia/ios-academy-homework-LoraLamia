//
//  ReviewsResponse.swift
//  TV Shows
//
//  Created by Infinum on 23.07.2022..
//

import Foundation

struct ReviewsResponse: Codable {
    let reviews: [Review]
}

struct Review: Codable {
    let id: String
    let comment: String
    let rating: Int
    let showId: Int
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case id, comment, rating, user
        case showId = "show_id"
    }
}


