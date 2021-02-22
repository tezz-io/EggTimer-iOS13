//
//  ProgressBarView.swift
//  EggTimer
//
//  Created by tezz on 22/02/21.
//  Copyright © 2021 The App Brewery. All rights reserved.
//

import SwiftUI

struct ProgressBarView: View {
    @State var progressValue: Float = 0.0
    @State var timer: String = "05:00"
    @State var width: CGFloat = 150.0
    @State var height: CGFloat = 150.0
    @State var isLightMode: Bool
    
    var body: some View {
        ZStack {
            VStack {
                ProgressBar(progress: self.$progressValue, timer: timer, isLightMode: $isLightMode)
                    .frame(width: width, height: height)
                    .padding(40.0)
                    .background(Color.white.opacity(0.0))
            }
        }
    }
}

struct ProgressBar: View {
    @Binding var progress: Float
    @State var timer: String
    @Binding var isLightMode: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.red)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.red)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)

            Text(timer)
                .font(.title)
                .bold()
                .foregroundColor(isLightMode ? .black : .white)
        }
    }
}
