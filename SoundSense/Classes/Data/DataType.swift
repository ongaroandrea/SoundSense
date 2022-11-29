//
//  StrangeType.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 03/10/22.
//

import Foundation

///https://stackoverflow.com/questions/52790140/how-do-i-store-array-of-custom-objects-in-core-data
public class DataType: NSObject, Codable {
    var id: String
    var date: Date
    var double: Double
    
    init(id: String, date: Date, double: Double) {
        self.id = id
        self.date = date
        self.double = double
    }
}
