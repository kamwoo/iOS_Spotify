//
//  SettingModels.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/06/28.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler : () -> Void
}
