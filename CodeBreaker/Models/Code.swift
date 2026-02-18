//
//  Code.swift
//  CodeBreaker
//
//  Created by นายนัชชานนท์ โปษยาอนุวัตร์ on 28/1/2569 BE.
//


import Foundation

struct Code {
    var kind: Kind
    var pegs: [Peg] = Array(repeating: Code.missing, count: 4)
    
    static let missing: Peg = .clear
    
    enum Kind: Equatable {
        case master(isHidden: Bool)
        case guess
        case attempt([Match])
        case unknown
    }
    
    mutating func randomize(from pegChoices: [Peg]) {
        for index in pegs.indices {
            pegs[index] = pegChoices.randomElement() ?? Code.missing
        }
        print(pegs)
    }
    
    mutating func reset() {
        pegs = Array(repeating: Code.missing, count: 4)
    }
    
    var isHidden: Bool {
        switch kind {
        case .master(let isHidden): return isHidden
        default: return false
        }
    }
    
    var matches: [Match] {
        switch kind {
        case .attempt(let matches): return matches
        default: return []
        }
    }
    
    func match(against otherCode: Code) -> [Match] {
//        var results: [Match] = Array(repeating: .nomatch, count: pegs.count)
        var pegsToMatch = otherCode.pegs
        
        let backwardsExactMatches = pegs.indices.reversed().map { index in
            if pegsToMatch[index] == pegs[index] {
                pegsToMatch.remove(at: index)
                return Match.exact
            } else {
                return .nomatch
            }
        }
        
        let exactMatches = Array(backwardsExactMatches.reversed())
        return pegs.indices.map { index in
            if exactMatches[index] != .exact, let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                pegsToMatch.remove(at: matchIndex)
                return .inexact
            } else {
                return exactMatches[index]
            }
        }
        
//        for index in pegs.indices.reversed() {
//            if pegsToMatch[index] == pegs[index] {
//                results[index] = .exact
//                pegsToMatch.remove(at: index)
//            }
//        }
        
//        for index in pegs.indices {
//            if results[index] != .exact {
//                if let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
//                    results[index] = .inexact
//                    pegsToMatch.remove(at: matchIndex)
//                }
//            }
//        }
        
//        return results
    }
}
