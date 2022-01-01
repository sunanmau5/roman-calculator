//
//  Roman.swift
//  roman-calculator
//
//  Created by MBA on 01.01.22.
//

import Foundation

class Roman {
    let symbolsFull: KeyValuePairs = [
        "I": 1,
        "IV": 4,
        "V": 5,
        "IX": 9,
        "X": 10,
        "XL": 40,
        "L": 50,
        "XC": 90,
        "C": 100,
        "CD": 400,
        "D": 500,
        "CM": 900,
        "M": 1000
    ]

    let symbols: [Character: Int] = [
        "M": 1000,
        "D": 500,
        "C": 100,
        "L": 50,
        "X": 10,
        "V": 5,
        "I": 1,
    ]
    
    enum RomanError: Error {
        case invalidRomanNumeral(_ roman: String)
        case valueOutOfRange(_ value: Int)
    }

    /// Validate Roman Numeral String using RegEx
    public func validateRomanNumeral(_ roman: String) -> Bool {
        let pattern = "^M{0,3}(CM|CD|D?C{0,3})(XC|XL|L?X{0,3})(IX|IV|V?I{0,3})$"
        return roman.range(of: pattern, options: .regularExpression) != nil
    }

    /// Fucntion to convert Roman Number String to Integer
    public func convertRomanToNumber(_ roman: String) throws -> Int {
        guard validateRomanNumeral(roman) else {
            throw RomanError.invalidRomanNumeral(roman)
        }
        var value = 0
        for i in 0..<roman.count {
            let curr = roman[roman.index(roman.startIndex, offsetBy: i)]
            let currValue = symbols[curr]!
            
            if i + 1 >= roman.count {
                value += currValue
                return value
            } else {
                let next = roman[roman.index(roman.startIndex, offsetBy: i + 1)]
                let nextValue = symbols[next]!
                if currValue >= nextValue {
                    value += currValue
                } else if currValue < nextValue {
                    value -= currValue
                }
            }
        }
        return value
    }

    /// Function to convert Integer to Roman Numeral String
    public func convertNumberToRoman(_ value: Int) throws -> String {
        guard value > 0 && value < 4000 else {
            throw RomanError.valueOutOfRange(value)
        }
        var number = value
        var roman = ""
        while number > 0 {
            for (symbol, intValue) in symbolsFull.reversed() {
                let remainder = number - intValue
                if remainder >= 0 {
                    number = remainder
                    roman += symbol
                    break
                }
            }
        }
        return roman
    }
}
