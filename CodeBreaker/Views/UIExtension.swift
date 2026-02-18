//
//  UIExtension.swift
//  CodeBreaker
//
//  Created by นายนัชชานนท์ โปษยาอนุวัตร์ on 18/2/2569 BE.
//

import SwiftUI

extension Animation {
    static let codeBreaker = Animation.spring.speed(0.75)
    
    static let restart = Animation.codeBreaker
    static let guess = Animation.codeBreaker
    static let selection = Animation.codeBreaker
}

extension AnyTransition {
    static func attempt(_ isOver: Bool) -> AnyTransition {
        AnyTransition.asymmetric(
            insertion: isOver ? .opacity : .move(edge: .top),   // เมื่อทายถูกจะค่อยๆโผล่มา แต่ถ้ายังไม่จบ จะเคลื่อนจากบนลงล่าง
            removal: .move(edge: .trailing)     // เมื่อเริ่มใหม่ จะเลื่อนออกไปด้านขวา
        )
    }
    
    static let pegChooser = AnyTransition.offset(x: 0, y: 250)
}

extension View {
    func flexibleSystemFont(minumum: CGFloat = 8, maximum: CGFloat = 80) -> some View {
        self
            .font(.system(size: maximum))
            .minimumScaleFactor(minumum / maximum)
    }
}
