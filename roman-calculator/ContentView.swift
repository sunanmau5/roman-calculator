//
//  ContentView.swift
//  roman-calculator
//
//  Created by MBA on 09.11.21.
//

import SwiftUI

struct ContentView: View {
    let rows = [
        ["M", "D", "C", "-"],
        ["L", "X", "V", "+"],
        ["AC", "I", "", "="],
    ]
    
    @State var currentValue: String = ""
    @State var finalValue: String = ""
    @State var expression: [String] = []
    
    var roman: Roman = Roman()
    
    func getRomanFinalValue(value: String) -> String {
        let intValue = Int(value) ?? 0
        var roman = "#"
        guard intValue > 0 else {
            return roman
        }
        do {
            try roman = self.roman.convertNumberToRoman(intValue)
        } catch {
            print("Error: \(error)")
        }
        return roman
    }
    
    /// Process the expression of the calculator
    func processExpression(exp: [String]) throws -> String {
        let expSize = exp.count
        guard expSize >= 3 else {
            return "0"
        }
        
        var lhs = try self.roman.convertRomanToNumber(exp[0])
        var rhs = 0
        
        for i in (1...expSize - 2) {
            rhs = try self.roman.convertRomanToNumber(exp[i + 1])
            switch exp[i] {
            case "+":
                lhs += rhs
            case "-":
                lhs -= rhs
            default:
                print("skipping the rest")
            }
        }
        return String(lhs)
    }
    
    /// Returns true if the String is an operator
    func checkIfOperator(str: String) -> Bool {
        if str == "-" || str == "+" || str == "=" {
            return true
        }
        return false
    }
    
    /// Convert the expression Array String into a single String
    func flattenTheExpression(exps: [String]) -> String {
        var calExp = ""
        for exp in exps {
            calExp.append(" \(exp)")
        }
        return calExp
    }
    
    var body: some View {
        VStack{
            VStack {
                VStack {
                    Text(getRomanFinalValue(value: self.finalValue))
                        .font(.system(size: 60))
                    Text(self.finalValue)
                        .font(.system(size: 20))
                }
                .frame(idealWidth: 100, maxWidth: .infinity, idealHeight: 100, maxHeight: .infinity, alignment: .center)
                Text(flattenTheExpression(exps: self.expression))
                    .font(.system(size: 24))
                    .frame(alignment: .bottomTrailing)
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
                                    if element == "AC" || element == "=" {
                                        self.expression = []
                                        self.currentValue = ""
                                        if element == "AC" {
                                            self.finalValue = ""
                                        }
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
                                                self.expression.remove(at: self.expression.count - 1)
                                            }
                                            self.expression.append(self.currentValue)
                                        }
                                    }
                                    
                                    do {
                                        self.finalValue = try processExpression(exp: self.expression)
                                        if self.expression.count > 3 {
                                            self.expression = [self.finalValue, self.expression[self.expression.count - 1]]
                                        }
                                    } catch {
                                        self.finalValue = "\(error)"
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
