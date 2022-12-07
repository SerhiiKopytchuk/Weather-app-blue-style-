//
//  HomeView.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 06.12.2022.
//

import SwiftUI
import SDWebImageSwiftUI
import Foundation

struct HomeView: View {

    @EnvironmentObject var weatherViewModel: WeatherViewModel

    var headerHeight: CGFloat
    let hourlyForecastHeight: CGFloat
    let dailyForecastHeight: CGFloat
    let screenWidth: CGFloat

    let imageWidth: CGFloat

    let notificationCenter = NotificationCenter.default

    @State var currentDay: Forecastday?

    @State var currentImageURL: URL?

    @State var receivedData = false

    @State var daysViewHeight: CGFloat = 0

    @State private var isVertical = false


    init() {
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height

        if width < height {

            let screenHeightPercent = height / 100

            self.screenWidth = width
            self.imageWidth = screenWidth / 2

            self.headerHeight = 30 * screenHeightPercent
            self.hourlyForecastHeight = 15 * screenHeightPercent
            self.dailyForecastHeight = 40 * screenHeightPercent


        } else {

            let screenHeightPercent = width / 100
            
            self.screenWidth = height
            self.imageWidth = screenWidth / 2
            self.headerHeight = 30 * screenHeightPercent
            self.hourlyForecastHeight = 15 * screenHeightPercent
            self.dailyForecastHeight = 40 * screenHeightPercent
        }


    }

    var body: some View {
        AdaptiveView {

            VStack(alignment: .center) {

                header

                HStack {
                    Text(currentDay?.dateEpoch.toDate.toDateTime ?? "")
                        .font(.callout)
                        .foregroundColor(.white)
                        .frame(alignment: .leading)
                        .padding(.leading)

                    Spacer()
                }

                DayDetailedView(day: $currentDay, imageWidth: imageWidth)

            }
            .clipShape(Rectangle())
            .frame(width: screenWidth, height: headerHeight)
            .offset(y: receivedData ? 0 : -headerHeight)
            .background {
                    Color.darkBlue
                        .frame(height: screenWidth)
                        .ignoresSafeArea()
            }


            VStack(spacing: 0) {
                HourScrollView(currentDay: $currentDay)
                .clipShape(Rectangle())
                .frame(width: screenWidth, height: hourlyForecastHeight)
                .offset(x: receivedData ? 0 : screenWidth)
                .background {
                    Color.blue
                }

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(  weatherViewModel.weather?.forecast.forecastday ?? [], id: \.id) { day in
                            DayListRow(day: day, currentDay: $currentDay)
                                .padding(.horizontal)
                                .anchorPreference(key: BoundsPreference.self, value: .bounds, transform: { anchor in
                                    return [(day.id  ): anchor]
                                })
                        }
                    }
                    .overlayPreferenceValue(BoundsPreference.self) { values in
                        if let currentDay {
                                if let preference = values.first(where: { item in
                                    item.key == currentDay.id
                                }) {
                                    GeometryReader { proxy in
                                        let rect = proxy[preference.value]
                                        highlightedDay(for: currentDay, rect: rect)
                                    }
                                    .transition(.asymmetric(insertion: .identity, removal: .offset(x: 1)))
                                }
                        }
                    }
                }
                .clipShape(Rectangle())
                .frame(width: screenWidth)
                .frame(maxHeight: .infinity)
                .readSize { size in
                    self.daysViewHeight = size.height
                }
                .offset(y: receivedData ? 0 : daysViewHeight)
            }
        }
        .onAppear {
            self.notificationCenter.addObserver(forName:  Notification.Name("receivedData"), object: nil, queue: .main) { notification in
                self.currentDay = weatherViewModel.weather?.forecast.forecastday.first
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    withAnimation(.spring()) {
                        self.receivedData = true
                    }
                }
            }

            let size = UIScreen.main.bounds.size
            self.isVertical = size.height > size.width
        }
        .onRotate { orientation in
            if orientation == .landscapeLeft || orientation == .landscapeRight {
                self.isVertical = false
            } else {
                isVertical = true
            }
        }
    }

    @ViewBuilder private var header: some View {
        HStack {
            Image("ic_place")
                .foregroundColor(.white)
                .font(.title2)
            Text(weatherViewModel.weather?.location.name ?? "")
                .foregroundColor(.white)
                .font(.title2)

            Spacer()
            Image("ic_my_location")
                .foregroundColor(.white)
                .font(.title2)
        }
        .padding(.horizontal)
        .frame(maxHeight: .infinity, alignment: .top)
    }

    @ViewBuilder private func highlightedDay(for highlightDay: Forecastday, rect: CGRect) -> some View {
        DayListRow(day: highlightDay, currentDay: $currentDay)
            .padding(.horizontal)
            .background {
                Rectangle()
                    .fill(.white)
                    .shadow(color: .blue, radius: 10, x: 0, y: 0)

            }
            .shadow(color: .blue.opacity(0.25), radius: 24, x: 0, y: 0)
            .frame(width: rect.width, height: rect.height)
            .offset(x: rect.minX, y: rect.minY)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(WeatherViewModel())
    }
}

