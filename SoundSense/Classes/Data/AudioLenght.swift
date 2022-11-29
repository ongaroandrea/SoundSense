//
//  AudioLenght.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 02/10/22.
//

import Foundation

enum AudioLength: String, CaseIterable, Identifiable, Codable {
    case short
    case medium
    case long
    
    var id: AudioLength { self }
}
