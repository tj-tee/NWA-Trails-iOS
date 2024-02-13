//
//  LoadingScreen.swift
//  NWA Trails for FlowFeed
//
//  Created by TJ on 7/12/23.
//

import SwiftUI

struct LoadingScreen: View {
    @State private var offsetX: CGFloat = -250.0
    @State private var isAnimating = true
    
    var body: some View {
        ZStack {
            Color.primary.edgesIgnoringSafeArea(.all)
            
            Image(systemName: "bicycle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
                .frame(width: 100, height: 100)
                .rotationEffect(.degrees(-30))
                .offset(x: offsetX, y: 0)
                .onAppear {
                    withAnimation(Animation.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                        offsetX = UIScreen.main.bounds.width + 150
                        isAnimating = true
                    }
                }
            
            Rectangle()
                .foregroundColor(.blue)
                .frame(height: 5)
                .offset(y: 45)
        }
    }
}


struct LoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScreen()
    }
}

