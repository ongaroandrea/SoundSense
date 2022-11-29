//
//  SampleClass.swift
//  Tesi_New
//
//  Created by Andrea  Ongaro on 12/09/22.
//

import Foundation
//import DeviceActivity
//import FamilyControls
import HealthKit

class HealthClass: ObservableObject {
    
    @Published var strangeData: [DataType] = []
    @Published var statusRequest: Bool = false
    private let healthStore = HealthData.healthStore
    
    /// The HealthKit data types we will request to read.
    let readTypes = Set(HealthData.readDataTypes)
    
    var hasRequestedHealthData: Bool = false
    
    func requestHealthAuthorization() {
        print("Requesting HealthKit authorization...")
        
        if !HKHealthStore.isHealthDataAvailable() {
            self.statusRequest = false
        }
        
        healthStore.requestAuthorization(toShare: [], read: readTypes) { (success, error) in
            var status: String = ""
            
            if let error = error {
                status = "HealthKit Authorization Error: \(error.localizedDescription)"
                self.statusRequest = false
            } else {
                if success {
                    if self.hasRequestedHealthData {
                        status = "You've already requested access to health data. "
                    } else {
                        status = "HealthKit authorization request was successful! "
                    }
                    
                    //status += self.createAuthorizationStatusDescription(for: self.shareTypes)
                    
                    self.hasRequestedHealthData = true
                } else {
                    status = "HealthKit authorization did not complete successfully."
                    self.statusRequest = false
                }
            }
            
            print(status)
            
            // Results come back on a background thread. Dispatch UI updates to the main thread.
            DispatchQueue.main.async {
                //self.descriptionLabel.text = status
            }
        }
    }
    
    func getSampleData(startDate: Date, endDate: Date, identifier: HKQuantityTypeIdentifier) async -> [DataType] {
        let heartRate = HKQuantityType.quantityType(forIdentifier: identifier)!
        //let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        //let endDate = Date()
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        func startQuery() async -> [DataType] {
            let group = DispatchGroup()
            group.enter()
            
            var array: [DataType] = []
            let sampleQuery = HKSampleQuery(sampleType: heartRate, predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor], resultsHandler: {(sampleQuery, results, error) -> Void in
                
                guard let samples = results as? [HKQuantitySample] else {
                    // Handle any errors here.
                    return
                }
                
                for sample in samples {
                    print(sample.startDate)
                    print(sample.count)
                    print(sample.quantity)
                    print(sample.quantityType)
                    array.append(DataType(id: UUID().uuidString, date: sample.startDate, double: 1.0))
                }
                
                group.leave()
            })
            
            //healthStore.requestAuthorization(toShare: [], read: [heartRate], completion: { (success, error) in
                self.healthStore.execute(sampleQuery)
            //})
            
            group.wait()
            
            return array
        }
        
        return await startQuery()
    }
    
    ///
    func statisticsData(identifier: HKQuantityTypeIdentifier, unit: HKUnit) async -> [DataType] {
        // Create a 1-week interval.
        let interval = DateComponents(hour: 1)
        
        let calendar = Calendar.current
        let start_day = calendar.startOfDay(for: Date())
        print(start_day)
        let dayOfWeek = calendar.component(.weekday, from: start_day)
        var components_end = DateComponents()
        components_end.day = 1
        components_end.second = -1
        var end_day = calendar.date(byAdding: components_end, to: start_day)!
        print(end_day)
        // Set the anchor the current day at midnight
        let components = DateComponents(calendar: calendar,
                                        timeZone: calendar.timeZone,
                                        hour: 0,
                                        minute: 0,
                                        second: 0,
                                        weekday: dayOfWeek)
                                                                       


        guard let anchorDate = Calendar.current.nextDate(after: Date(),
                                                 matching: components,
                                                 matchingPolicy: .nextTime,
                                                 repeatedTimePolicy: .first,
                                                 direction: .backward) else {
            fatalError("*** unable to find the date. ***")
        }
        
        guard let quantityType = HKObjectType.quantityType(forIdentifier: identifier) else {
            fatalError("*** Unable to create a type for the identifier ***")
        }

        func startQuery() async -> [DataType] {
            let group = DispatchGroup()
            group.enter()
            
            var array: [DataType] = []
            
            // Create the query.
            let query = HKStatisticsCollectionQuery(quantityType: quantityType,quantitySamplePredicate: nil,
                                                    options: .cumulativeSum, anchorDate: anchorDate,
                                                    intervalComponents: interval)
            
            query.initialResultsHandler = {
                query, results, error in
                
                // Handle errors here.
                if let error = error as? HKError {
                    return
                }
                
                guard let statsCollection = results else {
                    // You should only hit this case if you have an unhandled error. Check for bugs
                    // in your code that creates the query, or explicitly handle the error.
                    return
                }
                                                
                // Enumerate over all the statistics objects between the start and end dates.
                statsCollection.enumerateStatistics(from: start_day, to: end_day){ (statistics, stop) in
                    if let quantity = statistics.sumQuantity() {
                        let date = statistics.startDate
                        let value = quantity.doubleValue(for: unit)
                        print(date)
                        print(value)
                        array.append(DataType(id: UUID().uuidString, date: statistics.startDate, double: quantity.doubleValue(for: unit)))
                    }
                }
                
                group.leave()
            }
            self.healthStore.execute(query)
            
            group.wait()
            
            return array
        }
        
        return await startQuery()
    }
}
