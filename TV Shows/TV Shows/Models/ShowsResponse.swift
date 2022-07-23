//
//  ShowsResponse.swift
//  TV Shows
//
//  Created by Infinum on 23.07.2022..
//

import Foundation

struct ShowsResponse: Decodable {
    let shows: [Show]
}

struct Show: Decodable {
    let id: String
    let title: String
//    let averageRating: String?
//    let description: String?
    let imageUrl: String
    let noOfReviews: Int
    
    enum CodingKeys: String, CodingKey {
        case id, title
//        case description
//        case averageRating = "average_rating"
        case imageUrl = "image_url"
        case noOfReviews = "no_of_reviews"
    }
}
