//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by นายนัชชานนท์ โปษยาอนุวัตร์ on 14/1/2569 BE.
//

import SwiftUI

struct CodeBreakerView: View {
    // MARK: Data Owned by Me
    @State private var game: CodeBreaker = CodeBreaker()
    @State private var selection: Int = 0
    @State private var restarting = false
    @State private var hideMostRecentMarkers = false
    
    // MARK: - body
    var body: some View {
        VStack {
            Button("Restart") {
                withAnimation(.restart) {    // animation แบบ explicit (ทำทันที)
                    restarting = true
                    game.restart()
                } completion: {     // เมื่อทำ animation เสร็จ
                    withAnimation(.restart) {
                        restarting = false
                    }
                }
            }
            
            CodeView(code: game.masterCode) {
                ElapsedTime(
                    startTime: game.startTime,
                    endTime: game.endTime
                )
                .flexibleSystemFont()
                .monospaced()
                .lineLimit(1)
            }
            //                .opacity(game.isOver ? 1 : 0)
            
            ScrollView {
                if !game.isOver {
                    CodeView(code: game.guess, selection: $selection) {
                        guessButton
                    }
                    //                    .animation(nil, value: game.attempts.count)
                    .opacity(restarting ? 0 : 1)
                }
                
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    CodeView(code: game.attempts[index]) {
                        let showMarkers = !hideMostRecentMarkers || index != game.attempts.count - 1
                        
                        if showMarkers {
                            MatchMarkers(matches: game.attempts[index].matches)
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
                .transition(AnyTransition.pegChooser)     // animation แบบ implicit (ทำเมื่อ detect change)
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
    
//    struct GuessButton {
//        static let maximumFontSize: CGFloat = 80
//        static let minimumFontSize: CGFloat = 8
//        static let scaleFactor = minimumFontSize / maximumFontSize
//    }
}
    
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


#Preview {
    CodeBreakerView()
        .padding()
}
    
