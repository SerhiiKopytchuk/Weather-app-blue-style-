//
//  Mark.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 08.12.2022.
//

import SwiftUI
import MapKit

struct Mark: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    var show = false
}
