//
//  AudioLenght.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 02/10/22.
//

import Foundation

enum AudioLength: String, CaseIterable, Identifiable, Codable {
    case corta
    case media
    case lunga
    
    var id: AudioLength { self }
}
