//
//  DoubleTransformer.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 08.07.25.
//

import Foundation

class DoubleArrayTransformer: ValueTransformer {
    override func transformedValue(_ value: Any?) -> Any? {
        guard let array = value as? [Double] else { return nil }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: array, requiringSecureCoding: true)
            return data
        } catch {
            print(error)
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
           guard let data = value as? Data else { return nil }
           do {
               let array = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: data)
               return array as? [Double]
           } catch {
               print("Decoding error:", error)
               return nil
           }
       }

}
