//
//  HealthKitServiceManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/24.
//

import Foundation
import HealthKitReporter
import HealthKit


let hkServiceManager = HealthKitServiceManager.shared

final class HealthKitServiceManager {
    
    static let shared = HealthKitServiceManager()
    
    private var reporter: HealthKitReporter?
    
    private lazy var typesToReadWrite: [SampleType] = {
        [QuantityType.stepCount, QuantityType.heartRate, QuantityType.activeEnergyBurned, WorkoutType.workoutType, CategoryType.sleepAnalysis]
    }()
//    private var typesToRead: [ObjectType] {
//        let types = typesToReadWrite
//        if #available(iOS 14.0, *) {
//            types.append(ElectrocardiogramType.electrocardiogramType)
//        }
//        return typesToReadWrite
//    }
    
//    private var typesToWrite: [SampleType] {
//        return typesToReadWrite
//    }

    private init() {
        do {
            reporter = try HealthKitReporter()
        } catch {
            log.error(error)
        }
    }
    
    func requestAuthorization(completion: @escaping StatusCompletionBlock) {
        //        reporter?.manager.requestAuthorization(toRead: typesToReadWrite, toWrite: typesToReadWrite, completion: completion)
        reporter?.manager.requestAuthorization(toRead: typesToReadWrite, toWrite: typesToReadWrite, completion: { [weak self] success, error in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                
                if !success {
                    // An error occurred
                    log.error(error)
                    completion(false, error)
                    
                    return
                }
                
                guard let hkWriter = self.reporter?.writer else {
                    completion(false, HealthKitError.unknown("未找到 Reporter"))
                    
                    return
                }
                // ** IMPORTANT
                // Check for access to your HealthKit Type(s). This is an example of using BodyMass.
                do {
                    for iType in self.typesToReadWrite {
                        let isOk = try hkWriter.isAuthorizedToWrite(type: iType)
                        if !isOk  {
                            completion(false, HealthKitError.invalidType(iType.identifier ?? "无效的 HealthKit类型"))
                            return
                        }
                    }
                    
                    completion(true, nil)
                } catch let cError {
                    completion(false, cError)
                }
            }
        })
    }
    
    func getTotayStepCount(completion: @escaping (Int) -> Void) {
        let now = Date()
        getQuantity(bDate: now.dayBegin, eDate: now, quantityType: QuantityType.stepCount) { (samples: [Quantity]) in
            var sum = 0
            for iItem in samples {
                sum += iItem.harmonized.value.int
            }
            completion(sum)
        }
    }
    
    func getTotayDistance(completion: @escaping (Int) -> Void) {
        let now = Date()
        getQuantity(bDate: now.dayBegin, eDate: now, quantityType: QuantityType.distanceWalkingRunning) { (samples: [Quantity]) in
            var sum = 0
            for iItem in samples {
                sum += iItem.harmonized.value.int
            }
            completion(sum)
        }
    }
    
    func getTotayCal(completion: @escaping (Int) -> Void) {
        do {
            let eDate = Date()
            let bDate = eDate.dayBegin
            let predicate: NSPredicate = Query.predicateForSamples(withStart: bDate, end: eDate, options: .strictEndDate)
            if let query = reporter?.reader.queryActivitySummary(predicate: predicate, completionHandler: { (summaries: [ActivitySummary], error) in
                if error != nil {
                    log.error("获取HealthKit出错 error = \(error!)")
                }
                var sum = 0
                for iItem in summaries {
                    sum += iItem.harmonized.activeEnergyBurned.int
                }
                completion(sum)
            }) {
                reporter?.manager.executeQuery(query)
            }
        } catch let cError {
            log.error("获取HealthKit出错 error = \(cError)")
        }
    }
    
    func getQuantity(bDate: Date, eDate: Date, quantityType: QuantityType, unit: String = HKUnit.count().unitString, completion: @escaping ([Quantity]) -> Void) {
        do {
            let predicate: NSPredicate = Query.predicateForSamples(withStart: bDate, end: eDate, options: .strictEndDate)
            
            if let quantityQuery = try reporter?.reader.quantityQuery(type: quantityType, unit: unit, predicate: predicate, resultsHandler: { (samples: [Quantity], error) in
                if error != nil {
                    log.error("获取HealthKit出错 error = \(error!)")
                }
                
                completion(samples)
            }) {
                reporter?.manager.executeQuery(quantityQuery)
            }
        } catch let cError {
            log.error("获取HealthKit出错 error = \(cError)")
        }
    }
    
}
