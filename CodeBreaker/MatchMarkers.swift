//
//  MatchMarkers.swift
//  CodeBreaker
//
//  Created by นายนัชชานนท์ โปษยาอนุวัตร์ on 14/1/2569 BE.
//

import SwiftUI

enum Match {
    case nomatch
    case exact
    case inexact
}

struct MatchMarkers: View {
    let matches: [Match]
    
    var body: some View {
        HStack {
            VStack {
                matchMaker(peg: 0)
                matchMaker(peg: 1)
            }
            VStack {
                matchMaker(peg: 2)
                matchMaker(peg: 3)
            }
        }
    }
    
    @ViewBuilder    // ไม่ต้องใส่ return
    func matchMaker(peg: Int) -> some View {
        let exactCount: Int = matches.count { $0 == .exact }        // $0 = ไม่กำหนดชื่อของ parameter ที่ส่งมา
        let foundCount: Int = matches.count { $0 != .nomatch }
        
        Circle()
            .fill(peg < exactCount ? Color.primary : .clear)
            .strokeBorder(peg < foundCount ? Color.primary : .clear, lineWidth: 2)
            .aspectRatio(contentMode: .fit)
    }
    
    func mycount(match: Match) -> Bool {
        if match == .exact {
            return true
        } else {
            return false
        }
    }
}

#Preview {
    MatchMarkers(matches: [.exact, .inexact, .nomatch, .exact])
        .padding()
}
    
