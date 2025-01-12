//// 	 
//	MEnum.swift
//	MHealth
//
//	Created By Navneet on 07/12/24
//	
//

enum MHealthDuration: String, CaseIterable {
    case today
    case weekly
    case monthly
}

enum Gender: String, Codable {
    case Male
    case Female
}

enum ProgressBarEnum: String, Codable {
    case circular
    case semicircular
    case linear
    case none
}

enum ActivityUnitsEnum: String, Codable{
    case steps = "steps"
    case food = "kcal"
    case water = "ml"
    case sleep = "min"
    case none = ""
}

enum ActivityTypeEnum: String, Codable, CaseIterable {
    case Water = "Water"
    case Food = "Food"
    case Steps = "Steps"
    case Sleep = "Sleep"
    case none = "none"
}

enum RecordOtherTypeEnum: String, Codable{
    case workoutHistory
    case none
}

enum MImageStringEnum:  String, Codable{
    case doubleBed = "double-bed"
    case manWalking = "man-walking"
    case waterBottle = "water-bottle"
    case salad = "salad"
    case cardiogram = "cardiogram"
    case exercise = "exercise"
    case timer = "timer"
    case radioSelected = "radioSelected"
    case radioUnselected = "radioUnselected"
    case healthcare = "healthcare"
    case healthcareCloud = "healthcareCloud"
    case healthcareWithMobile = "healthcareWithMobile"
    
    case sysImg_doubleBed = "bed.double.fill"
    case sysImg_manWalking = "figure.step.training"
    case sysImg_waterBottle = "waterbottle.fill"
    case sysImg_circle = "circle"
    case sysImg_forkknife = "fork.knife"
    case sysImg_plus = "plus"
    case sysImg_mug = "mug"
    case sysImg_mugFill = "mug.fill"
    case sysImg_house = "house"
    case sysImg_houseFill = "house.fill"
    case sysImg_person = "person"
    case sysImg_personFill = "person.fill"
    case sysImg_eyeSlash = "eye.slash.fill"
    case sysImg_eye = "eye.fill"
    case sysImg_ellipsis = "ellipsis"
    case sysImg_arrowtriangle = "arrowtriangle.down.fill"
    case sysImg_chevronLeft = "chevron.left"
    case sysImg_camera = "camera"
    case none
}

struct MealSelectionUIData{
    var title: String
    var primaryKey: Int
    var data: Any?
    var isSelected = false
    
    init(title: String, primaryKey: Int, data: Any? = nil, isSelected: Bool = false) {
        self.title = title
        self.primaryKey = primaryKey
        self.data = data
        self.isSelected = isSelected
    }
}

enum MealTypeEnum: String, Codable, CaseIterable{
    case breakFast = "BreakFast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case morningSnack = "Morning snack"
    case afternoonSnack = "Afternoon Snack"
    case eveningSnack = "Evening Snack"
}


enum HomeUIComponent{
    case showAddButton
    case showEnterButton
    case showValue
}

enum MUIAlignmentEnum: String, Codable{
    case trailing
    case top
    case leading
    case bottom
    case none
}

enum UserGender: String, Codable{
    case Male
    case Female
    case Other = "Prefer no to say"
    case None = ""
    
    var genders: [UserGender] {
        [.Male, .Female, .Other]
    }
}

enum MHealthStringConstant: String{
    case AddCalories = "Add Calories"
}
