//
//  HealthKitServiceManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/24.
//

import Foundation
import HealthKitReporter


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
    
}
