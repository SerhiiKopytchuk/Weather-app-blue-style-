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

    let headerHeight: CGFloat
    let hourlyForecastHeight: CGFloat
    let dailyForecastHeight: CGFloat

    let imageWidth: CGFloat

    @State var currentImageURL: URL?

    init() {
        let screenHeightPercent = UIScreen.main.bounds.size.height / 100
        self.imageWidth = UIScreen.main.bounds.size.width / 2


        self.headerHeight = 30 * screenHeightPercent
        self.hourlyForecastHeight = 15 * screenHeightPercent
        self.dailyForecastHeight = 40 * screenHeightPercent
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack {
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

                Text(weatherViewModel.weather?.location.localtime.toDate.toDateTime ?? "")
                    .font(.callout)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)

                HStack {

                    WebImage(url: self.weatherViewModel.weather?.current.condition.icon.toImageURL)
                            .resizable()
                            .frame(width: imageWidth, height: imageWidth, alignment: .leading)


                    VStack {
                        HStack {
                            Image("ic_temp")
                                .font(.title3)
                                .foregroundColor(.white)

                            Text(weatherViewModel.maxAndMin)
                                .font(.title3)
                                .foregroundColor(.white)
                                .bold()

                            Spacer()
                        }

                        HStack {
                            Image("ic_humidity")
                                .font(.title3)
                                .foregroundColor(.white)

                            Text("\(weatherViewModel.weather?.current.humidity ?? 0)%")
                                .font(.title3)
                                .foregroundColor(.white)
                                .bold()

                            Spacer()
                        }

                        HStack {
                            Image("ic_wind")
                                .font(.title3)
                                .foregroundColor(.white)

                            Text("\(weatherViewModel.weather?.current.windKph ?? 0)Kp/h")
                                .font(.title3)
                                .foregroundColor(.white)
                                .bold()

                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
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
                HStack {
                    ForEach(weatherViewModel.weather?.forecast.forecastday.first?.hour ?? [], id: \.id) { hour in
                        if Date().sameDayAs(hour.time) && hour.time.toDate > Date() {
                            HourListRow(hourForecast: hour)
                                .padding(.horizontal, 15)
                        }
                    }
                }
            }
            .clipShape(Rectangle())
            .frame(maxWidth: .infinity)
            .frame(height: hourlyForecastHeight)
            .background {
                Color.blue
            }


            ScrollView(showsIndicators: false) {
                VStack {
                    ForEach(  weatherViewModel.weather?.forecast.forecastday ?? [], id: \.id) { day in

                    }
                }
            }
            .clipShape(Rectangle())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    var toDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.date(from: self) ?? Date()
    }

}

extension Date {
    var toDateTime: String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "E, d MMM"
        return dateFormater.string(from: self)
    }

    var toHour: String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "HH"
        return dateFormater.string(from: self)
    }


    var toDay: String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "E"
        return dateFormater.string(from: self)

    }

    func sameDayAs(_ timeStr: String) -> Bool {
         return Calendar.current.isDate(self, equalTo: timeStr.toDate, toGranularity: .day)
    }
}

extension String {
    var toImageURL: URL? {
        return URL(string: "https:\(self)")
    }
}
