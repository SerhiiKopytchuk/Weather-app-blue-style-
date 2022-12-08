//
//  LoaderView.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 08.12.2022.
//

import SwiftUI
import Foundation

struct Loader: View {
    // MARK: - vars

    @State private var animate = false

    // MARK: - body
    var body: some View {

        VStack {
            Circle()
                .trim(from: 0, to: 0.8)
                .stroke(
                    AngularGradient(gradient: .init(colors: [ Color.darkBlue,
                                                              Color.blue,
                                                              Color.gray.opacity(0.3)
                                                            ]), center: .center),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .frame(width: 45, height: 45)
                .rotationEffect(.degrees(animate ? 360 : 0))
                .animation( .linear(duration: 0.7).repeatForever(autoreverses: false), value: animate)
                .padding()
                .onAppear {
                    DispatchQueue.main.async {
                        animate = true
                    }
            }
            Text("Please Wait...")

        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)

    }
}
