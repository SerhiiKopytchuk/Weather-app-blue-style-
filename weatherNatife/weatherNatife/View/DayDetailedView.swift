//
//  DayDetailedView.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 07.12.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct DayDetailedView: View {

    @Binding var day: Forecastday?

    let imageWidth: CGFloat


    var body: some View {
        HStack {
            WebImage(url: self.day?.day.condition.icon.toImageURL)
                    .resizable()
                    .frame(width: imageWidth, height: imageWidth, alignment: .leading)


            VStack {
                HStack {
                    Image("ic_temp")
                        .font(.title3)
                        .foregroundColor(.white)

                    Text(day?.maxAndMin ?? "")
                        .font(.title3)
                        .foregroundColor(.white)
                        .bold()

                    Spacer()
                }

                HStack {
                    Image("ic_humidity")
                        .font(.title3)
                        .foregroundColor(.white)

                    Text("\(day?.day.avghumidity ?? 0)%")
                        .font(.title3)
                        .foregroundColor(.white)
                        .bold()

                    Spacer()
                }

                HStack {
                    Image("ic_wind")
                        .font(.title3)
                        .foregroundColor(.white)

                    Text("\(Int(day?.avgWind ?? 0.0 )) Kp/h")
                        .font(.title3)
                        .foregroundColor(.white)
                        .bold()

                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}