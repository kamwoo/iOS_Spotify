//
//  NewReleasesResponse.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/06/28.
//

import Foundation

struct NewReleasesResponse : Codable {
    let albums: AlbumResponse
}

struct AlbumResponse: Codable {
    let items: [Album]
}

struct Album: Codable {
    let album_type : String
    let available_markets : [String]
    let id : String
    let images: [ApiImage]
    let name: String
    let release_date: String
    let total_tracks: Int
    let artists: [Artist]
}

