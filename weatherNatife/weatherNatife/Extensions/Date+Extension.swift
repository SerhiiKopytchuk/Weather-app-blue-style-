//
//  ExtensionDate.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 07.12.2022.
//

import SwiftUI

extension Date {
    var toDateTime: String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "E, d MMM"
        return dateFormater.string(from: self)
    }

    var toHour: String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "HH"
        return dateFormater.string(from: self)
    }

    var toDay: String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "E"
        return dateFormater.string(from: self)

    }

    func thisHour() -> Bool {
         return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .hour)
    }
}
