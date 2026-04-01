//
//  Color+String.swift
//  CodeBreaker
//
//  Created by นายนัชชานนท์ โปษยาอนุวัตร์ on 1/4/2569 BE.
//

import SwiftUI
import UIKit

extension Color {
    var hex: String {
        let uiColor = UIColor(self)
        let fallback: String = "#00000000"
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return fallback
        }
        
        let red = Int(r * 255)
        let green = Int(g * 255)
        let blue = Int(b * 255)
        let alpha = Int(a * 255)
        
        return String(format: "#%02X%02X%02X%02X", red, green, blue, alpha)
    }
    
    init(hex: String) {
            var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if hex.hasPrefix("#") {
                hex.removeFirst()
            }
            
            // Fallback color
            let fallback = Color.clear
            
            guard hex.count == 8,
                  let value = UInt64(hex, radix: 16) else {
                self = fallback
                return
            }
            
            let r = Double((value & 0xFF000000) >> 24) / 255.0
            let g = Double((value & 0x00FF0000) >> 16) / 255.0
            let b = Double((value & 0x0000FF00) >> 8) / 255.0
            let a = Double(value & 0x000000FF) / 255.0
            
            self = Color(.sRGB, red: r, green: g, blue: b, opacity: a)
        }
}
