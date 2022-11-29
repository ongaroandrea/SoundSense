//
//  Instrument.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 01/10/22.
//

import Foundation

enum Instrument: String, CaseIterable, Identifiable, Codable {
    case violino
    case piano
    case basso
    
    var id: Instrument { self }
}
