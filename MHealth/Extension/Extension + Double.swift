//// 	 
//	Extension + Double.swift
//	MHealth
//
//	Created By Navneet on 29/12/24
//


import Foundation

extension Double {
    func removeZerosFromEndString() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return String(formatter.string(from: number) ?? "")
    }
    
    func removeZerosFromEnd() -> Double {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter.number(from:  String(formatter.string(from: number) ?? "0"))?.doubleValue ?? 0
    }
}

extension TimeInterval {
    func getDateFromTimeStamp() -> Date {
        Date(timeIntervalSince1970: self)
    }
    
    func convertToTimeString(from fromUnit: UnitDuration = .minutes, to unitTo: UnitDuration = .hours) -> String {
        let timeMeasure = Measurement(value: self, unit: fromUnit)
        let hours = timeMeasure.converted(to: unitTo)
        if hours.value > 1 {
            let minutes = timeMeasure.value.truncatingRemainder(dividingBy: 60)
            return String(format: "%.f %@ %.f %@", hours.value, "h", minutes, "min")
        }
        return String(format: "%.f %@", timeMeasure.value, "min")
    }
}
