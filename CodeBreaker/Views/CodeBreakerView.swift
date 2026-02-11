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
    
    // MARK: - body
    var body: some View {
        VStack {
            Button("Restart") {
                withAnimation(.easeInOut(duration: 3)) {    // animation แบบ explicit (ทำทันที)
                    restarting = true
                    game.restart()
                } completion: {     // เมื่อทำ animation เสร็จ
                    restarting = false
                }
            }
            
            CodeView(code: game.masterCode)
                .opacity(game.isOver ? 1 : 0)
            
            if !game.isOver {
                CodeView(code: game.guess, selection: $selection) {
                    guessButton
                }
                .animation(nil, value: game.attempts.count)
                .opacity(restarting ? 0 : 1)
            }
                
            ScrollView {
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    CodeView(code: game.attempts[index]) {
                        MatchMarkers(matches: game.attempts[index].matches)
                    }
                    .transition(
                        AnyTransition.asymmetric(
                            insertion: game.isOver ? .opacity : .move(edge: .top),
                            removal: .move(edge: .trailing))
                    )
                }
            }
            
            if !game.isOver {
                PegChooserView(choices: game.pegChoices) { peg in
                    game.setGuessPeg(peg, at: selection)
                    selection = (selection + 1) % game.guess.pegs.count
                }
                .transition(AnyTransition.offset(x: 0, y: 250))     // animation แบบ implicit (ทำเมื่อ detect change)
            }
        }
        .padding()
    }
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation(.easeInOut(duration: 3)) {
                selection = 0
                game.attemptGuess()
            }
        }
        .font(.system(size: GuessButton.maximumFontSize))
        .minimumScaleFactor(GuessButton.scaleFactor)
    }
    
    struct GuessButton {
        static let maximumFontSize: CGFloat = 80
        static let minimumFontSize: CGFloat = 8
        static let scaleFactor = minimumFontSize / maximumFontSize
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
}


#Preview {
    CodeBreakerView()
        .padding()
}
    
