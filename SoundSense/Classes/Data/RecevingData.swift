//
//  RecevingData.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 31/10/22.
//

import Foundation

struct RecevingData: Decodable, Hashable {
    let created_at: String
    let file_type: String
    let id: Int
    let instrument: Instrument
    let length: AudioLength
    let name: String
    let order: AudioOrder
}

