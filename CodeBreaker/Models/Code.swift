//
//  Code.swift
//  CodeBreaker
//
//  Created by นายนัชชานนท์ โปษยาอนุวัตร์ on 28/1/2569 BE.
//


import Foundation
import SwiftData

@Model class Code {
    var _kind: String = Kind.unknown.description()
    var pegs: [Peg]
    
    var kind: Kind {
        get { return Kind(from: _kind) }
        set { _kind = newValue.description()}
    }
    
    init(kind: Kind, pegs: [Peg] = Array(repeating: Code.missing, count: 4)) {
        self.pegs = pegs
        self.kind = kind
    }
    
    static let missing: Peg = ""
    
    enum Kind: Equatable {
        case master(isHidden: Bool)
        case guess
        case attempt([Match])
        case unknown
    }
    
    func randomize(from pegChoices: [Peg]) {
        for index in pegs.indices {
            pegs[index] = pegChoices.randomElement() ?? Code.missing
        }
        print(pegs)
    }
    
    func reset() {
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

enum Match: String, Equatable {
    case nomatch
    case exact
    case inexact
}

extension Code.Kind {
    func description() -> String {
        switch self {
        case .master(let isHidden):
            return "master:\(isHidden)"
            
        case .guess:
            return "guess"
            
        case .attempt(let matches):
            let values = matches.map { $0.rawValue }.joined(separator: ",")
            return "attempt:\(values)"
            
        case .unknown:
            return "unknown"
        }
    }
    
    init(from string: String) {
        let parts = string.split(separator: ":", maxSplits: 1).map(String.init)
        
        guard let type = parts.first else {
            self = .unknown
            return
        }
        
        switch type {
        case "master":
            if parts.count > 1, let value = Bool(parts[1]) {
                self = .master(isHidden: value)
            } else {
                self = .unknown
            }
            
        case "guess":
            self = .guess
            
        case "attempt":
            if parts.count > 1 {
                let matches = parts[1]
                    .split(separator: ",")
                    .compactMap { Match(rawValue: String($0)) }
                self = .attempt(matches)
            } else {
                self = .attempt([])
            }
            
        case "unknown":
            self = .unknown
            
        default:
            self = .unknown
        }
    }
}
