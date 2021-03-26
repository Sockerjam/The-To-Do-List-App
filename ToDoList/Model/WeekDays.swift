import Foundation

enum WeekDays {
  
  private static let usable = 1...5
  
  static let shortNames: [String] = usable.map { shortNameFor($0)}
  static let longNames: [String] = usable.map { longNameFor($0)}
  
  static func longNameFor(_ weekdayNumber: Int) -> String {
      let calendar = Calendar.current
      return calendar.weekdaySymbols[weekdayNumber]
  }
  
  static func shortNameFor(_ weekdayNumber: Int) -> String {
      let calendar = Calendar.current
    return calendar.shortWeekdaySymbols[weekdayNumber]
  }
}
