//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by นายนัชชานนท์ โปษยาอนุวัตร์ on 14/1/2569 BE.
//

import SwiftUI

struct CodeBreakerView: View {
    @State var game: CodeBreaker = CodeBreaker()
    
    var body: some View {
        VStack {
            view(for: game.masterCode)
                .opacity(0)
            view(for: game.guess)
            ScrollView {
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view(for: game.attempts[index])
                }
            }
        }
        .padding()
    }
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation {
                game.attemptGuess()
            }
        }
        .font(.system(size: 80))
        .minimumScaleFactor(0.1)
    }
    
    func view(for code: Code) -> some View {
        return HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                RoundedRectangle(cornerRadius: 10)
                    .overlay {
                        if code.pegs[index] == Code.missing {
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(.gray)
                        } else {
                            Text("")
                        }
                    }
                    .contentShape(RoundedRectangle(cornerRadius: 10))
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundStyle(code.pegs[index])
                    .onTapGesture {
                        if code.kind == .guess {
                            game.changeGuessPeg(at: index)
                        }
                    }
            }
            
            MatchMarkers(matches: code.matches)
                .overlay {
                    if code.kind == .guess {
                        guessButton
                    }
                }
        }
    }
}


#Preview {
    CodeBreakerView()
        .padding()
}
    
