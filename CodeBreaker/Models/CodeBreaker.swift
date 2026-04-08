//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by นายนัชชานนท์ โปษยาอนุวัตร์ on 21/1/2569 BE.
//

import Foundation
import SwiftData

typealias Peg = String

// class จะเป็น reference เวลาเรียกใช้
// struct จะเป็น copy object เวลาเรียกใช้
@Model class CodeBreaker {
    var name: String
    @Relationship(deleteRule: .cascade) var masterCode: Code = Code(kind: .master(isHidden: true))
    @Relationship(deleteRule: .cascade) var guess: Code = Code(kind: .guess, pegs: [Code.missing, Code.missing, Code.missing, Code.missing])
    @Relationship(deleteRule: .cascade) var _attempts: [Code] = []
    @Transient var startTime: Date = .now
    var endTime: Date?
    var pegChoices: [Peg]
    var lastAttemptDate: Date? = Date.now
    
    var attempts: [Code] {
        get { _attempts.sorted { $0.timestamp > $1.timestamp } }
        set { _attempts = newValue }
    }
    
    init(name: String = "Code Breaker", pegChoices: [Peg]) {
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
    
    var isValid: Bool {
        !name.isEmpty && Set(pegChoices).count >= 2
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
        let attempt = Code(kind: .attempt(guess.match(against: masterCode)), pegs: guess.pegs)
        
        attempts.insert(attempt, at: 0)
        lastAttemptDate = .now
        guess.reset()
        if isOver {
            masterCode.kind = .master(isHidden: false)
            endTime = .now
        }
    }
    
    func setGuessPeg(_ peg: Peg, at index: Int) {
        guess.pegs[index] = peg
    }
    
    enum SortOption: CaseIterable {
        case name
        case recent
        
        var title: String {
            switch self {
            case .name: "Sort by Name"
            case .recent: "Sort by Recent"
            }
        }
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
