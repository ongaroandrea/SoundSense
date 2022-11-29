/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A collection of HealthKit properties, functions, and utilities.
*/

import Foundation
import HealthKit

class HealthDataV2 {
    
    static let healthStore: HKHealthStore = HKHealthStore()
    
    // MARK: - Data Types
    static var readDataTypes: [HKSampleType] {
        return allHealthDataTypes
    }
    
    
    private static var allHealthDataTypes: [HKSampleType] {
        let typeIdentifiers: [String] = HealthDataV2.getAllIdentifiers()
        return typeIdentifiers.compactMap { getSampleType(for: $0) }
    }

    // MARK: - Authorization
    /// Request health data from HealthKit if needed, using the data types within `HealthData.allHealthDataTypes`
    class func requestHealthDataAccessIfNeeded(dataTypes: [String]? = nil, completion: @escaping (_ success: Bool) -> Void) {
        var readDataTypes = Set(allHealthDataTypes)
        
        if let dataTypeIdentifiers = dataTypes {
            readDataTypes = Set(dataTypeIdentifiers.compactMap { getSampleType(for: $0) })
        }
        
        requestHealthDataAccessIfNeeded(toShare: [], read: readDataTypes, completion: completion)
    }
    
    /// Request health data from HealthKit if needed.
    class func requestHealthDataAccessIfNeeded(toShare shareTypes: Set<HKSampleType>?,
                                               read readTypes: Set<HKObjectType>?,
                                               completion: @escaping (_ success: Bool) -> Void) {
        if !HKHealthStore.isHealthDataAvailable() {
            fatalError("Health data is not available!")
        }
        
        print("Requesting HealthKit authorization...")
        healthStore.requestAuthorization(toShare: shareTypes, read: readTypes) { (success, error) in
            if let error = error {
                print("requestAuthorization error:", error.localizedDescription)
            }
            
            if success {
                print("HealthKit authorization request was successful!")
            } else {
                print("HealthKit authorization was not successful.")
            }
            
            completion(success)
        }
    }
}
