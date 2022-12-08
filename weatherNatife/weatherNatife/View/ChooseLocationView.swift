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

    // MARK: - variables

    @State private var searchText = ""

    @Namespace private var animation

    @Binding var isOpen: Bool

    @State private var currentTab = Tab.search

    @EnvironmentObject private var weatherViewModel: WeatherViewModel

    private enum Tab: String, CaseIterable {
        case search = "Search"
        case map = "Map"
    }

    // MARK: - computed property

    var width: CGFloat {
        return min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    }

    // MARK: - body
    var body: some View {
        VStack(spacing: 0) {

            customTabBar

            if self.currentTab == Tab.search {
                searchView
                    .transition(.offset(x: currentTab == .search ? -width : width))
            } else {
                MapView(isOpen: $isOpen, weatherViewModel: weatherViewModel)
                    .transition(.offset(x: currentTab == .map ? width : -width))
            }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - ViewBuilders

    @ViewBuilder private var customTabBar: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: (\.self)) { tab in
                Text(tab.rawValue.capitalized)
                    .fontWeight(.semibold)
                    .foregroundColor(tab == currentTab ? .white : .primary)
                    .opacity(tab == currentTab ? 1 : 0.7)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background {
                        if tab == currentTab {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(
                                    Color.blue
                                )
                                .matchedGeometryEffect(id: "TYPE", in: animation)
                        }
                    }
                    .onTapGesture {
                        withAnimation {
                            self.currentTab = tab
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
    }

    @ViewBuilder private var searchView: some View {
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
    }
}


