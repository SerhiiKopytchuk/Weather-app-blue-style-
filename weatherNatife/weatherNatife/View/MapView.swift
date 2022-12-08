//
//  mapView.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 07.12.2022.
//

import MapKit
import SwiftUI
struct MapView: View {

    @Binding var isOpen: Bool
    @State private var locations: [Mark] = []
    @ObservedObject var weatherViewModel: WeatherViewModel

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 25.7617,
            longitude: 80.1918
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 3,
            longitudeDelta: 3
        )
    )

    init(isOpen: Binding<Bool>, locations: [Mark] = [], weatherViewModel: WeatherViewModel) {
        self._isOpen = isOpen
        self.locations = locations
        self.weatherViewModel = weatherViewModel
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: weatherViewModel.lastSavedLocation?.latitude ?? 25.7617,
                longitude: weatherViewModel.lastSavedLocation?.longitude ?? 80.1918
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 3,
                longitudeDelta: 3
            )
        )
    }

    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: locations) { location in
                MapAnnotation(
                    coordinate: location.coordinate,
                    anchorPoint: CGPoint(x: 0.5, y: 0.7)
                ) {}
            }
            Image(systemName: "mappin")
                .font(.title)
                .foregroundColor(.red)
                .frame(width: 25, height: 25)
                .offset(y: -13)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        weatherViewModel.changeLocation(location: region.center)
                        isOpen = false

                    }) {
                        Image(systemName: "plus")
                    }
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding(20)
                }
            }
        }
        .ignoresSafeArea()
        .onAppear{
            if let lastMark = weatherViewModel.lastMark {
                self.region =  MKCoordinateRegion(
                    center: lastMark.coordinate,
                    span: MKCoordinateSpan(
                        latitudeDelta: 3,
                        longitudeDelta: 3
                    )
                )
            } else {
                self.region =  MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: weatherViewModel.lastSavedLocation?.latitude ?? 25.7617,
                        longitude: weatherViewModel.lastSavedLocation?.longitude ?? 80.198
                    ),
                    span: MKCoordinateSpan(
                        latitudeDelta: 3,
                        longitudeDelta: 3
                    )
                )
            }
        }
    }
}
struct Mark: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    var show = false
}
