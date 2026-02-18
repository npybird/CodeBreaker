//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by นายนัชชานนท์ โปษยาอนุวัตร์ on 21/1/2569 BE.
//

import SwiftUI

typealias Peg = Color

struct CodeBreaker {
    var masterCode: Code = Code(kind: .master(isHidden: true))
    var guess: Code = Code(kind: .guess, pegs: [Code.missing, Code.missing, Code.missing, Code.missing])
    var attempts: [Code] = []
    var startTime: Date = .now
    var endTime: Date?
    
    let pegChoices: [Peg] = [.red, .green, .yellow, .blue, .brown]
    
    init() {
        masterCode.randomize(from: pegChoices)
    }
    
    mutating func restart() {
        masterCode.kind = .master(isHidden: true)
        masterCode.randomize(from: pegChoices)
        guess.reset()
        attempts.removeAll()
        startTime = .now
        endTime = nil
    }
    
    var isOver: Bool {
        // ?. คือ ถ้า Array ไม่ใช่ nil จะ unwrapped ให้เอง
        attempts.last?.pegs == masterCode.pegs
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
        guess.reset()
        if isOver {
            masterCode.kind = .master(isHidden: false)
            endTime = .now
        }
    }
    
    mutating func setGuessPeg(_ peg: Peg, at index: Int) {
        guess.pegs[index] = peg
    }
}


