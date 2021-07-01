//
//  PlaylistDetails.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/07/01.
//

import Foundation

struct PlaylistDetails: Codable {
    let description: String
    let external_urls: [String:String]
    let id: String
    let images: [ApiImage]
    let name: String
    let owner: Owner
    let tracks: PlaylistTrackResponse
}

struct PlaylistTrackResponse: Codable {
    let items: [playlistItem]
}

struct playlistItem: Codable {
    let track: AudioTrack
}
