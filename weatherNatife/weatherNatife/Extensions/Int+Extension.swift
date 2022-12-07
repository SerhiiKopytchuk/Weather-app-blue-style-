//
//  Int+Extension.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 07.12.2022.
//

import SwiftUI

extension Int {
    var toDate: Date {
        return Date(timeIntervalSince1970: Double(self))
    }
}
