//
//  TrailSystemRow.swift
//  NWA Trails for FlowFeed
//
//  Created by TJ on 7/6/23.
//

import SwiftUI

struct TrailSystemRow: View {
    
    let trailSystem: TrailSystem
    
    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 0) {
                
                Text(trailSystem.name)
                    .font(.title2)
                
                Text(String(trailSystem.trails.count) + " Trails")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 10)
                
                HStack(spacing: 30){
                    // Don't love using color to denote trail conditions, need to rework.
                    Text(String(trailSystem.trails.filter { $0.status.status == 3 }.count))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                    
                    Text(String(trailSystem.trails.filter { $0.status.status == 2 }.count))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.orange)
                    
                    Text(String(trailSystem.trails.filter { $0.status.status == 1 }.count))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.yellow)
                    
                    Text(String(trailSystem.trails.filter { $0.status.status == 0 }.count))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.red)
                    
                    Spacer()
                    
                }
            }
        }
    }
}

struct TrailSystemRow_Previews: PreviewProvider {
    static var previews: some View {
        TrailSystemRow(trailSystem: DataModel().trailSystems.first!)
    }
}
