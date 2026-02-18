//
//  CodeView.swift
//  CodeBreaker
//
//  Created by นายนัชชานนท์ โปษยาอนุวัตร์ on 28/1/2569 BE.
//

import SwiftUI

struct CodeView<AncillaryView>: View where AncillaryView: View {    // AncillaryView implements View
    // MARK: Data In
    let code: Code
    
    // MARK: Data Shared by Me
    @Binding var selection: Int
    
    @ViewBuilder let ancillaryView: () -> AncillaryView
    
    //MARK: Data Owned By Me
    @Namespace private var selectionNameSpace
    
    init(code: Code,
         selection: Binding<Int> = .constant(-1),
         @ViewBuilder ancillaryView: @escaping () -> AncillaryView = { EmptyView() }) {
        self.code = code
        self._selection = selection     // selection ไม่ใช่ตัวแปรของ struct นี้ แต่ถูก shared มา จึงใช้ _selection
        self.ancillaryView = ancillaryView
    }
    
    // MARK: - body
    var body: some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                PegView(peg: code.pegs[index])
                    .padding(Selection.border)
                    .background {
                        Group {
                            if selection == index, code.kind == .guess {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(Selection.color)
                                    .matchedGeometryEffect(id: "selection", in: selectionNameSpace)
                            }
                        }
                        .animation(.selection, value: selection)
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(code.isHidden ? Color.gray : .clear)
                            .transaction {
                                transaction in if code.isHidden {
                                    transaction.animation = nil
                                }
                            }
                    }
                    .onTapGesture {
                        if code.kind == .guess {
                            selection = index
                            
                        }
                    }
            }
            Color.clear.aspectRatio(1, contentMode: .fit)
                .overlay {
                    ancillaryView()
                }
        }
    }
}

// fileprivate ทำให้ใช้ได้เฉพาะในไฟล์นี้เท่านั้น
fileprivate struct Selection {
    static let border: CGFloat = 5
    static let color: Color = .gray(0.85)
}

// เพิ่มคุณสมบัติให้ struct Color
extension Color {
    static func gray(_ brightness: CGFloat) -> Color {
        Color(hue: 148/360, saturation: 0, brightness: brightness)
    }
}

//#Preview {
//    CodeView()
//}
