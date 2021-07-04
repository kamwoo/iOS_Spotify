//
//  SearchResultModel.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/07/04.
//

import Foundation

enum SearchResultModel {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: playlist)
}
