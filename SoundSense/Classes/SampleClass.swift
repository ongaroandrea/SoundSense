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
    
    //@Published var healthStore: HKHealthStore?
    //@Published var selectionToDiscourage: FamilyActivitySelection = FamilyActivitySelection.init()
    @Published var strangeData: [StrangeType] = []
    private let healthStore = HealthData.healthStore
    
    /// The HealthKit data types we will request to read.
    let readTypes = Set(HealthData.readDataTypes)
    
    var hasRequestedHealthData: Bool = false
    
    func requestHealthAuthorization() {
        print("Requesting HealthKit authorization...")
        
        if !HKHealthStore.isHealthDataAvailable() {
            //presentHealthDataNotAvailableError()
            return
        }
        
        healthStore.requestAuthorization(toShare: [], read: readTypes) { (success, error) in
            var status: String = ""
            
            if let error = error {
                status = "HealthKit Authorization Error: \(error.localizedDescription)"
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
                }
            }
            
            print(status)
            
            // Results come back on a background thread. Dispatch UI updates to the main thread.
            DispatchQueue.main.async {
                //self.descriptionLabel.text = status
            }
        }
    }
    
    func getData(){
        let standType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        healthStore.requestAuthorization(toShare: [], read: [standType], completion: { (success, error) in
                    self.didStandThisHour { (didStand) in
                        print("Did stand this hour: \(didStand)")
                    }
                })
    }
    
    func didStandThisHour(_ didStand: @escaping (Bool) -> ()) {
            let store = HKHealthStore()
        let calendar = Calendar.autoupdatingCurrent
            let dateComponents = calendar.dateComponents([.year, .month, .day, .hour], from: Date())
            let endDate = Date()
            let startDate = calendar.date(from: dateComponents)!
        print(startDate)
            let standTime = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
            var interval = DateComponents()
            interval.hour = 1
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            let query = HKStatisticsCollectionQuery(quantityType: standTime, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate, intervalComponents:interval)
            query.initialResultsHandler = { query, results, error in
                guard error == nil, let myResults = results else {
                    fatalError("Something is wrong with HealthKit link")
                }
                myResults.enumerateStatistics(from: startDate, to: endDate, with: { (statistics, stop) in
                    guard let quantity = statistics.sumQuantity() else {
                        didStand(false)
                        return
                    }
                    let minutes = quantity.doubleValue(for: .minute())
                    didStand(minutes > 0)
                })
            }
            store.execute(query)
        }
    
    func getSampleData(startDate: Date, endDate: Date, identifier: HKQuantityTypeIdentifier) async -> [StrangeType] {
        let heartRate = HKQuantityType.quantityType(forIdentifier: identifier)!
        //let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        //let endDate = Date()
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        func startQuery() async -> [StrangeType] {
            let group = DispatchGroup()
            group.enter()
            
            var array: [StrangeType] = []
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
                    array.append(StrangeType(date: sample.startDate, double: 1.0))
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
    func statisticsData(identifier: HKQuantityTypeIdentifier){
        // Create a 1-week interval.
        let interval = DateComponents(day: 7)

        // Set the anchor for 3 a.m. on Monday.
        var components = DateComponents(calendar: Calendar.current,
                                        timeZone: Calendar.current.timeZone,
                                        hour: 3,
                                        minute: 0,
                                        second: 0,
                                        weekday: 2)


        guard let anchorDate = Calendar.current.nextDate(after: Date(),
                                                 matching: components,
                                                 matchingPolicy: .nextTime,
                                                 repeatedTimePolicy: .first,
                                                 direction: .backward) else {
            fatalError("*** unable to find the previous Monday. ***")
        }
        
        guard let quantityType = HKObjectType.quantityType(forIdentifier: identifier) else {
            fatalError("*** Unable to create a step count type ***")
        }


        // Create the query.
        let query = HKStatisticsCollectionQuery(quantityType: quantityType,
                                                quantitySamplePredicate: nil,
                                                options: .cumulativeSum,
                                                anchorDate: anchorDate,
                                                intervalComponents: interval)
        
        query.initialResultsHandler = {
            query, results, error in
            
            // Handle errors here.
            if let error = error as? HKError {
                switch (error.code) {
                case .errorDatabaseInaccessible:
                    // HealthKit couldn't access the database because the device is locked.
                    return
                default:
                    // Handle other HealthKit errors here.
                    return
                }
            }
            
            guard let statsCollection = results else {
                // You should only hit this case if you have an unhandled error. Check for bugs
                // in your code that creates the query, or explicitly handle the error.
                assertionFailure("")
                return
            }
            let endDate = Date()
            let threeMonthsAgo = DateComponents(month: -3)
            
            guard let startDate = Calendar.current.date(byAdding: threeMonthsAgo, to: endDate) else {
                fatalError("*** Unable to calculate the start date ***")
            }
            
            // Plot the weekly step counts over the past 3 months.
            
            
            // Enumerate over all the statistics objects between the start and end dates.
            statsCollection.enumerateStatistics(from: startDate, to: endDate)
            { (statistics, stop) in
                if let quantity = statistics.sumQuantity() {
                    let date = statistics.startDate
                    let value = quantity.doubleValue(for: .count())
                    
                    self.strangeData.append(StrangeType(date: date, double: value))
                    
                }
            }
            
            // Dispatch to the main queue to update the UI.
            DispatchQueue.main.async {
                
            }
            
        }
        self.healthStore.execute(query)
        
    }
}
