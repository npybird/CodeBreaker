//
//  GameChooserView.swift
//  CodeBreaker
//
//  Created by นายนัชชานนท์ โปษยาอนุวัตร์ on 18/3/2569 BE.
//

import SwiftUI

struct GameChooserView: View {
    @State private var games: [CodeBreaker] = []
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(games, id: \.name) { game in
                    NavigationLink(value: game) {
                        GameSummaryView(game: game)
                    }
                    NavigationLink(value: game.masterCode.pegs) {
                        Text("Cheat 🤫")
                    }
                }
                .onDelete { offsets in
                    games.remove(atOffsets: offsets)
                }
                .onMove { offsets, destination in
                    games.move(fromOffsets: offsets, toOffset: destination)
                }
            }
            .listStyle(.plain)
            .toolbar {
                EditButton()
            }
            .navigationDestination(for: CodeBreaker.self) { game in
                CodeBreakerView(game: game)
            }
            .navigationDestination(for: [Peg].self) { pegs in
                PegChooserView(choices: pegs)
            }
        }
        .onAppear {
            games.append(CodeBreaker(name: "Mastermind", pegChoices: [.red, .blue, .green, .yellow]))
            games.append(CodeBreaker(name: "Earth Tones", pegChoices: [.orange, .brown, .black, .yellow, .green]))
            games.append(CodeBreaker(name: "Undersea", pegChoices: [.blue, .indigo, .cyan]))
        }
    }
}

#Preview {
    GameChooserView()
}
