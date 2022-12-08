//
//  ChooseLocationView.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 07.12.2022.
//

import SwiftUI
import CoreLocation
import MapKit

struct ChooseLocationView: View {

    @State var searchText = ""

    @Namespace var animation

    @Binding var isOpen: Bool

    @State var tab = "Search"

    @EnvironmentObject var weatherViewModel: WeatherViewModel

    init(isOpen: Binding<Bool>) {
        self._isOpen = isOpen
        self.tab = tab
    }

    var body: some View {
        VStack(spacing: 0) {

            HStack(spacing: 0) {
                ForEach(["Search", "Map"], id: (\.self)) { text in
                    Text(text.capitalized)
                        .fontWeight(.semibold)
                        .foregroundColor(tab == text ? .white : .primary)
                        .opacity(tab == text ? 1 : 0.7)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background {
                            if tab == text {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(
                                        Color.blue
                                    )
                                    .matchedGeometryEffect(id: "TYPE", in: animation)
                            }
                        }
                        .onTapGesture {
                            withAnimation {
                                self.tab = text
                            }
                        }
                }
            }
            .padding(5)
            .padding()
            .background {
                Rectangle()
                    .fill(Color.darkBlue)
                    .ignoresSafeArea()
            }



            if tab == "Search" {
                HStack {
                    TextField("Enter your city", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .font(.title3)
                        .foregroundColor(.black)
                        .padding()
                        .onChange(of: searchText) { newValue in
                            weatherViewModel.getPlacesList(text: newValue)
                        }

                    Image("ic_search")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.trailing)

                }
                .background {
                    Color.darkBlue
                        .ignoresSafeArea()
                }

                List {
                    ForEach(weatherViewModel.locations) { location in
                        Text("\(location.name), \(location.country)")
                            .onTapGesture {
                                weatherViewModel.changeLocation(cityName: location.name)
                                self.isOpen = false
                            }
                    }
                }
                .listStyle(.inset)
            } else {
                MapView(isOpen: $isOpen, weatherViewModel: weatherViewModel)
            }
        }
        .frame(maxWidth: .infinity)
    }
}


