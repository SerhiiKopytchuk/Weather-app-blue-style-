//
//  DayListRow.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 06.12.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct DayListRow: View {

    let day: Forecastday

    @Binding var currentDay: Forecastday?
    @Binding var isVertical: Bool

    let maxAndMin: String

    var isCurrentDay: Bool {
        return day.id == currentDay?.id
    }

    init(day: Forecastday, currentDay: Binding<Forecastday?>, isVertical: Binding<Bool>) {
        self.day = day
        self._currentDay = currentDay

        let max = day.day.maxtempC
        let min = day.day.mintempC

        self.maxAndMin = "\(max)°/\(min)°"
        self._isVertical = isVertical
    }

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
                currentDay = day
            }
        }
        .padding(.trailing , isVertical ? 0 : 35)
    }
}



struct BoundsPreference: PreferenceKey {

    static var defaultValue: [String: Anchor<CGRect>] = [:]

    static func reduce(value: inout [String: Anchor<CGRect>], nextValue: () -> [String: Anchor<CGRect>]) {
        value.merge(nextValue()) {$1}
    }
}
