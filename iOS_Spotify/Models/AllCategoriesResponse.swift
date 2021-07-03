//
//  AllCategoriesResponse.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/07/03.
//

import Foundation

struct AllCategoriesResponse: Codable {
    let categories: categories
}

struct categories: Codable {
    let items: [category]
}

struct category: Codable {
    let id: String
    let name: String
    let icons: [ApiImage]
}
