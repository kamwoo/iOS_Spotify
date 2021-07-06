//
//  AudioTrack.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/06/25.
//

import Foundation

struct AudioTrack: Codable {
    var album: Album?
    let artists: [Artist]
    let available_markets: [String]
    let external_urls: [String:String]
    let id: String
    let name: String
    let disc_number: Int
    let duration_ms: Int
    let explicit: Bool
    let preview_url: String?
}
