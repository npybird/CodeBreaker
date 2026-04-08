//
//  GameChooserView.swift
//  CodeBreaker
//
//  Created by นายนัชชานนท์ โปษยาอนุวัตร์ on 18/3/2569 BE.
//

import SwiftUI

struct GameChooserView: View {
    // MARK: Data Owned by Me
    @State private var sortOption: CodeBreaker.SortOption = .name
    @State private var search: String = ""
    
    // MARK: - Body
    var body: some View {
        NavigationSplitView {
            Picker("Sort By", selection: $sortOption.animation(.default)) {
                ForEach(CodeBreaker.SortOption.allCases, id: \.self) { option in
                    Text("\(option.title)")
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            GameListView(sortBy: sortOption, nameContains: search)
                .navigationTitle("Code Breaker 🧑🏻‍💻")
                .searchable(text: $search)
                .animation(.default, value: search)
        } detail: {
            Text("Choose a game plz 🥺")
        }
    }
}

#Preview(traits: .swiftData) {
    GameChooserView()
}
