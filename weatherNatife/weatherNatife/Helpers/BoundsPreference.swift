//
//  BoundsPreference.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 08.12.2022.
//

import Foundation
import SwiftUI

struct BoundsPreference: PreferenceKey {

    static var defaultValue: [String: Anchor<CGRect>] = [:]

    static func reduce(value: inout [String: Anchor<CGRect>], nextValue: () -> [String: Anchor<CGRect>]) {
        value.merge(nextValue()) {$1}
    }
}
