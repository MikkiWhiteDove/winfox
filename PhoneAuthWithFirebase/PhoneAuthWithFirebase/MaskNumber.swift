//
//  MaskNumber.swift
//  PhoneAuthWithFirebase
//
//  Created by Mishana on 28.08.2022.
//

import Foundation

class MaskNumber {
    
    init () {
//        formatter(mask:, phoneNumber: )
    }
    
    func formatter(mask: String, phoneNumber: String) -> String {
        let number = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result: String = ""
        var index = number.startIndex
        
        for character in mask where index < number.endIndex{
            if character == "X" {
                result.append(number[index])
                index = number.index(after: index)
            }else {
                result.append(character)
            }
        }
        return result
    }
}
