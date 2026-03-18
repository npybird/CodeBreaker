//
//  PegChooserView.swift
//  CodeBreaker
//
//  Created by นายนัชชานนท์ โปษยาอนุวัตร์ on 28/1/2569 BE.
//

import SwiftUI

struct PegChooserView: View {
    // MARK: Data In
    let choices: [Peg]
    
    // MARK: Data Out Function
    var onChoose: ((Peg) -> Void)?
    
    // MARK: - body
    var body: some View {
        HStack {
            ForEach(choices, id: \.self) { peg in
                PegView(peg: peg)
                    .onTapGesture {
                        onChoose?(peg)
                    }
            }
        }
    }
}
