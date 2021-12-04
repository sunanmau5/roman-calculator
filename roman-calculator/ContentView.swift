//
//  ContentView.swift
//  roman-calculator
//
//  Created by MBA on 09.11.21.
//

import SwiftUI

let symbols: [Character: Int] = [
    "M": 1000,
    "D": 500,
    "C": 100,
    "L": 50,
    "X": 10,
    "V": 5,
    "I": 1,
]

func convertRomanToNumber(_ roman: String) -> Int {
    if !validateRomanNumeral(roman) {
        print("Invalid Roman numeral! \(roman)")
        return -1
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

func validateRomanNumeral(_ roman: String) -> Bool {
    let pattern = "^M{0,3}(CM|CD|D?C{0,3})(XC|XL|L?X{0,3})(IX|IV|V?I{0,3})$"
    return roman.range(of: pattern, options: .regularExpression) != nil
}

func checkIfOperator(str: String) -> Bool {
    if str == "-" || str == "+" || str == "=" {
        return true
    }
    return false
}

func flattenTheExpression(exps: [String]) -> String {
    var calExp = ""
    for exp in exps {
        calExp.append(exp)
    }
    return calExp
}

func processExpression(exp:[String]) -> String {
    if exp.count < 3 {
        return "0.0"
    }
    
    var a = Double(exp[0])
    var c = Double("0.0")
    let expSize = exp.count
    
    for i in (1...expSize - 2) {
        c = Double(exp[i + 1])
        switch exp[i] {
        case "+":
            a! += c!
        case "−":
            a! -= c!
        case "×":
            a! *= c!
        case "÷":
            a! /= c!
        default:
            print("skipping the rest")
        }
    }
    return String(format: "%.1f", a!)
}

struct ContentView: View {
    let rows = [
        ["M", "D", "C", "-"],
        ["L", "X", "V", "+"],
        ["", "I", "", "="],
    ]
    
    @State var currentValue: String = ""
    @State var finalValue: String = "0"
    @State var expression: [String] = []
    
    var body: some View {
        VStack{
            VStack {
                Text(self.finalValue)
                    .font(.system(size: 80))
                    .frame(idealWidth: 100, maxWidth: .infinity, idealHeight: 100, maxHeight: .infinity, alignment: .center)
                Text(flattenTheExpression(exps: expression))
                    .font(.system(size: 24))
                    .frame(alignment: Alignment.bottomTrailing)
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .background(Color.white)
            VStack {
                VStack {
                    Spacer(minLength: 18)
                    ForEach(rows, id: \.self) { row in
                        HStack(alignment: .top, spacing: 0) {
                            ForEach(row, id: \.self) { element in
                                Button(action: {
                                    if element == "=" {
                                        self.expression = []
                                        self.currentValue = ""
                                        return
                                    } else if checkIfOperator(str: element)  {
                                        self.expression.append(element)
                                        self.currentValue = ""
                                    } else {
                                        self.currentValue.append(element)
                                        if self.expression.count == 0 {
                                            self.expression.append(self.currentValue)
                                        } else {
                                            if !checkIfOperator(str: self.expression[self.expression.count - 1]) {
                                                self.expression.remove(at: self.expression.count-1)
                                            }
                                            self.expression.append(self.currentValue)
                                        }
                                    }
                                    
                                    self.finalValue = processExpression(exp: self.expression)
                                    
                                    if self.expression.count > 3 {
                                        self.expression = [self.finalValue, self.expression[self.expression.count - 1]]
                                    }
                                }, label: {
                                    Text(element)
                                        .font(.system(size: 32.0))
                                        .frame(idealWidth: 100, maxWidth: .infinity, idealHeight: 100, maxHeight: .infinity, alignment: .center)
                                })
                                    .foregroundColor(Color.white)
                            }
                        }
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 414, maxHeight: .infinity, alignment: .topLeading)
            .background(Color.black)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
