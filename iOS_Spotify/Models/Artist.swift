//
//  Artist.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/06/25.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let external_urls: [String:String]
    let images: [ApiImage]?
}
