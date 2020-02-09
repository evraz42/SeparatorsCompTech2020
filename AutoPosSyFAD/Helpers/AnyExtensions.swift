//
//  AnyExtensions.swift
//  AutoPosSyFAD
//
//  Created by Madara2hor on 03.02.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    var dateValue: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        formatter.timeZone = .none
        return formatter.date(from: self)!
    }
}

extension Date {
    var stringValue: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        formatter.timeZone = .none
        return formatter.string(from: self)
    }
}
