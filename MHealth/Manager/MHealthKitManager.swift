//// 	 
//	MHealthKitManager.swift
//	MHealth
//
//	Created By Navneet on 07/12/24
//	


import Foundation

import HealthKit
import WidgetKit

class MHealthKitManager: MHealthKitManagingProtocol {
    
    private let healthStore = HKHealthStore()
    
    func getStepCount(forTimeFrame timeFrame: MHealthDuration, completion: @escaping (Double?, Error?) -> Void) {
        let sampleType = HKSampleType.quantityType(forIdentifier: .stepCount)!
        var predicate: NSPredicate
        predicate = getPredicate(forTimeFrame: timeFrame)
        
        let query = HKStatisticsQuery(quantityType: sampleType,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum) { query, result, error in
            
            if let error = error {
                // print("Error fetching step count: \(error)")
                completion(nil, error)
                return
            }
            
            if let sum = result?.sumQuantity() {
                let steps = sum.doubleValue(for: HKUnit.count())
                completion(steps, nil)
            } else {
                completion(nil, nil)
            }
        }
        healthStore.execute(query)
    }
    
    func getSleepAnalysis(forTimeFrame timeFrame: MHealthDuration, completion: @escaping (_ start: Date?,_ end: Date?,_ value: Double?,_ error: Error?) -> Void) {
        let sampleType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let predicate = getPredicate(forTimeFrame: timeFrame)
        
        let query = HKSampleQuery(sampleType: sampleType,
                                  predicate: predicate,
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: nil) { query, results, error in
            if let error = error {
                completion(nil, nil, nil, error)
                return
            }
            
            var totalSleepTime: Double? = nil
            var startDate: Date? = nil
            var endDate: Date? = nil
            
            if let results = results {
                for result in results {
                    if let result = result as? HKCategorySample{
                        if startDate == nil{
                            startDate =  result.startDate
                        }
                        if  endDate == nil{
                            endDate =  result.endDate
                        }
                        totalSleepTime = (totalSleepTime ?? 0) + result.endDate.timeIntervalSince(result.startDate)
                    }
                }
            }
            
            // Convert total sleep time to hours
            completion(startDate,endDate,totalSleepTime ?? 0.0, nil)
        }
        
        healthStore.execute(query)
    }
    func getDistanceWalkingRunning(forTimeFrame timeFrame: MHealthDuration, completion: @escaping (Double?, Error?) -> Void) {
        let sampleType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        let predicate = getPredicate(forTimeFrame: timeFrame)
        
        let query = HKStatisticsQuery(quantityType: sampleType,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum) { query, result, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let sum = result?.sumQuantity() {
                let distanceInMeters = sum.doubleValue(for: HKUnit.meter())
                var distanceInKilometers = distanceInMeters / 1000.0
                distanceInKilometers = (distanceInKilometers * 100).rounded() / 100
                completion(distanceInKilometers, nil)
            } else {
                completion(nil, nil)
            }
        }
        
        healthStore.execute(query)
    }
}

//MARK: Helper Functions
extension MHealthKitManager {
    func getTodayPredicate() -> NSPredicate {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        return predicate
    }
    func get24hPredicate() ->  NSPredicate{
        let today = Date()
        let startDate = Calendar.current.date(byAdding: .hour, value: -24, to: today)
        let predicate = HKQuery.predicateForSamples(withStart: startDate,end: today,options: [])
        return predicate
    }
    func getWeeklyPredicate() -> NSPredicate {
        let today = Date()
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: -7, to: today)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: today, options: [])
        return predicate
    }
    func getMonthlyPredicate() -> NSPredicate {
        let today = Date()
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .month, value: -1, to: today)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: today, options: [])
        return predicate
    }
    func getPredicate(forTimeFrame timeFrame: MHealthDuration) -> NSPredicate {
        switch timeFrame {
            case .today:
                return getTodayPredicate()
            case .weekly:
                return getWeeklyPredicate()
            case .monthly:
                return getMonthlyPredicate()
        }
    }
    
}

protocol MHealthKitManagingProtocol {
    
    // Function to retrieve step count for a specified time frame
    func getStepCount(forTimeFrame timeFrame: MHealthDuration, completion: @escaping (Double?, Error?) -> Void)
    
    // Function to retrieve sleep analysis for a specified time frame
    func getSleepAnalysis(forTimeFrame timeFrame: MHealthDuration, completion: @escaping (_ start: Date?,_ end: Date?,_ value: Double?,_ error: Error?) -> Void)
}
