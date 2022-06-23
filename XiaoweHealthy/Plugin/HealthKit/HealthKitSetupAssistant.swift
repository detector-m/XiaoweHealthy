//
//  HealthKitSetupAssistant.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/22.
//

import HealthKit


class HealthKitSetupAssistant {
     
    public enum HealthKitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }
    
    typealias HealthKitAuthorizeHandler = (_ success: Bool, _ setupError: Error?) -> Void
//    typealias HealthKitAuthorizeHandler = (_ result: Result<Bool, HealthKitSetupError>) -> Void

    
    class func requestAuthorize(completion: @escaping HealthKitAuthorizeHandler) {
        // 1. Check to see if HealthKit Is Available on this device
        
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthKitSetupError.notAvailableOnDevice)
            
            return
        }
        
        // 2. Prepare the data types that will interact with HealthKit
//        guard   let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
//                let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType),
//                let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
//                let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
//                let height = HKObjectType.quantityType(forIdentifier: .height),
//                let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
//                let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
//
//                completion(false, HealthKitSetupError.dataTypeNotAvailable)
//                return
//        }
        
        guard let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount),
                let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate),
                let activityEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
                let sleep = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            completion(false, HealthKitSetupError.dataTypeNotAvailable)
            
            return
        }
        
        // 3. Prepare a list of types you want HealthKit to read and write
        let workout = HKObjectType.workoutType()
    
        let writeTypesSet: Set<HKSampleType> = [stepCount, heartRate, activityEnergy, workout, sleep]
        let readTypesSet: Set<HKObjectType> = [stepCount, heartRate, activityEnergy, workout, sleep]
        
        let hkStore = HKHealthStore()
        // 4. Request Authorization
        hkStore.requestAuthorization(toShare: writeTypesSet, read: readTypesSet) { success, error in
            // Determine if the user saw the permission view
//            if success {
//                print("User was shown permission view")
//                
//                // ** IMPORTANT
//                // Check for access to your HealthKit Type(s). This is an example of using BodyMass.
//                for i in writeTypesSet {
//                    if hkStore.authorizationStatus(for: i) == .sharingAuthorized {
//                        print("Permission Granted to Access BodyMass")
//                    } else {
//                        print("Permission Denied to Access BodyMass")
//                    }
//                }
//                
//            } else {
//                print("User was not shown permission view")
//                
//                // An error occurred
//                if let e = error {
//                    print(e)
//                }
//            }
            completion(success, error)
        }

    }
    
}
