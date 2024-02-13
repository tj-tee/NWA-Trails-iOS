//
//  TrailSytemDetail.swift
//  NWA Trails for FlowFeed
//
//  Created by TJ on 7/7/23.
//

import SwiftUI

struct TrailSystemDetail: View {
    
    let system: TrailSystem
    @State var isFavorite = false
    @State var isShowingSortSheet = false
    @State var trailSortOption: TrailSortOption? = trailSortOptions.first
    @State var tempTrailSortOption: TrailSortOption? = trailSortOptions.first
    
    var sortedTrails: [TrailSystem.Trails] {
        if let option = trailSortOption {
            return system.trails.sorted(by: option.sortClosure)
        } else {
            return system.trails
        }
    }
    
    var body: some View {
        List{
            ForEach(sortedTrails) { trail in
                HStack {
                    getTrailDifficulty(for: trail)
                    Text(trail.name)
                    Spacer()
                    getTrailStatus(for: trail)
                }
            }
        }
        .navigationTitle(system.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem {
                Button(action: {
                    isShowingSortSheet.toggle()
                }) {
                    Image(systemName: "arrow.up.arrow.down")
                }
            }
        }
        .sheet(isPresented: $isShowingSortSheet, onDismiss: {
            tempTrailSortOption = trailSortOption
        }) {
            SheetView(trailSortOption: $tempTrailSortOption, onSave: {
                self.trailSortOption = self.tempTrailSortOption
                self.isShowingSortSheet = false
            })
            .presentationDetents([.large])
        }
    }
}

struct SheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var trailSortOption: TrailSortOption?
    
    var onSave: () -> Void
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Circle().fill(Color.secondary))
                }}
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Sorting")
                    .font(.title)
                ForEach(trailSortOptions) { option in
                    Button(action: {
                        trailSortOption = option
                    }) {
                        HStack(spacing: 16) {
                            Image(systemName: option.imageName)
                                .font(.title2)
                            VStack(alignment:.leading){
                                Text(option.title)
                                    .foregroundColor(.primary)
                                Text(option.description)
                                    .font(.caption)
                            }
                            Spacer()
                            if option == trailSortOption{
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.regularMaterial)
                    .cornerRadius(10)
                }
            }
            Spacer()
            Button(action: {
                onSave()
            }) {
                Text("Save")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
            .padding(.top)
        }
        .padding()
    }
}

let trailSortOptions: [TrailSortOption] = [
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
        title: "Best Conditions",
        description: "Best trail conditions first",
        sortClosure: { $0.status.status > $1.status.status },
        imageName: "hand.thumbsup"
    ),
    TrailSortOption(
        title: "Worst Condition",
        description: "Worst trail conditions first",
        sortClosure: { $0.status.status < $1.status.status },
        imageName: "hand.thumbsdown"
    )
]

struct TrailSortOption: Identifiable, Equatable {
    static func == (lhs: TrailSortOption, rhs: TrailSortOption) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id = UUID()
    let title: String
    let description: String
    let sortClosure: (TrailSystem.Trails, TrailSystem.Trails) -> Bool
    let imageName: String
}

private func getTrailStatusIcon(for trail: TrailSystem.Trails) -> some View {
    let color: Color
    
    switch trail.status.status {
    case 0:
        color = .red
    case 1:
        color = .orange
    case 2:
        color = .yellow
    case 3:
        color = .green
    default:
        color = .black
    }
    
    return Image(systemName: "bicycle")
        .foregroundColor(color)
}

private func getTrailStatus(for trail: TrailSystem.Trails) -> some View {
    let text: String
    let color: Color
    
    switch trail.status.status {
    case 0:
        text = "Closed"
        color = .red
        
    case 1:
        text = "Rutty"
        color = .orange
        
    case 2:
        text = "Fair"
        color = .yellow
        
    case 3:
        text = "Firm"
        color = .green
        
    default:
        text = "?"
        color = .primary
    }
    
    return HStack{
        Text(text)
            .font(.callout)
        Circle()
            .frame(width: 10, height: 10)
            .foregroundColor(color)
    }
}

private func getTrailDifficulty(for trail: TrailSystem.Trails) -> some View {
    let color: Color
    var icon: String = "questionmark"
    var isDoubleBlack = false
    
    switch trail.difficultyId {
    case "0":
        color = .red
    case "1":
        color = .gray
        icon = "circle.fill"
    case "2":
        color = .green
        icon = "circle.fill"
    case "3":
        color = .blue
        icon = "square.fill"
    case "4":
        color = .black
        icon = "diamond.fill"
    case "5":
        color = .black
        icon = "suit.diamond.fill"
        isDoubleBlack = true
    default:
        color = .pink
        icon = "questionmark"
    }
    
    return GeometryReader { geometry in
        HStack(spacing: 0) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: geometry.size.width / (isDoubleBlack ? 2 : 1), height: geometry.size.height)
            if isDoubleBlack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .frame(width: geometry.size.width / 2, height: geometry.size.height)
            }
        }
    }
    .frame(width: 20, height: 20)
}

struct TrailSystemDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TrailSystemDetail(system: DataModel().trailSystems.first!)
        }
    }
}

struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        SheetView(trailSortOption: .constant(nil), onSave: {})
    }
}
