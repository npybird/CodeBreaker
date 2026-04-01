//
//  PegView.swift
//  CodeBreaker
//
//  Created by นายนัชชานนท์ โปษยาอนุวัตร์ on 28/1/2569 BE.
//

import SwiftUI

struct PegView: View {
    // MARK: Data In
    let peg: Peg
    
    // MARK: - body
    var body: some View {
        let pegShape = Circle() // RoundedRectangle(cornerRadius: 10)
        
        pegShape
//               .overlay {
//                   if peg == Code.missing {
//                        pegShape
//                            .strokeBorder(.gray)
//                    }
//                }
                .contentShape(pegShape)
                .aspectRatio(1, contentMode: .fit)
                .foregroundStyle(Color(hex: peg))
    }
}

#Preview {
    PegView(peg: Color.red.hex)
        .padding()
}
