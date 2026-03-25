//
//  GameChooserView.swift
//  CodeBreaker
//
//  Created by นายนัชชานนท์ โปษยาอนุวัตร์ on 18/3/2569 BE.
//

import SwiftUI

struct GameChooserView: View {
    // MARK: Data Owned by Me
    @State private var games: [CodeBreaker] = []
    
    @State private var gameToEdit: CodeBreaker?
    @State private var showGameEditor = false
    
    // MARK: - Body
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(games, id:\.name) {game in
                    NavigationLink(value: game) {
                        GameSummaryView(game: game)
                    }
                    .contextMenu {
                        editButton(for: game) // editing a game
                        deleteButton(for: game)
                    }
                    .swipeActions(edge: .leading) {
                        editButton(for: game).tint(.accentColor)
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
                addButton
                EditButton() // edit list of game
            }
            .navigationDestination(for: CodeBreaker.self) { game in
                CodeBreakerView(game: game)
            }
        } detail: {
            Text("Please Choose a Game")
        }
        .onAppear {
            games.append(CodeBreaker(name: "Mastermind", pegChoices: [.red, .blue, .green, .yellow]))
            games.append(CodeBreaker(name: "Earth Tones", pegChoices: [.orange, .brown, .black, .yellow, .green]))
            games.append(CodeBreaker(name: "Undersea", pegChoices: [.blue, .indigo, .cyan]))
        }
    }
    
    func editButton(for game: CodeBreaker) -> some View {
        Button("Edit", systemImage: "pencil") {
            gameToEdit = game
            showGameEditor = true
        }
    }
    var addButton: some View {
        Button("Add Game", systemImage: "plus") {
            gameToEdit = CodeBreaker(name: "New Game", pegChoices: [.red, .green, .blue])
            showGameEditor = true
        }
        .sheet(isPresented: $showGameEditor) {
            if let gameToEdit {
                let copyOfGameToEdit = CodeBreaker(name: gameToEdit.name, pegChoices: gameToEdit.pegChoices)
                GameEditorView(game: copyOfGameToEdit) {
                    if let index = games.firstIndex(of: gameToEdit) {
                        games[index] = copyOfGameToEdit
                    } else {
                        games.insert(gameToEdit, at: 0)
                    }
                }
            }
        }
    }
    
    func deleteButton(for game: CodeBreaker) -> some View {
        Button("Delete", systemImage: "minus.circle", role: .destructive) {
            games.removeAll { $0 == game }
        }
    }
}

#Preview {
    GameChooserView()
}
