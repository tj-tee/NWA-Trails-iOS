//
//  TrailSystemListView.swift
//  NWA Trails for FlowFeed
//
//  Created by TJ on 7/6/23.
//

import SwiftUI

struct TrailSystemListView: View {
    @EnvironmentObject var dataModel: DataModel
    @State private var isLoading = true
    @State private var hasError = false
    
    var body: some View {
        Group {
            if hasError {
                Text("An error occurred")
                    .font(.title)
            } else {
                actualContent
            }
        }
        .onAppear {
            loadData()
        }
    }
    
    var actualContent: some View {
        VStack {
            // Status datetime is the same for every trail in every trail system... 🤷🏻‍♂️
            List {
                ForEach(dataModel.trailSystems) { sys in
                    NavigationLink {
                        TrailSystemDetail(system: sys)
                    } label: {
                        TrailSystemRow(trailSystem: sys)
                    }
                }
            }
            .navigationTitle("NWA Trails")
            .refreshable {
                loadData()
            }
            Text("Updated \(getMinutesSinceFirstStatusUpdate(for: dataModel.trailSystems.first)) minutes ago")
        }
    }
    
    func loadData() {
        isLoading = true
        hasError = false
        
        if !dataModel.isTesting {
            Task {
                do {
                    try await dataModel.fetchData()
                    isLoading = false
                } catch {
                    hasError = true
                    isLoading = false
                }
            }
        } else {
            isLoading = false
        }
    }
    
}

func getMinutesSinceFirstStatusUpdate(for trailSystem: TrailSystem?) -> Int {
    guard let trailSystem = trailSystem else {
        return 0
    }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
    guard let firstTrail = trailSystem.trails.first,
          let firstTrailStatusDate = dateFormatter.date(from: firstTrail.status.date) else {
        return 0
    }
    
    let minutesAgo = Calendar.current.dateComponents([.minute], from: firstTrailStatusDate, to: Date()).minute
    return minutesAgo ?? 0
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TrailSystemListView()
                .environmentObject(DataModel())
        }
    }
}
