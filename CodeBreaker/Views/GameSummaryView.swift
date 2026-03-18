//
//  GameSummaryView.swift
//  CodeBreaker
//
//  Created by นายนัชชานนท์ โปษยาอนุวัตร์ on 18/3/2569 BE.
//

import SwiftUI

struct GameSummaryView: View {
    // MARK: Data Owned by Me
    let game: CodeBreaker
    
    // MARK: - body
    var body: some View {
        VStack(alignment: .leading) {
            Text(game.name).font(.title)
            PegChooserView(choices: game.pegChoices)
                .frame(maxHeight: 60)
            // ^[...](inflect: true) คือวิธีที่ทำให้มันเติม s ให้เองเมื่อเป็น plural ของ Swift
            Text("^[\(game.attempts.count) attempt](inflect: true)")
        }
    }
}

#Preview {
    List {
        GameSummaryView(game: CodeBreaker(name: "Preview", pegChoices: [.red, .cyan, .yellow]))
    }
    
    List {
        GameSummaryView(game: CodeBreaker(name: "Preview", pegChoices: [.red, .cyan, .yellow]))
    }
    .listStyle(.plain)
}
