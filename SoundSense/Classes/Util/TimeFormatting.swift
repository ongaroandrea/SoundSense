//
//  TimeFormatting.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 02/10/22.
//

import Foundation

func calcTimeSince(date: Date) -> String {
    let minutes = Int(-date.timeIntervalSinceNow) / 60
    let hours = minutes / 60
    let days = hours / 24
    
    if minutes < 120 {
        return "\(minutes)"
    } else if( minutes >= 120 && hours < 48) {
        return  "\(hours) hours ago"
    } else {
        return "\(days) day ago"
    }
}
