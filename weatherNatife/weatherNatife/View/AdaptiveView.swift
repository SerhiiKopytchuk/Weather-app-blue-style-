//
//  AdaptiveView.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 07.12.2022.
//

import SwiftUI

struct AdaptiveView<Content: View>: View {
    var content: Content

    @State var isVertical: Bool = true

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
  }

  var body: some View {
      if !isVertical {
          HStack(spacing: 0) {
        content
      }
          .ignoresSafeArea(.all, edges: .bottom)
      .onRotate { orientation in
          if orientation == .landscapeLeft || orientation == .landscapeRight {
              isVertical = false
          } else {
              isVertical = true
          }
      }
    } else {
        VStack(spacing: 0) {
        content
      }
        .onAppear {
            let size = UIScreen.main.bounds.size
            self.isVertical = size.height > size.width
        }
      .onRotate { orientation in
          if orientation == .landscapeLeft || orientation == .landscapeRight {
              isVertical = false
          } else {
              isVertical = true
          }
      }
    }
  }
}

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


extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

