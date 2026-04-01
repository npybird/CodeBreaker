//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by นายนัชชานนท์ โปษยาอนุวัตร์ on 14/1/2569 BE.
//

import SwiftUI

struct CodeBreakerView: View {
    // MARK: Data Shared with Me
    let game: CodeBreaker
    
    // MARK: Data Owned by Me
    @State private var selection: Int = 0
    @State private var restarting = false
    @State private var hideMostRecentMarkers = false
    
    // MARK: - body
    var body: some View {
        VStack {
            CodeView(code: game.masterCode)
            ScrollView {
                if !game.isOver {
                    CodeView(code: game.guess, selection: $selection) {
                        guessButton
                    }
                    //                    .animation(nil, value: game.attempts.count)
                    .opacity(restarting ? 0 : 1)
                }
                
                ForEach(game.attempts, id: \.pegs) { attempt in
                    CodeView(code: attempt) {
                        let showMarkers = !hideMostRecentMarkers || attempt.pegs != game.attempts.first?.pegs
                        
                        if showMarkers {
                            MatchMarkers(matches: attempt.matches)
                        }
                    }
                    .transition(.attempt(game.isOver))
                }
            }
            
            if !game.isOver {
                PegChooserView(choices: game.pegChoices) { peg in
                    game.setGuessPeg(peg, at: selection)
                    selection = (selection + 1) % game.guess.pegs.count
                }
                .frame(maxHeight: 80)
                .transition(AnyTransition.pegChooser)     // animation แบบ implicit (ทำเมื่อ detect change)
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Restart", systemImage: "arrow.circlepath") {    // ใส่ icon ไปกับปุ่ม
                    withAnimation(.restart) {    // animation แบบ explicit (ทำทันที)
                        restarting = true
                        game.restart()
                    } completion: {     // เมื่อทำ animation เสร็จ
                        withAnimation(.restart) {
                            restarting = false
                        }
                    }
                }
            }
            ToolbarItem(placement: .automatic) {
                ElapsedTime(
                    startTime: game.startTime,
                    endTime: game.endTime
                )
                .flexibleSystemFont()
                .monospaced()
                .lineLimit(1)
            }
        }
        .padding()
    }
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation(.guess) {
                selection = 0
                game.attemptGuess()
                hideMostRecentMarkers = true
            } completion: {
                withAnimation(.guess) {
                    hideMostRecentMarkers = false
                }
            }
        }
        .flexibleSystemFont()
    }
}

//    struct GuessButton {
//        static let maximumFontSize: CGFloat = 80
//        static let minimumFontSize: CGFloat = 8
//        static let scaleFactor = minimumFontSize / maximumFontSize
//    }
    
//    func view(for code: Code) -> some View {
//        return HStack {
//            // $selection เพราะใน CodeView ใช้เป็น Binding
//            CodeView(code: code, selection: $selection)
//            
//            MatchMarkers(matches: code.matches)
//                .overlay {
//                    if code.kind == .guess {
//                        guessButton
//                    }
//                }
//        }
//    }

extension CodeBreaker {
    convenience init(name: String, pegChoices: [Color]) {
        self.init(name: name, pegChoices: pegChoices.map(\.hex))
    }
    
    var pegColorChoices: [Color] {
        get { pegChoices.map { Color(hex: $0) } }
        set { pegChoices = newValue.map(\.hex) }
    }
}

#Preview(traits: .swiftData) {
    @Previewable @State var game = CodeBreaker(name: "Preview", pegChoices: [.blue, .red, .green, .orange])
        
    NavigationStack {
        CodeBreakerView(game: game)
            .padding()
    }
}
    
