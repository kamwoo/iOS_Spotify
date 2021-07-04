//
//  SearchResult.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/07/04.
//

import Foundation

struct SearchResult: Codable {
    let albums: SearchAlbumResponse
    let artists: SearchArtistsResponse
    let playlists: SearchPlaylistsResponse
    let tracks: SearchTracksResponse
}

struct SearchAlbumResponse: Codable {
    let items: [Album]
}

struct SearchArtistsResponse: Codable {
    let items: [Artist]
}

struct SearchPlaylistsResponse: Codable {
    let items: [playlist]
}

struct SearchTracksResponse: Codable {
    let items: [AudioTrack]
}
