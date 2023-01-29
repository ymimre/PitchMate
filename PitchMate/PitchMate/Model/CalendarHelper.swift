//
//  AuthenticatePhoneNumber.swift
//  PitchMate
//
//  Created by Yusuf Mert İmre on 27.12.2022.
//

import Foundation
import UIKit

class CalendarHelper
{
    let calendar = Calendar.current
    
    func nextDay(date: Date) -> Date
    {
        return calendar.date(byAdding: .day, value: 1, to: date)!
    }
    
    func previousDay(date: Date) -> Date
    {
        return calendar.date(byAdding: .day, value: -1, to: date)!
    }
    
    func nextWeek(date: Date) -> Date
    {
        return calendar.date(byAdding: .day, value: 7, to: date)!
    }
    
    func dateToString(date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
    
    func stringToDate(string: String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.date(from: string)!
    }
}
