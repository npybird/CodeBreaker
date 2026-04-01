//
//  GameChooserView.swift
//  CodeBreaker
//
//  Created by นายนัชชานนท์ โปษยาอนุวัตร์ on 18/3/2569 BE.
//

import SwiftUI

struct GameChooserView: View {    
    // MARK: - Body
    var body: some View {
        NavigationSplitView {
            GameListView()
                .navigationTitle("Code Breaker 🧑🏻‍💻")
        } detail: {
            Text("Choose a game plz 🥺")
        }
    }
}

#Preview(traits: .swiftData) {
    GameChooserView()
}
