////
//	MHealthViewModel.swift
//	MHealth
//
//	Created By Navneet on 15/12/24
//


import Foundation
@preconcurrency import Combine
import SwiftUI
import HealthKit

@MainActor
class HealthViewModel: ObservableObject {
    
    @Published var uiViewModel: MHealthUIViewModel
    @Published var healthActivitys: [ActivityTypeEnum : HealthActivity] = [:]
    @Published var mHealthUser: MHealthUser
    @Published var isAuthorized: Bool = false
    @Published var showAlert: Bool = false
    @Published var isPresentBottomSheetView = false

    var cancellables = Set<AnyCancellable>()
    var healthStore: HKHealthStore!
    private let healthKitManager: MHealthKitManagingProtocol
    
    init(uiViewModel: MHealthUIViewModel = MHealthUIViewModel(), manager: MHealthKitManager = MHealthKitManager()) {
        self.uiViewModel = uiViewModel
        guard HKHealthStore.isHealthDataAvailable() else {
            fatalError("This app requires a device that supports HealthKit")
        }
        mHealthUser = .init(firstName: "User", lastName: "", email: "", gender: UserGender.None.rawValue, dob: -1 , targets: [])
        healthKitManager = manager
    }
    
    deinit{
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}

//MARK: - Calculate Activities
extension HealthViewModel{
    func isTodayHealthActivity() -> Bool{
        return healthActivitys.values.allSatisfy({val in
            if let today = val.todaysActivity.todayDate, today.isDateInToday() && !today.isDateInYesterday(){
                return true
            }
            return false
        })
    }
    
    func calulateHealthActivity(){
        if let dict = DBUtils.getHealthActivity(mHealthUser.email), !dict.isEmpty{
            healthActivitys = dict
            let isTodaysActivity = isTodayHealthActivity()
            healthActivitys.forEach({ (key, val) in
                if isTodaysActivity{
                    updateHealthActivityFor(value: nil, for: key)
                }else{
                    val.prevActivity.append(val.todaysActivity)
                    if let detail = getBlankActivityDetail(for: key){
                        val.todaysActivity = detail
                        updateHealthActivityFor(value: 0, for: key)
                    }
                }
                val.todaysActivity.updateTimeStamp()
            })
            
        }else{
            healthActivitys = getDefaultHealthActivitys()
            healthActivitys.forEach({ (key, val) in
                val.todaysActivity.updateTimeStamp()
                updateHealthActivityFor(value: 0, for: key)
            })
        }
    }
    
    func getBlankActivityDetail(for type: ActivityTypeEnum) -> HealthDetail?{
        if let first = getDefaultHealthActivitys().first(where: { $0.key == type})?.value{
            if let target = getTargets(for: type){
                first.todaysActivity.target = target
                return first.todaysActivity
            }
        }
        return nil
    }
    
    func getTargets(for activity: ActivityTypeEnum) -> HealthTarget?{
        if let first =  mHealthUser.targets.first(where: { $0.activityType == activity}){
            return first
        }else{
            let targets = MHealthUtils.returnModelObjFromLocalJson("DefaultTargets", [HealthTarget].self) ?? []
            return targets.first(where: { $0.activityType == activity})
        }
    }
    
    func getDefaultHealthActivitys() ->   [ActivityTypeEnum : HealthActivity]{
        let array = MHealthUtils.returnModelObjFromLocalJson("DefaultActivity", [String: HealthActivity].self) ?? [:]
        return array.map({ $0.value}).toDictionary(with: { $0.typeId})!
    }
    
    func saveHealthActivity(_ data: [ActivityTypeEnum : HealthActivity]){
        DBUtils.saveHealthActivity(mHealthUser.email, data)
    }
}

//MARK: - User - Health Details
extension HealthViewModel{
    func getUser() -> MHealthUser?{
        self.mHealthUser
    }
    func getUserName() -> String{
        mHealthUser.getUserName()
    }
    
    func getFirstName() -> String{
        mHealthUser.firstName ?? "User"
    }
    
    func getUserHeightInStr() -> String{
        let height = String(mHealthUser.height ?? 0)
        return height == "0.0" ? "" : height
    }
    
    func getUserWeightInStr() -> String{
        let weight = String(mHealthUser.weight ?? 0)
        return weight == "0.0" ? "" : weight
    }
    
    func getUserGender() -> String{
        let gender =  mHealthUser.gender
        return  gender == UserGender.None.rawValue ? "" : gender
    }
    
    func getCurrentDateString() -> String{
        Date().getDateStringFromUTC(.EEEddMMM)
    }
    
    func getFoodDishes(for dish: MealTypeEnum? = nil) -> [FoodDetail]{
        guard let activity = healthActivitys[.Food] else{
            return []
        }
        return activity.getFoodDishes(for: dish)
    }
    
    func getRecentFoodDishes(for dish: MealTypeEnum? = nil) -> [FoodDetail]{
        guard let activity = healthActivitys[.Food] else{
            return []
        }
        
        var array:  [FoodDetail] = []
        activity.getFoodDishes(for: dish).forEach({ item in
            if !array.contains(where:  {$0.name == item.name}){
                array.append(item)
            }
        })
        return array
    }
    
    func setTotalCalCarbFat(for dish: MealTypeEnum? = nil) -> (totalCaloriesForMeal: String, totalCarbFartProtien: String) {
        var calories = 0.0
        var carb = 0.0
        var fat = 0.0
        var protien = 0.0
        getFoodDishes(for: dish).forEach({item in
            if let carbFirst = item.nutrients.first(where: { $0.type == .caloriesPer}){
                calories += carbFirst.updatedVal
            }
            if let carbFirst = item.nutrients.first(where: { $0.type == .carbohydrates}){
                carb += carbFirst.updatedVal
            }
            if let carbFirst = item.nutrients.first(where: { $0.type == .fat}){
                fat += carbFirst.updatedVal
            }
            if let carbFirst = item.nutrients.first(where: { $0.type == .protien}){
                protien += carbFirst.updatedVal
            }
        })
        return ("Total calories: \(calories) kcal", "carb \(carb), fat \(fat), protien \(protien)")
    }
}

//MARK: - Request Permissions and Register Health Services
extension HealthViewModel{
    private func requestHealthkitPermissions() -> (toShare : Set<HKSampleType>?, read: Set<HKObjectType>?) {
        let toShare = Set([
            HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.workoutType()
        ])
        let read = Set([
            HKQuantityType(.stepCount),
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
            HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
            HKObjectType.quantityType(forIdentifier: .height)!,
            HKObjectType.characteristicType(forIdentifier: .bloodType)!,
            HKObjectType.characteristicType(forIdentifier: .biologicalSex)!
        ])
        return (toShare, read)
    }
    
    func registerHealthServices(_ mHealthUser: MHealthUser? = nil){
        healthStore = HKHealthStore()
        let reqPermissions = requestHealthkitPermissions()
        healthStore.requestAuthorization(toShare: reqPermissions.toShare, read: reqPermissions.read) { [weak self] (success, error) in
            guard let self else{ return }
            guard let error else{
                print("Request Authorization -- Success: ", success)
                Task{@MainActor in
                    self.isAuthorized = success
                    self.startTimerToUpdate()
                }
                return
            }
            print("HealthKit authorization failed: \(String(describing: error))")
        }
        if let mHealthUser = mHealthUser{
            self.mHealthUser = mHealthUser
            calulateHealthActivity()
        }
    }
}

//MARK: - Timer and Update
extension HealthViewModel{
    @MainActor
    private func startTimerToUpdate() {
        // Create a Combine timer that fires every 5 seconds
        Timer
            .publish(every: 2.0, tolerance: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] timer in
                guard let self else{ return}
                self.updateHealthActivity(for: .today)
            }
            .store(in: &cancellables)
    }
    
    private func updateHealthActivity(for timeFrame: MHealthDuration = .today){
        self.fetchStepCount(for: timeFrame)
        self.fetchUserSleepAnalysis(for: timeFrame)
    }
}

//MARK: - Step Activity
extension HealthViewModel{
    private func fetchStepCount(for timeFrame: MHealthDuration = .today) {
        healthKitManager.getStepCount(forTimeFrame: timeFrame) { stepCount, error in
            DispatchQueue.main.async {[weak self] in
                guard let self else{ return}
                guard let _ = error else {
                    updateHealthActivityFor(value: stepCount, for: .Steps)
                    return
                }
            }
        }
    }
}

//MARK: - Common Activity
extension HealthViewModel{
    func updateHealthActivityFor(value: Double? = nil, for type: ActivityTypeEnum){
        objectWillChange.send()
        guard let activity = healthActivitys[type] else{
            return
        }
        let targetValue = activity.todaysActivity.target.target ?? 0
        let updateVal =  value ?? activity.todaysActivity.value
        self.healthActivitys[type]!.todaysActivity.value  = updateVal
        let valueDisc = activity.todaysActivity.getActivityValue("/\(Int(targetValue))")
        self.healthActivitys[type]?.todaysActivity.valueDesc = valueDisc
        if type == .Steps || type == .Sleep{
            self.healthActivitys[type]?.todaysActivity.percentage = (updateVal / targetValue) * 100
        }
        let attributedStr = self.healthActivitys[type]?.getTitleWithAttributedString()
        self.healthActivitys[type]?.attributedTitle = attributedStr ?? "NA"
        print(type.rawValue + " : >>> " + "\(updateVal)" + valueDisc + " \(Date().getDateStringFromUTC())")
    }
        
    
    func updateSleepValue(for type: ActivityTypeEnum, start: Date?, end: Date?, isManual: Bool) {
        objectWillChange.send()
        guard let activity = healthActivitys[type], let startTime = start,  let endTime = end, activity.todaysActivity.isManual   else{
            return
        }
        //var sleepMins = ((end * 12) - (start * 12) * 12)
        healthActivitys[type]!.todaysActivity.isManual = isManual
        let targetValue = activity.todaysActivity.target.target ?? 0
        let sleepMins = Date().getMinutesDifferenceFromTwoDates(start: startTime, end: endTime)
        self.healthActivitys[type]?.todaysActivity.value  = Double(sleepMins)
        self.healthActivitys[type]?.todaysActivity.startTimeStamp = startTime.timeIntervalSince1970
        self.healthActivitys[type]?.todaysActivity.endTimeStamp = endTime.timeIntervalSince1970
        self.healthActivitys[type]?.todaysActivity.percentage = (Double(sleepMins) / targetValue) * 100
        let attributedStr = self.healthActivitys[type]?.getTitleWithAttributedString() ?? ""
        self.healthActivitys[type]?.attributedTitle = attributedStr
        let valueDisc = activity.todaysActivity.getActivityValue("/\(Int(targetValue))")
        self.healthActivitys[type]?.todaysActivity.valueDesc = valueDisc
        print(type.rawValue + " : >>> " + "\(sleepMins)" + valueDisc + " \(Date().getDateStringFromUTC())")
        saveHealthActivity(healthActivitys)
        
    }
}

//MARK: - Water Activity
extension HealthViewModel{
    func updateWaterValue(for item: DashboardCardData) {
        objectWillChange.send()
        guard let activity = healthActivitys[item.type] else{
            return
        }
        healthActivitys[item.type]!.todaysActivity.isManual = true
        let targetValue = activity.todaysActivity.target.target ?? 0
        let qnt = activity.todaysActivity.target.qnt ?? 0
        let value = activity.todaysActivity.value
        activity.todaysActivity.value  = value + qnt
        let attributedStr = activity.getTitleWithAttributedString()
        activity.attributedTitle = attributedStr
        let valueDisc = activity.todaysActivity.getActivityValue("/\(Int(targetValue))")
        activity.todaysActivity.valueDesc = valueDisc
        saveHealthActivity(healthActivitys)
    }
    
    func updateActivity(for type: ActivityTypeEnum ,value: Double, valueDisc: String, attributedStr: AttributedString){
        guard let activity = healthActivitys[type] else{
            return
        }
        activity.todaysActivity.value  = value
        activity.attributedTitle = attributedStr
        activity.todaysActivity.valueDesc = valueDisc
        saveHealthActivity(healthActivitys)
    }
}

//MARK: - Sleep Activity
extension HealthViewModel{
    private func fetchUserSleepAnalysis(for timeFrame: MHealthDuration = .today) {
        healthKitManager.getSleepAnalysis(forTimeFrame: timeFrame) {start, end, value, error in
            Task {@MainActor [weak self] in
                guard let self else{ return}
                guard let _ = error else {
                    self.updateSleepValue(for: .Sleep, start: start, end: end, isManual: false)
                    return
                }
            }
        }
    }
}


//MARK: - Food Activity
extension HealthViewModel{
    func updateFoodCalories(_ mealType: String, timeStamp: TimeInterval, calories: Int){
        objectWillChange.send()
        let type: ActivityTypeEnum = .Food
        guard let activity = healthActivitys[type], let meal = MealTypeEnum(rawValue: mealType) else{
            return
        }
        if let firstIndex = activity.todaysActivity.meals.firstIndex(where: { $0.mealType == $0.mealType}){
            activity.todaysActivity.meals[firstIndex].meals.append(.init(name: "", calories: calories))
        } else{
            activity.todaysActivity.meals.append(.init(mealType: meal, mealTimeStamp: timeStamp, meals:[.init(name: "Quick added calories", calories: calories)] ))
        }
        activity.todaysActivity.isManual = true
        let targetValue = activity.todaysActivity.target.target ?? 0
        activity.todaysActivity.value  = activity.todaysActivity.getTotalCalories()
        let attributedStr = activity.getTitleWithAttributedString()
        activity.attributedTitle = attributedStr
        let valueDisc = activity.todaysActivity.getActivityValue("/\(Int(targetValue))")
        activity.todaysActivity.valueDesc = valueDisc
        saveHealthActivity(healthActivitys)
    }
    
    func addFood(_ mealType: String, timeStamp: TimeInterval? = nil, food: FoodDetail){
        objectWillChange.send()
        let type: ActivityTypeEnum = .Food
        guard let activity = healthActivitys[type], let meal = MealTypeEnum(rawValue: mealType) else{
            return
        }
        if let firstIndex =  activity.todaysActivity.meals.firstIndex(where: { $0.mealType == meal}){
            activity.todaysActivity.meals[firstIndex].meals.append(food)
        } else{
            activity.todaysActivity.meals.append(.init(mealType: meal, mealTimeStamp: timeStamp, meals:[food] ))
        }
        activity.todaysActivity.isManual = true
        let targetValue = activity.todaysActivity.target.target ?? 0
        activity.todaysActivity.value  = activity.todaysActivity.getTotalCalories()
        let attributedStr = activity.getTitleWithAttributedString()
        activity.attributedTitle = attributedStr
        let valueDisc = activity.todaysActivity.getActivityValue("/\(Int(targetValue))")
        activity.todaysActivity.valueDesc = valueDisc
        saveHealthActivity(healthActivitys)
    }
}

//MARK: - Helper Function
extension HealthViewModel {
    func mapValue(value: Double, fromRange: ClosedRange<Double>, toRange: ClosedRange<Double>) -> Double {
        let normalizedValue = (value - fromRange.lowerBound) / (fromRange.upperBound - fromRange.lowerBound)
        let mappedValue = toRange.lowerBound + normalizedValue * (toRange.upperBound - toRange.lowerBound)
        return min(toRange.upperBound, max(toRange.lowerBound, mappedValue))
    }
}

extension HKHealthStore: @retroactive ObservableObject{}
