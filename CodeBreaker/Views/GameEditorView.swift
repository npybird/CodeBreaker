//
//  GameEditorView.swift
//  CodeBreaker
//
//  Created by นายนัชชานนท์ โปษยาอนุวัตร์ on 25/3/2569 BE.
//

import SwiftUI

struct GameEditorView: View {
    // MARK: Data (Function) In
    @Environment(\.dismiss) var dismiss
    
    // MARK: Data Owned by Me
    @Bindable var game: CodeBreaker
    @State var showInvalidGameAlert = false
    
    // MARK: Action Function
    let onChoose: () -> Void

    // MARK: - body
    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Name", text: $game.name)
                }
                Section("Pegs") {
                    List {
                        ForEach(game.pegChoices.indices, id:\.self) { index in
                            ColorPicker(
                                selection: $game.pegChoices[index],
                                supportsOpacity: false
                            ) {
                                button("Peg Choice \(index+1)", systemImage: "minus.circle", color: .red) {
                                    game.pegChoices.remove(at: index)
                                }
                            }
                        }
                        button("Add Peg", systemImage: "plus.circle", color: .green) {
                            game.pegChoices.append(.red)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        if game.isValid {
                            onChoose()
                            dismiss()
                        } else {
                            showInvalidGameAlert = true
                        }
                    }
                    .alert("Invalid Game", isPresented: $showInvalidGameAlert) {
                        
                    } message: {
                        Text("A game must have a name and more than one unique peg.")
                    }
                }
            }
        }
    }
    
    func button(
        _ title: String,
        systemImage: String,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {
        HStack {
            Button {
                action()
            } label: {
                Image(systemName: systemImage).tint(color)
            }
            Text(title)
        }
    }
}

#Preview {
    @Previewable var game = CodeBreaker(name: "Preview", pegChoices: [.red, .blue])
    GameEditorView(game: game) {
        print("game name changed to \(game.name)")
        print("game pegs changed to \(game.pegChoices)")
    }
}
