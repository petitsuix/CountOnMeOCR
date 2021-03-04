//
//  ModelCountOnMe.swift
//  CountOnMe
//
//  Created by Richardier on 10/02/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

class Calculation {
    
    // MARK: - Instanciated textView
    var calculationExpression: String = "" {
        didSet {
            notifyCalculationUpdated()
        }
    }
    
    private func notifyErrorDivisionByZero() {
        let notificationName = NSNotification.Name(rawValue: "calculation error")
        let notification = Notification(name: notificationName)
        NotificationCenter.default.post(notification)
    }
    
    private func notifyCalculationUpdated() {
        let notificationName = NSNotification.Name(rawValue: "calculation updated")
        let notification = Notification(name: notificationName)
        NotificationCenter.default.post(notification)
    }
    // MARK: - Properties
    var elements: [String] {
        return calculationExpression.split(separator: " ").map { (operand) -> String in
            return "\(operand)"
        } //.map { "\($0)" }
    }
    
    var calculationResult: String = ""
    
    var haveEnoughElements: Bool {
        return elements.count >= 3
    }
    
    var expressionStartsWithValidElement: Bool {
        return elements.first != "×" && elements.first != "÷"
    }
    
    var expressionEndsWithValidElement: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "×" && elements.last != "÷"
    }
    
    var expressionHasResult: Bool {
        return calculationExpression.firstIndex(of: "=") != nil
    }
    
    func resetCalculationExpression() {
        calculationExpression = ""
    }
    
    func addNumbers(numbers: String) {
        if expressionHasResult {
            resetCalculationExpression()
        }
        calculationExpression.append(numbers)
    }
    
    func addOperator(symbol: String) {
        if expressionHasResult {
            resetCalculationExpression()
        }
        if expressionEndsWithValidElement {
            calculationExpression.append(" \(symbol) ")
        } else {
            calculationExpression = "= Erreur"
        }
    }
    
    func verifyDivisionByZero(element: String) {
        if element == "0" {
            notifyErrorDivisionByZero()
            resetCalculationExpression()
            return
        }
    }
    
    func verifyCalculationIsValid() -> Bool {
        guard haveEnoughElements else {
            calculationExpression = "= missing elem."
            return false
        }
        guard expressionEndsWithValidElement else {
            calculationExpression = "= incorrect last elem."
            return false
        }
        guard expressionStartsWithValidElement else {
            calculationExpression = "= incorrect first elem."
            return false
        }
        return true
    }
    
    func equals() { // resolve calculation
        guard verifyCalculationIsValid() else { return }
        resolve()
    }
    
    func resolve() -> String {
        var operationsToReduce = elements
        
        if operationsToReduce.first == "-" || operationsToReduce.first == "+" {
            operationsToReduce[0] = "\(operationsToReduce[0])\(operationsToReduce[1])"
            operationsToReduce.remove(at: 1)
        }
        while operationsToReduce.count >= 3 {
            var operandIndex = Int()
            
            if operationsToReduce.contains("×") || operationsToReduce.contains("÷") {
                if operationsToReduce.firstIndex(where: { $0.contains("×") || $0.contains("÷")}) != nil {
                    operandIndex = operationsToReduce.firstIndex(where: { $0.contains("×") || $0.contains("÷")})!
                }
            } else {
                if operationsToReduce.firstIndex(where: { $0.contains("+") || $0.contains("-")}) != nil {
                    operandIndex = operationsToReduce.firstIndex(where: { $0.contains("+") || $0.contains("-")})!
                }
            }
            guard let left = Double(operationsToReduce[operandIndex-1]) else { calculationExpression = "= left is out of range"; return "out of range" }
            let operand = operationsToReduce[operandIndex]
            guard let right = Double(operationsToReduce[operandIndex+1]) else { calculationExpression = "= right is out of range"; return "out of range" }
            
            switch operand {
            case "+": calculationResult = "\(left + right)"
            case "-": calculationResult = "\(left - right)"
            case "×": calculationResult = "\(left * right)"
            case "÷": verifyDivisionByZero(element: "\(right)"); calculationResult = "\(left / right)"
            default: calculationExpression = "= wrong operand"; return "wrong operand"
            }
            operationsToReduce.remove(at: operandIndex+1) // @ operandIndex
            operationsToReduce.remove(at: operandIndex-1)
            operationsToReduce.insert(calculationResult, at: operandIndex)
            operationsToReduce.remove(at: operandIndex-1)
            
        }
        if operationsToReduce.first != nil {
            calculationExpression.append(" = \(calculationResult)") // Checker String Format pour arrondir les nombres entiers
        }
        return calculationResult
    }
}
