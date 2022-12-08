//
//  HourListRow.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 06.12.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct HourListRow: View {

    // MARK: - variables

    let hourForecast: Hour

    // MARK: - body

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                Text(hourForecast.time.hourlyToDate.toHour)
                    .bold()
                    .font(.callout)
                    .foregroundColor(.white)
                Text("00")
                    .font(.caption)
                    .foregroundColor(.white)
            }
            .padding(.vertical)


            WebImage(url: hourForecast.condition.icon.toImageURL)
                .frame(width: 50, height: 50)



            Text("\(Int(hourForecast.tempC))°")
                .foregroundColor(.white)
                .padding(.bottom)

        }
    }
}

struct HourListRow_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(WeatherViewModel())
    }
}
