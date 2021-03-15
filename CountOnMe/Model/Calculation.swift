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
    
    var expressionIsNotDividedByZero: Bool {
        if calculationExpression.contains("÷ 0") {
            calculationExpression = "= div. by zero"
            return false
        }
        return true
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
            calculationExpression = "= invalid op." // invalid operation (ex : 2 + + 4)
        }
    }
    
    func cleanResult() {
        if let cleanedResult = (Double("\(resolve())")?.cleanCalculations()) {
            calculationExpression.append(" = \(cleanedResult)")
        }
    }
    
    func verifyCalculationIsValid() -> Bool {
        if expressionHasResult {
            if let cleanedResult = (Double("\(calculationResult)")?.cleanCalculations()) {
                resetCalculationExpression()
                calculationExpression.append(" = \(cleanedResult)")
            }
            return false
        }
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
        guard expressionIsNotDividedByZero else { notifyErrorDivisionByZero(); return }
        guard verifyCalculationIsValid() else { return }
        cleanResult()
    }
    
    func resolve() -> String {
        var operationsToReduce = elements
        if operationsToReduce.first == "-" || operationsToReduce.first == "+" {
            operationsToReduce[0] = "\(operationsToReduce[0])\(operationsToReduce[1])"
            operationsToReduce.remove(at: 1)
        }
        while operationsToReduce.count >= 3 {
            var operandIndex = 1
                if let index = operationsToReduce.firstIndex(where: { $0.contains("×") || $0.contains("÷")}) {
                    operandIndex = index
            }
            guard let left = Double(operationsToReduce[operandIndex-1]), let right = Double(operationsToReduce[operandIndex+1]) else { return "= out of range" }
            let operand = operationsToReduce[operandIndex]
            switch operand {
            case "+": calculationResult = "\(left + right)"
            case "-": calculationResult = "\(left - right)"
            case "×": calculationResult = "\(left * right)"
            case "÷": calculationResult = "\(left / right)"
            default: return "wrong operand"
            }
            operationsToReduce.remove(at: operandIndex+1)
            operationsToReduce.remove(at: operandIndex-1)
            operationsToReduce.insert(calculationResult, at: operandIndex)
            operationsToReduce.remove(at: operandIndex-1)
        }
        return calculationResult
    }
}

extension Double {
    func cleanCalculations() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 4
        return String(formatter.string(from: number) ?? "= wrong format")
    }
}
