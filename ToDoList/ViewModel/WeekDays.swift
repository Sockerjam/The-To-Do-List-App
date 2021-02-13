import Foundation

enum WeekDays: String, CaseIterable {
    case Mon, Tue, Wed, Thu, Fri
}


func weekdayNameFrom(weekdayNumber: Int) -> String {
    let calendar = Calendar.current
    let dayIndex = ((weekdayNumber - 1) + (calendar.firstWeekday - 1)) % 7
    return calendar.weekdaySymbols[dayIndex]
}
