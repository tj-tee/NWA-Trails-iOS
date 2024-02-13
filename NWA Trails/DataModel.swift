//
//  DataModel.swift
//  NWA Trails for FlowFeed
//
//  Created by TJ on 7/6/23.
//

import Foundation

class DataModel: ObservableObject {
    
    // Bool for using local mock-data.json or to fetch data
    @Published var isTesting = true
    
    @Published var trailSystems: [TrailSystem] = []
    @Published var trailSortOptions: [TrailSortOption] = [
        TrailSortOption(
            title: "Name ASC",
            description: "Sort Name A to Z",
            sortClosure: { $0.name < $1.name },
            imageName: "arrow.up"
        ),
        TrailSortOption(
            title: "Name DESC",
            description: "Sort Name Z to A",
            sortClosure: { $0.name > $1.name },
            imageName: "arrow.down"
        ),
        TrailSortOption(
            title: "Difficulty ASC",
            description: "Sort difficulty easiest first",
            sortClosure: { $0.difficultyId < $1.difficultyId },
            imageName: "circle"
        ),
        TrailSortOption(
            title: "Difficulty DESC",
            description: "Sort difficulty most difficult first",
            sortClosure: { $0.difficultyId > $1.difficultyId },
            imageName: "diamond"
        ),
        TrailSortOption(
            title: "Condition ASC",
            description: "Best trail conditions first",
            sortClosure: { $0.status.status < $1.status.status },
            imageName: "hand.thumbsdown"
        ),
        TrailSortOption(
            title: "Condition DESC",
            description: "Worst trail conditions first",
            sortClosure: { $0.status.status > $1.status.status },
            imageName: "hand.thumbsup"
        )
    ]
    
    @Published var trailSortDefaultOption: TrailSortOption?
    
    init() {
        trailSortDefaultOption = trailSortOptions.first ?? nil
        if isTesting{
            if let data = DataModel.readLocalFile("mock-data")
            {
                let rawTrailData = DataModel.loadJson(data)
                trailSystems = rawTrailData
            }
        }
    }
    
    static func readLocalFile(_ filename: String) -> Data? {
        guard let file = Bundle.main.path(forResource: filename, ofType: "json")
        else {
            fatalError("Unable to locate file \"\(filename)\" in main bundle.")
        }
        
        do {
            return try String(contentsOfFile: file).data(using: .utf8)
        } catch {
            fatalError("Unable to load \"\(filename)\" from main bundle:\n\(error)")
        }
    }
    
    static func loadJson(_ data: Data) -> TrailSystemData {
        do {
            return try JSONDecoder().decode(TrailSystemData.self, from: data)
        } catch {
            fatalError("Unable to decode  \"\(data)\" as \(TrailSystemData.self):\n\(error)")
        }
    }
    
    enum FetchError: Error {
        case badRequest
        case badJSON
    }
    
    func fetchData() async
    throws  {
        guard let plistPath = Bundle.main.path(forResource: "Private", ofType: "plist") else {
            fatalError("Plist file not found")
        }
        guard let plistData = NSDictionary(contentsOfFile: plistPath) else {
            fatalError("Unable to read plist file")
        }
        
        guard let urlString = plistData["url"] as? String,
              let apiKey = plistData["key"] as? String,
              let url = URL(string: urlString) else {
            fatalError("Invalid URL or API key in plist file")
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw FetchError.badRequest
        }
        
        Task { @MainActor in
            trailSystems = try JSONDecoder().decode(TrailSystemData.self, from: data)
            print("data fetched")
        }
    }
}
