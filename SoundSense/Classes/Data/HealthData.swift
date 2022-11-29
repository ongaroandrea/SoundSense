//
//  HealthDatav2.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 03/10/22.
//

import Foundation
import HealthKit

class HealthData: Identifiable, Hashable {
    
    static let healthStore: HKHealthStore = HKHealthStore()
    // MARK: - Data Types
    static var readDataTypes: [HKSampleType] {
        return allHealthDataTypes
    }

    private static var allHealthDataTypes: [HKSampleType] {
        let typeIdentifiers: [String] = HealthData.getAllIdentifiers()
        return typeIdentifiers.compactMap { getSampleType(for: $0) }
    }
    
    var id: UUID
    var name: String
    var description: String
    var image: String
    var typeIdentifiers: HKQuantityTypeIdentifier
    var order: AudioOrder
    var unit: HKUnit
    
    init(name: String, description: String, image: String, typeIdentifiers: HKQuantityTypeIdentifier, order: AudioOrder, unit: HKUnit) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.image = image
        self.typeIdentifiers = typeIdentifiers
        self.order = order
        self.unit = unit
    }
    
    static var listHealthData: [HealthData] = [
        HealthData(name: "Conteggio passi", description: "Sonifica ora i tuoi passi giornalieri! Scegli lo strumento che preferisci, la lunghezza desiderata e clicca \"Riproduci Brano\".", image: "stepcount", typeIdentifiers: HKQuantityTypeIdentifier.stepCount, order: .desc, unit: HKUnit.count()),
        HealthData(name: "Distanza percorsa", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit", image: "walking", typeIdentifiers: HKQuantityTypeIdentifier.distanceWalkingRunning, order: .desc, unit: HKUnit.count()),
        HealthData(name: "Battito Cardiaco", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit", image: "heartRate", typeIdentifiers: HKQuantityTypeIdentifier.heartRate, order: .desc, unit: HKUnit.count()),
        HealthData(name: "Velocità della camminata", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit", image: "flights", typeIdentifiers:  HKQuantityTypeIdentifier.walkingSpeed, order: .desc, unit: HKUnit.meter()),
        HealthData(name: "Tempo in piedi", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit", image: "flights", typeIdentifiers: HKQuantityTypeIdentifier.appleStandTime, order: .desc, unit: HKUnit.second()),
        HealthData(name: "Tempo di esercizio", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit", image: "flights", typeIdentifiers: HKQuantityTypeIdentifier.appleExerciseTime, order: .desc, unit: HKUnit.second()),
        HealthData(name: "Tempo di movimento", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit", image: "flights", typeIdentifiers: HKQuantityTypeIdentifier.appleMoveTime, order: .desc, unit: HKUnit.second()),
        HealthData(name: "Utilizzo Dispositivo", description: "Sonifica ora i dati sull'utilizzo del dispositivo. Scegli lo strumento che preferisci, la lunghezza desiderata e clicca \"Riproduci Brano\".", image: "screenTime", typeIdentifiers: HKQuantityTypeIdentifier.init(rawValue: "screenTime"), order: .desc, unit: HKUnit.count()),
    ]
    
    static func getAllIdentifiers() -> [String] {
        var data: [String] = []
        for tmp in HealthData.listHealthData {
            data.append(tmp.typeIdentifiers.rawValue)
        }
        return data
    }
    
    static func == (lhs: HealthData, rhs: HealthData) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    
}
