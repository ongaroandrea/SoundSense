//
//  RecevingData.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 31/10/22.
//

import Foundation

struct RecevingData: Decodable, Hashable {
    let id: Int
    let name: String
    let file_type: String
    let order: AudioOrder
    let instrument: Instrument
    let length: AudioLength
    let created_at: String
}

