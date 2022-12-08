//
//  HomeView.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 06.12.2022.
//

import SwiftUI
import SDWebImageSwiftUI
import Foundation
import CoreLocation

struct HomeView: View {

    // MARK: - variables

    @EnvironmentObject private var weatherViewModel: WeatherViewModel

    private var headerHeight: CGFloat
    private let hourlyForecastHeight: CGFloat
    private let screenWidth: CGFloat
    private let imageWidth: CGFloat

    private let notificationCenter = NotificationCenter.default

    @State private var currentDay: Forecastday?

    @State private var receivedData = false

    @State private var daysViewHeight: CGFloat = 0

    @State private var isVertical = false

    @State private var showBottomSheet = false

    @State private var showLocationRequestAlert = false

    // MARK: - computed property

    var presentedAlert: Bool {
        return weatherViewModel.alertMessage != ""
    }

    // MARK: - init

    init() {
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height

        let size = UIScreen.main.bounds.size
        self.isVertical = size.height > size.width

        if width < height {

            let screenHeightPercent = height / 100

            self.screenWidth = width
            self.imageWidth = screenWidth / 2

            self.headerHeight = 30 * screenHeightPercent
            self.hourlyForecastHeight = 15 * screenHeightPercent

        } else {

            let screenHeightPercent = width / 100
            
            self.screenWidth = height
            self.imageWidth = screenWidth / 2
            self.headerHeight = 30 * screenHeightPercent
            self.hourlyForecastHeight = 15 * screenHeightPercent
        }

    }

    // MARK: - Body
    var body: some View {
        AdaptiveView {

            VStack(alignment: .center) {

                header

                dayDateView

                DayDetailedView(day: $currentDay, imageWidth: imageWidth)

            }
            .clipShape(Rectangle())
            .frame(width: screenWidth, height: headerHeight)
            .offset(y: receivedData ? 0 : (-headerHeight - 20))
            .background {
                Color.darkBlue
                    .frame(height: screenWidth)
                    .ignoresSafeArea()
            }


            VStack(spacing: 0) {
                HourScrollView(currentDay: $currentDay)
                    .clipShape(Rectangle())
                    .frame(maxWidth: .infinity)
                    .frame( height: hourlyForecastHeight)
                    .offset(x: receivedData ? 0 : (screenWidth + 20))
                    .background {
                        Color.blue
                    }

                daysScrollView
            }
            .ignoresSafeArea()

        }
        .sheet(isPresented: $showBottomSheet) {
            ChooseLocationView(isOpen: $showBottomSheet)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .overlay(content: {
            loaderView
        })
        .alert(weatherViewModel.alertMessage, isPresented: .constant(presentedAlert), actions: {
            Button("try again") {
                weatherViewModel.getWeather { _ in
                }
                withAnimation {
                    weatherViewModel.alertMessage = ""
                }
            }
        })
        .onAppear {
            self.subscribeToNotification()
        }
        .onRotate { orientation in
            phoneRotated(orientation: orientation)
        }
    }

    // MARK: - ViewBuilders

    @ViewBuilder private var header: some View {
        HStack {
            Button {
                self.showBottomSheet = true
            } label: {
                Image("ic_place")
                    .foregroundColor(.white)
                    .font(.title2)
                Text(weatherViewModel.weather?.location.name ?? "")
                    .foregroundColor(.white)
                    .font(.title2)
            }

            Spacer()

            Button {
                self.weatherViewModel.switchToCurrentLocation {
                    self.showLocationRequestAlert = true
                }
            } label: {
                Image("ic_my_location")
                    .foregroundColor(.white)
                    .font(.title2)
            }

        }
        .alert("We need access to your location in order to use this function", isPresented: $showLocationRequestAlert, actions: {
            Button("Cancel") {
                showLocationRequestAlert = false
            }
        })
        .padding(.horizontal)
        .frame(maxHeight: .infinity, alignment: .top)
    }

    @ViewBuilder private var dayDateView: some View {
        HStack {
            Text(currentDay?.dateEpoch.toDate.toDateTime ?? "")
                .font(.callout)
                .foregroundColor(.white)
                .frame(alignment: .leading)
                .padding(.leading)

            Spacer()
        }
    }

    @ViewBuilder private var daysScrollView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(  weatherViewModel.weather?.forecast.forecastday ?? [], id: \.id) { day in
                    DayListRow(day: day, currentDay: $currentDay, isVertical: $isVertical)
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .readSize { size in
            self.daysViewHeight = size.height
        }
        .offset(y: receivedData ? 0 : (daysViewHeight + 20))
    }

    @ViewBuilder private func highlightedDay(for highlightDay: Forecastday, rect: CGRect) -> some View {
        DayListRow(day: highlightDay, currentDay: $currentDay, isVertical: $isVertical)
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

    @ViewBuilder private var loaderView: some View {
        if weatherViewModel.isShowLoader {
            withAnimation {
                GeometryReader { reader in
                    Loader()
                        .position(x: reader.size.width/2, y: reader.size.height/2)
                }.background {
                    Color.black
                        .opacity(0.65)
                        .edgesIgnoringSafeArea(.all)
                }
            }
        }
    }

    // MARK: - functions
    private func subscribeToNotification() {
        self.notificationCenter.addObserver(forName:  Notification.Name("receivedData"), object: nil, queue: .main) { notification in
            self.currentDay = weatherViewModel.weather?.forecast.forecastday.first
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring()) {
                    self.receivedData = true
                }
            }
        }
    }

    private func phoneRotated(orientation: UIDeviceOrientation) {
        if orientation == .landscapeLeft || orientation == .landscapeRight {
            self.isVertical = false
        } else {
            isVertical = true
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(WeatherViewModel())
    }
}

