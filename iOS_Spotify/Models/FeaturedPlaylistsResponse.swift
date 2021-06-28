//
//  Playlist.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/06/25.
//

import Foundation

struct FeaturedPlaylistsResponse: Codable {
    let playlists: playlistResponse
}

struct playlistResponse: Codable {
    let items: [playlist]
}

struct playlist: Codable {
    let description : String
    let external_urls : [String:String]
    let id : String
    let images : [ApiImage]
    let name : String
    let owner : Owner
}

struct Owner: Codable {
    let display_name : String
    let external_urls : [String:String]
    let id : String
}

