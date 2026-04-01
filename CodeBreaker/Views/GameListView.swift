//
//  GameListView.swift
//  CodeBreaker
//
//  Created by นายนัชชานนท์ โปษยาอนุวัตร์ on 1/4/2569 BE.
//

import SwiftUI

struct GameListView: View {
    // MARK: Data Owned by Me
    @State private var games: [CodeBreaker] = []
    @State private var showGameEditor = false
    @State private var gameToEdit: CodeBreaker?
    
    var body: some View {
        List {
            ForEach(games) {game in
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
        .onAppear {
            addSampleGames()
        }
    }
    
    func addSampleGames() {
        if games.isEmpty {
            games.append(CodeBreaker(name: "Mastermind", pegChoices: [.red, .blue, .green, .yellow]))
            games.append(CodeBreaker(name: "Earth Tones", pegChoices: [.orange, .brown, .black, .yellow, .green]))
            games.append(CodeBreaker(name: "Undersea", pegChoices: [.blue, .indigo, .cyan]))
        }
    }
    
    func editButton(for game: CodeBreaker) -> some View {
        Button("Edit", systemImage: "pencil") {
            gameToEdit = game
        }
    }
    
    var addButton: some View {
        Button("Add Game", systemImage: "plus") {
            gameToEdit = CodeBreaker(name: "New Game", pegChoices: [.red, .green, .blue])
        }
        .onChange(of: gameToEdit) {
            showGameEditor = gameToEdit != nil
        }
        .sheet(isPresented: $showGameEditor, onDismiss: {
            gameToEdit = nil
        }) {
            gameEditor
        }
    }
    
    @ViewBuilder // มี if-else เลยต้องใส่
    var gameEditor: some View {
        if let gameToEdit {
            let copyOfGameToEdit = CodeBreaker(name: gameToEdit.name, pegChoices: gameToEdit.pegChoices)
            GameEditorView(game: copyOfGameToEdit) {
                if let index = games.firstIndex(of: gameToEdit) {
                    games[index] = copyOfGameToEdit
                } else {
                    games.insert(copyOfGameToEdit, at: 0)
                }
            }
        }
    }
    
    func deleteButton(for game: CodeBreaker) -> some View {
        Button("Delete", systemImage: "minus.circle", role: .destructive) {
            withAnimation {
                games.removeAll { $0 == game }
            }
        }
    }
}

#Preview {
    GameListView()
}
