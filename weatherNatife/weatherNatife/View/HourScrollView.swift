//
//  HourScrollView.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 07.12.2022.
//

import SwiftUI

struct HourScrollView: View {

    // MARK: - variables
    @EnvironmentObject private var weatherViewModel: WeatherViewModel

    // MARK: - body

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(weatherViewModel.currentDay?.hour ?? [], id: \.id) { hour in
                    if hour.time.hourlyToDate > Date() || hour.time.hourlyToDate.thisHour() {
                        HourListRow(hourForecast: hour)
                            .padding(.horizontal, 15)
                            .padding(.trailing, hour == weatherViewModel.currentDay?.hour.last ? 35 : 0)
                    }
                }
            }
        }
    }
}
