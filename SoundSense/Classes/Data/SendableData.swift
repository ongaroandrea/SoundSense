//
//  SendableData.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 02/10/22.
//

import Foundation

///class to send data to python server
public class SendableData: NSObject, Codable {
    var instrument: Instrument
    var length: AudioLength
    var data: [DataType] = []
    var type: String
    var order: AudioOrder
    
    init(instrument: Instrument, length: AudioLength, data: [DataType], type: String, order: AudioOrder) {
        self.instrument = instrument
        self.length = length
        self.data = data
        self.type = type
        self.order = order
    }
    
}
