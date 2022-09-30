//
//  HealthDatav2.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 03/10/22.
//

import Foundation
import HealthKit

final class HealthDataV2: Decodable, Identifiable, Hashable {
    static func == (lhs: HealthDataV2, rhs: HealthDataV2) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: UUID
    var name: String
    var description: String
    var image: String
    var typeIdentifiers: String
    
    init(name: String, description: String, image: String, typeIdentifiers: String) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.image = image
        self.typeIdentifiers = typeIdentifiers
    }
    
    static var datat: [HealthDataV2] = [
        HealthDataV2(name: "Step Count", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", image: "stepcount", typeIdentifiers: HKQuantityTypeIdentifier.stepCount.rawValue),
        HealthDataV2(name: "Distance WalkingRunning", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", image: "walking", typeIdentifiers: HKQuantityTypeIdentifier.distanceWalkingRunning.rawValue),
        HealthDataV2(name: "Heart Rate", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", image: "heartRate", typeIdentifiers: HKQuantityTypeIdentifier.heartRate.rawValue),
        HealthDataV2(name: "Walking Speed", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", image: "flights", typeIdentifiers:  HKQuantityTypeIdentifier.walkingSpeed.rawValue),
        HealthDataV2(name: "Apple Stand Time", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", image: "flights", typeIdentifiers: HKQuantityTypeIdentifier.appleStandTime.rawValue),
        HealthDataV2(name: "Apple Exercise Time", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", image: "flights", typeIdentifiers: HKQuantityTypeIdentifier.appleExerciseTime.rawValue),
        HealthDataV2(name: "Apple Move Time", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", image: "flights", typeIdentifiers: HKQuantityTypeIdentifier.appleMoveTime.rawValue),
        
    ]
    
    static func getAllIdentifiers() -> [String] {
        var data: [String] = []
        for d in HealthDataV2.datat {
            data.append(d.typeIdentifiers)
        }
        return data
    }
}
