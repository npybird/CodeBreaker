//
//  GameListView.swift
//  CodeBreaker
//
//  Created by นายนัชชานนท์ โปษยาอนุวัตร์ on 1/4/2569 BE.
//

import SwiftUI
import SwiftData

struct GameListView: View {
    // MARK: Data In
    @Environment(\.modelContext) var modelContext
    
    // MARK: Data Owned by Me
//    @State private var games: [CodeBreaker] = []
    @State private var showGameEditor = false
    @State private var gameToEdit: CodeBreaker?
    
    @Query(sort: \CodeBreaker.name, order: .forward) private var games: [CodeBreaker]
    
    init(sortBy: CodeBreaker.SortOption = .name, nameContains search: String = "") {
        let lowercaseSearch = search.lowercased()
        let capitalizeSearch = search.capitalized
        
        let predicate = #Predicate<CodeBreaker> { game in
            return search.isEmpty || game.name.contains(lowercaseSearch) || game.name.contains(capitalizeSearch)
        }
        
        switch sortBy {
        case .name: _games = Query(filter: predicate, sort: \CodeBreaker.name, order: .forward)
        case .recent: _games = Query(filter: predicate, sort: \CodeBreaker.lastAttemptDate, order: .reverse)
        }
    }
    
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
                for offset in offsets {
                    modelContext.delete(games[offset])
                }
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
            modelContext.insert(CodeBreaker(name: "Mastermind", pegChoices: [.red, .blue, .green, .yellow]))
            modelContext.insert(CodeBreaker(name: "Earth Tones", pegChoices: [.orange, .brown, .black, .yellow, .green]))
            modelContext.insert(CodeBreaker(name: "Undersea", pegChoices: [.blue, .indigo, .cyan]))
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
                if games.contains(gameToEdit) {
                    modelContext.delete(gameToEdit)
                }
                modelContext.insert(copyOfGameToEdit)
            }
        }
    }
    
    func deleteButton(for game: CodeBreaker) -> some View {
        Button("Delete", systemImage: "minus.circle", role: .destructive) {
            withAnimation {
                modelContext.delete(game)
            }
        }
    }
}

#Preview {
    GameListView()
}
