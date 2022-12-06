//
//  HomeView.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 06.12.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeView: View {

    @EnvironmentObject var weatherViewModel: WeatherViewModel

    let headerHeight: CGFloat
    let hourlyForecastHeight: CGFloat
    let dailyForecastHeight: CGFloat

    @State var currentImageURL: URL?

    init() {
        let screenHeightPercent = UIScreen.main.bounds.size.height / 100

        self.headerHeight = 40 * screenHeightPercent
        self.hourlyForecastHeight = 15 * screenHeightPercent
        self.dailyForecastHeight = 40 * screenHeightPercent
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack {
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(.white)
                        .font(.title2)
                    Text(weatherViewModel.currentWeather?.name ?? "")
                        .foregroundColor(.white)
                        .font(.title2)

                    Spacer()
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.white)
                        .font(.title2)
                }
                .padding(.horizontal)
                .frame(maxHeight: .infinity, alignment: .top)

                if let currentImageURL {
                    WebImage(url: currentImageURL)
                }

            }
            .clipShape(Rectangle())
            .frame(maxWidth: .infinity)
            .frame(height: headerHeight)
            .background {
                Color.darkBlue
                    .ignoresSafeArea()
            }


            ScrollView(.horizontal, showsIndicators: false) {

            }
            .clipShape(Rectangle())
            .frame(maxWidth: .infinity)
            .frame(height: hourlyForecastHeight)
            .background {
                Color.blue
            }


            ScrollView(showsIndicators: false) {
                ForEach(weatherViewModel.forecastWeather?.list ?? [], id: \.id) { item in
                    Text(item.weather.description)
                }
            }
            .clipShape(Rectangle())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onChange(of: weatherViewModel.currentWeather?.weather.first?.icon ?? "") { newValue in
            self.currentImageURL = newValue.imageUrl
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(WeatherViewModel())
    }
}

extension String {
    var imageUrl: URL? {
        return URL(string:  "http://openweathermap.org/img/wn/\(self)@2x.png")
    }
}
