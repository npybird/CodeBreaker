//
//  ElapsedTime.swift
//  CodeBreaker
//
//  Created by นายนัชชานนท์ โปษยาอนุวัตร์ on 18/2/2569 BE.
//

import SwiftUI

struct ElapsedTime: View {
    // MARK: Data In
    let startTime: Date
    let endTime: Date?  // ? = Optional
    
    var body: some View {
        if let endTime {    // if let endTimeLocal = endTime {
            Text(endTime, format: .offset(to: startTime, allowedFields: [.minute, .second]))
        } else {
            Text(TimeDataSource<Date>.currentDate, format: .offset(to: startTime, allowedFields: [.minute, .second]))
        }
    }
}

//#Preview {
//    ElapsedTime()
//}
