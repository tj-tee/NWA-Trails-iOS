//
//  Model.swift
//  NWA Trails for FlowFeed
//
//  Created by TJ on 7/6/23.
//

struct TrailSystem: Codable, Identifiable {
    let id: Int
    let name: String
    let trails: [Trails]
    
    struct Trails: Codable, Identifiable {
        let id: Int
        let name: String
        let difficultyId: String
        let active: Bool
        let updatedAt: String
        let status: Status
        
        struct Status: Codable {
            let date: String
            let status: Int
        }
    }
}

typealias TrailSystemData = [TrailSystem]
