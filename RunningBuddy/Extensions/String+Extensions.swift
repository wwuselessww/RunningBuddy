//
//  String+Extensions.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 19.05.25.
//

import Foundation
extension String {
    func toSportFormat() -> String {
        let arr = self.components(separatedBy: ":")
        var res: String = ""
        for string in arr {
            guard let num = Int(string) else {return self}
            if num < 10 {
                res.append("0\(num):")
            } else {
                res.append("\(num):")
            }
        }
        let resultString = res.dropLast()
        return resultString.description
    }
}
