//
//  NWATrailsApp.swift
//  NWA Trails for FlowFeed
//
//  Created by TJ on 7/6/23.
//

import SwiftUI

@main
struct NWATrailsApp: App {
    @StateObject var dataModel = DataModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                TrailSystemListView()
            }
            .environmentObject(dataModel)
        }
    }
}
