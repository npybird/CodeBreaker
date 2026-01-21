//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by นายนัชชานนท์ โปษยาอนุวัตร์ on 21/1/2569 BE.
//

import SwiftUI

typealias Peg = Color

//let emoji String = "🥵"

struct CodeBreaker {
    var masterCode: Code = Code(kind: .master)
    var guess: Code = Code(kind: .guess, pegs: [Code.missing, Code.missing, Code.missing, Code.missing])
    var attempts: [Code] = []
    
    let pegChoices: [Peg] = [.red, .green, .yellow, .blue]
    
    init() {
        masterCode.randomize(from: pegChoices)
        print(masterCode.pegs)
    }
    
    mutating func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        
        if let indexOfExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
            guess.pegs[index] = pegChoices[(indexOfExistingPegInPegChoices + 1) % pegChoices.count]
        } else {
            guess.pegs[index] = pegChoices.first ?? Code.missing
        }
    }
    
    mutating func attemptGuess() {
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
    }
}

struct Code {
    var kind: Kind
    var pegs: [Peg] = Array(repeating: Code.missing, count: 4)
    
    static let missing: Peg = .clear
    
    enum Kind: Equatable {
        case master
        case guess
        case attempt([Match])
        case unknown
    }
    
    mutating func randomize(from pegChoices: [Peg]) {
        for index in pegChoices.indices {
            pegs[index] = pegChoices.randomElement() ?? Code.missing
        }
    }
    
    var matches: [Match] {
        switch kind {
        case .attempt(let matches): return matches
        default: return []
        }
    }
    
    func match(against otherCode: Code) -> [Match] {
        var results: [Match] = Array(repeating: .nomatch, count: pegs.count)
        var pegsToMatch = otherCode.pegs
        
        for index in pegs.indices.reversed() {
            if pegsToMatch[index] == pegs[index] {
                results[index] = .exact
                pegsToMatch.remove(at: index)
            }
        }
        
        for index in pegs.indices {
            if results[index] != .exact {
                if let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                    results[index] = .inexact
                    pegsToMatch.remove(at: matchIndex)
                }
            }
        }
        
        return results
    }
}
