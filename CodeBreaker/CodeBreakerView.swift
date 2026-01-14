//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by นายนัชชานนท์ โปษยาอนุวัตร์ on 14/1/2569 BE.
//

import SwiftUI

struct CodeBreakerView: View {
    var body: some View {
        VStack {
            pegs(colors: [.red, .black, .green, .yellow])
            pegs(colors: [.accentColor, .green, .green, .purple])
            pegs(colors: [.brown, .cyan, .yellow, .pink])
            pegs(colors: [.yellow, .orange, .purple, .blue])
        }
        .padding()
    }
    
    func pegs(colors: [Color]) -> some View {
        return HStack {
            ForEach(colors.indices, id: \.self) { index in
                RoundedRectangle(cornerRadius: 20)
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundStyle(colors[index])
            }
            
            MatchMarkers(matches: [.exact, .inexact, .nomatch, .exact])
        }
    }
}

enum Match {
    case nomatch
    case exact
    case inexact
}


#Preview {
    CodeBreakerView()
        .padding()
}
    
