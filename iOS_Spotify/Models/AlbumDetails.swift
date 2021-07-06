//
//  AlbumDetails.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/07/01.
//

import Foundation

struct AlbumDetails: Codable {
    let album_type: String
    let artists: [Artist]
    let available_markets: [String]
    let external_urls: [String : String]
    let id: String
    let images: [ApiImage]
    let label: String
    let name: String
    let tracks: TrackResponse
}

struct TrackResponse: Codable {
    let items: [AudioTrack]
}


