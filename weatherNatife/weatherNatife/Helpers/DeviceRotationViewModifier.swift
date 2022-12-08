//
//  DeviceRotationViewModifier.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 08.12.2022.
//

import SwiftUI


struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}
