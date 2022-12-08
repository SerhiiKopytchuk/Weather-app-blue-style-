//
//  AdaptiveView.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 07.12.2022.
//

import SwiftUI

struct AdaptiveView<Content: View>: View {

    // MARK: - variables

    var content: Content
    @State private var isVertical: Bool = true

    // MARK: - init

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    // MARK: - body
    var body: some View {
        if !isVertical {
            HStack(spacing: 0) {
                content
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .onRotate { orientation in
                deviceRotated(orientation: orientation)
            }
        } else {
            VStack(spacing: 0) {
                content
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .onAppear {
                let size = UIScreen.main.bounds.size
                self.isVertical = size.height > size.width
            }
            .onRotate { orientation in
                deviceRotated(orientation: orientation)
            }
        }
    }

    // MARK: - functions

    private func deviceRotated(orientation: UIDeviceOrientation) {
        if orientation == .landscapeLeft || orientation == .landscapeRight {
            isVertical = false
        } else {
            isVertical = true
        }
    }
}

