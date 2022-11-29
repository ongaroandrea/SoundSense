//
//  OrderType.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 30/10/22.
//

import Foundation

enum AudioOrder: String, CaseIterable, Identifiable, Codable {
    case desc
    case asc
    
    var id: AudioOrder { self }
}
