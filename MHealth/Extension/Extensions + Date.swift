//// 	 
//	Extensions + Date.swift
//	MHealth
//
//	Created By Navneet on 22/12/24
//


import Foundation

//MARK: - DATE EXTENSION

extension Date{
    enum DateFormatConst: String{
        case EEEddMMM = "EEE, dd MMM"
        case EEEddMMMyyyy = "EEE, dd MMM yyyy"
        case ddMMMyyyy   = "dd MMM yyyy"
        case yyyyMMddTHHmmssZ = "yyyy-MM-dd'T'HH:mm:ssZ"
        case yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
        case Hmma = "H:mm a"
        case HH = "HH"
        
        
        
    }
    func getCalendarWithUTC() -> Calendar {
        var calender = Calendar.current
        calender.timeZone = TimeZone(identifier: "UTC") ?? .gmt
        return calender
    }
    
    func getCalendarWithCurrentRegion() -> Calendar {
        var calender = Calendar.current
        calender.locale = Locale.current
        calender.timeZone = TimeZone.current
        return calender
    }
    
    func getDateStringFromUTC(_ format: DateFormatConst = .yyyyMMddHHmmss, formatStr: String? = nil) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = getCalendarWithUTC()
        dateFormatter.dateFormat = formatStr ?? format.rawValue
        return dateFormatter.string(from: self)
    }
    
    func getDateFromUTC(_ format: DateFormatConst = .yyyyMMddHHmmss, formatStr: String? = nil) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = getCalendarWithUTC()
        dateFormatter.dateFormat = formatStr ?? format.rawValue
        return dateFormatter.date(from: dateFormatter.string(from: self))!
    }
    
    func getDateStringFromCurrentRegion(_ format: DateFormatConst = .yyyyMMddHHmmss, formatStr: String? = nil) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = getCalendarWithUTC()
        dateFormatter.dateFormat = formatStr ?? format.rawValue
        return dateFormatter.string(from: getDateFromUTC(format,formatStr: formatStr) )
    }
    
    func getDateFromCurrentRegion(_ format: DateFormatConst = .yyyyMMddHHmmss, formatStr: String? = nil) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = getCalendarWithCurrentRegion()
        dateFormatter.dateFormat = formatStr ?? format.rawValue
        return dateFormatter.date(from: getDateStringFromCurrentRegion(format,formatStr: formatStr))!
    }
    
    func getTimeStampFromDateUTC(_ format: DateFormatConst = .yyyyMMddTHHmmssZ, formatStr: String? = nil) -> TimeInterval{
        return getDateFromUTC(format, formatStr: formatStr).timeIntervalSince1970
    }
    
    //#COMMENT: - Calculate difference between two dates
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    //#COMMENT: - Calculate date with timeZone and format
    func getCurrentTimeWithTimeZone(date: Date? = nil,  _ timeZone: TimeZone, format: String) -> String{
        let currentDate = date ?? Date()
        let dateFormater = DateFormatter()
        dateFormater.calendar = getCalendarWithCurrentRegion()
        dateFormater.dateFormat = format
        return dateFormater.string(from: currentDate)
    }
}

//MARK: - Sleep 
extension Date{
    func getTimeFromAngle(angle: Double) -> Date{
        // 360 / 12 = 30
        // 12 = hours
        let progress =  angle / 30
        // It will be 6.05
        // 6 is hour
        // 0.5 is Minutes
        let hour = Int(progress)
        // Why 12
        // Since we're goint to update time for each 5 minutes not for each minute
        // 0.1 = 5 minute
        let remainder = (progress.truncatingRemainder(dividingBy: 1) * 12).rounded()
        var minutes = (remainder * 5)
        // This is because minutes are returning 60 ( 12*5)
        // avoiding that to get perfect time
        minutes = (minutes > 55 ? 55 :  minutes)
        let formmatter = DateFormatter()
        formmatter.dateFormat = "hh:mm:ss"
        
        if let date = formmatter.date(from: "\(hour):\(Int(minutes)):00"){
            return date
        }
        return .init()
    }
    
    func getTimeDiffFromAngle(start: Double, end: Double) -> (hours: Int, min: Int){
        let calender =  Calendar.current
        let result = calender.dateComponents([.hour, .minute], from: getTimeFromAngle(angle: start), to: getTimeFromAngle(angle: end))
        return (result.hour ?? 0 , result.minute ?? 0)
    }
    
    func getMinutesDifferenceFromTwoDates(start: Date, end: Date) -> Int{
        let diffSeconds = Int(end.timeIntervalSince1970 - start.timeIntervalSince1970)
        let minutes = diffSeconds / 60
        // let hours = diffSeconds / 3600
        return minutes
    }
    
    func getTimeIntervalDifferenceFromTwoDates(start: Date, end: Date) -> Double{
        end.timeIntervalSince1970 - start.timeIntervalSince1970
    }
    
    func getTimeFormDate(start: TimeInterval, end: TimeInterval) -> String{
        let diff = end - start
        return diff.stringFromTimeInterval()
    }
    
    func isDateInYesterday(_ date: Date? = nil) -> Bool{
        getCalendarWithCurrentRegion().isDateInYesterday(date ?? self)
    }
    
    func isDateInToday(_ date: Date? = nil) -> Bool{
        getCalendarWithCurrentRegion().isDateInToday(date ?? self)
    }
    
    func isDateInTomorrow(_ date: Date? = nil) -> Bool{
        getCalendarWithCurrentRegion().isDateInTomorrow(date ?? self)
    }
}

