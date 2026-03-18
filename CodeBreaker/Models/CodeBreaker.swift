//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by นายนัชชานนท์ โปษยาอนุวัตร์ on 21/1/2569 BE.
//

import SwiftUI

typealias Peg = Color

// class จะเป็น reference เวลาเรียกใช้
// struct จะเป็น copy object เวลาเรียกใช้
@Observable class CodeBreaker {
    var name: String
    var masterCode: Code = Code(kind: .master(isHidden: true))
    var guess: Code = Code(kind: .guess, pegs: [Code.missing, Code.missing, Code.missing, Code.missing])
    var attempts: [Code] = []
    var startTime: Date = .now
    var endTime: Date?
    
    let pegChoices: [Peg]
    
    init(name: String = "Code Breaker", pegChoices: [Peg] = [.red, .green, .yellow, .blue, .brown]) {
        self.name = name
        self.pegChoices = pegChoices
        
        masterCode.randomize(from: pegChoices)
    }
    
    func restart() {
        masterCode.kind = .master(isHidden: true)
        masterCode.randomize(from: pegChoices)
        guess.reset()
        attempts.removeAll()
        startTime = .now
        endTime = nil
    }
    
    var isOver: Bool {
        // ?. คือ ถ้า Array ไม่ใช่ nil จะ unwrapped ให้เอง
        attempts.first?.pegs == masterCode.pegs
    }
    
    func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        
        if let indexOfExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
            guess.pegs[index] = pegChoices[(indexOfExistingPegInPegChoices + 1) % pegChoices.count]
        } else {
            guess.pegs[index] = pegChoices.first ?? Code.missing
        }
    }
    
    func attemptGuess() {
        // guard คือ if ที่ต้องผ่านเท่านั้น ถึงจะทำบรรทัดต่อไป
        guard !attempts.contains(where: { $0.pegs == guess.pegs }) else { return }
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.insert(attempt, at: 0)
        guess.reset()
        if isOver {
            masterCode.kind = .master(isHidden: false)
            endTime = .now
        }
    }
    
    func setGuessPeg(_ peg: Peg, at index: Int) {
        guess.pegs[index] = peg
    }
}

extension CodeBreaker: Identifiable, Hashable, Equatable {
    static func == (lhs: CodeBreaker, rhs: CodeBreaker) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
