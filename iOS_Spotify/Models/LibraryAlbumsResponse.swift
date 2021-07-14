//
//  LibraryAlbumsResponse.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/07/09.
//

import Foundation

struct LibraryAlbumsResponse: Codable {
    let items: [SavedAlbum]
}

struct SavedAlbum: Codable {
    let added_at: String
    let album: Album
}
