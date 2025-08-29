//
//  Stage.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 28.08.25.
//
import Foundation

struct Stage: Identifiable, Codable, Equatable, Hashable {
    var id = UUID()
    let completed: Bool
    let current: Bool
}
