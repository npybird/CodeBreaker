//
//  PegChoicesChooserView.swift
//  CodeBreaker
//
//  Created by นายนัชชานนท์ โปษยาอนุวัตร์ on 1/4/2569 BE.
//

import SwiftUI

struct PegChoicesChooserView: View {
    // MARK: Data Shared with Me
    @Binding var pegChoices: [Color]
    
    var body: some View {
        List {
            ForEach(pegChoices.indices, id:\.self) { index in
                ColorPicker(
                    selection: $pegChoices[index],
                    supportsOpacity: false
                ) {
                    button("Peg Choice \(index+1)", systemImage: "minus.circle", color: .red) {
                        pegChoices.remove(at: index)
                    }
                }
            }
            button("Add Peg", systemImage: "plus.circle", color: .green) {
                pegChoices.append(.red)
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
                withAnimation {
                    action()
                }
            } label: {
                Image(systemName: systemImage).tint(color)
            }
            Text(title)
        }
    }
}
