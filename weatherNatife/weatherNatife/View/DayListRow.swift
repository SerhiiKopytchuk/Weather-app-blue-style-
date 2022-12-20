//
//  DayListRow.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 06.12.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct DayListRow: View {
    
    // MARK: - variables
    
    private let day: Forecastday

    @EnvironmentObject private var weatherViewModel: WeatherViewModel
    @Binding var isVertical: Bool
    
    private let maxAndMin: String
    
    // MARK: - computed properties
    
    private var isCurrentDay: Bool {
        return day.id == weatherViewModel.currentDay?.id
    }
    
    // MARK: - init
    init(day: Forecastday, isVertical: Binding<Bool>) {
        self.day = day

        let max = day.day.maxtempC
        let min = day.day.mintempC
        
        self.maxAndMin = "\(max)°/\(min)°"
        self._isVertical = isVertical
    }
    
    // MARK: - body
    
    var body: some View {
        HStack {
            
            Text(day.date.dailyToDate.toDay.uppercased())
                .font(.title2)
                .foregroundColor(isCurrentDay ? .blue : .black)
            
            Spacer()
            
            Text(maxAndMin)
                .font(.title2)
                .foregroundColor(isCurrentDay ? .blue : .black)
            
            Spacer()
            
            WebImage(url: day.day.condition.icon.toImageURL)
            
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.interactiveSpring()) {
                weatherViewModel.currentDay = day
            }
        }
        .padding(.trailing , isVertical ? 0 : 35)
    }
}
