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
    var lenght: AudioLenght
    var data: [StrangeType] = []
    
    init(instrument: Instrument, lenght: AudioLenght, data: [StrangeType]) {
        self.instrument = instrument
        self.lenght = lenght
        self.data = data
    }
    
}
