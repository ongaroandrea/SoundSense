//
//  Extension.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 06/10/22.
//

import Foundation

extension DateComponentsFormatter {
    
    static let positional: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        return formatter
    }()
}
