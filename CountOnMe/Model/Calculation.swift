//
//  ModelCountOnMe.swift
//  CountOnMe
//
//  Created by Richardier on 10/02/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

class Calculation {
    
    // MARK: - Public & private properties
    
    // calculationExpression takes the value obtained through notifyCalculationUpdated()
    var calculationExpression: String = "" {
        didSet {
            notifyCalculationUpdated()
        }
    }
    
    var calculationResult: String = ""
    
    // Splitting and instanciating calculationExpression
   private var elements: [String] {
        return calculationExpression.split(separator: " ").map { (operand) -> String in
            return "\(operand)"
        } //.map { "\($0)" }
    }
    
    private var haveEnoughElements: Bool {
        return elements.count >= 3
    }
    
    private var expressionStartsWithValidElement: Bool {
        return elements.first != "×" && elements.first != "÷"
    }
    
    private var expressionEndsWithValidElement: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "×" && elements.last != "÷"
    }
    
    private var expressionAlreadyHasAResult: Bool {
        return calculationExpression.firstIndex(of: "=") != nil
    }
    
    private var expressionIsNotDividedByZero: Bool {
        if calculationExpression.contains("÷ 0") {
            calculationExpression = "= div. by zero"
            return false
        }
        return true
    }
    
    // MARK: - Public methods
    
    func resetCalculationExpression() {
        calculationExpression = ""
    }
    
    func addNumbers(numbers: String) {
        if expressionAlreadyHasAResult {
            resetCalculationExpression() // If a result is already there, then typing a new number cleans the calculation expression
        }
        calculationExpression.append(numbers)
    }
    
    func addOperator(symbol: String) {
        if expressionAlreadyHasAResult {
            resetCalculationExpression() // If a result is already there, then typing a new symbol cleans the calculation expression
        }
        if expressionEndsWithValidElement {
            calculationExpression.append(" \(symbol) ")
        } else {
            calculationExpression = "= invalid op." // invalid operation (ex : 2 + + 4)
        }
    }
    
    // Handles calculation from A to Z, including verification of potential errors and cleaning of decimals.
    func equals() {
        guard expressionIsNotDividedByZero else { notifyErrorDivisionByZero(); return }
        guard verifyCalculationIsValid() else { return }
        cleanResult()
    }
    
    // MARK: - Private methods
    
    // This method goes through typical error properties to ensure that the calculation is valid before resolving it
    private func verifyCalculationIsValid() -> Bool {
        if expressionAlreadyHasAResult {
            if let cleanedResult = (Double("\(calculationResult)")?.truncateExtraDecimals()) {
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
    
    // Core calculation method with priorization of elements
    private func resolve() -> String {
        var operationsToReduce = elements
        if operationsToReduce.first == "-" || operationsToReduce.first == "+" { // If calculation's 1st element is "+" or "-"...
            operationsToReduce[0] = "\(operationsToReduce[0])\(operationsToReduce[1])" // ... group it with the following element
            operationsToReduce.remove(at: 1)
        }
        while operationsToReduce.count >= 3 {
            var operandIndex = 1 // operand index is always 1 (ex : 6 + 2)...
                if let index = operationsToReduce.firstIndex(where: { $0.contains("×") || $0.contains("÷")}) { // ... unless the calculation contains priority operands. If so, the index value is set accordingly to the operand's place.
                    operandIndex = index
            }
            guard let left = Double(operationsToReduce[operandIndex-1]), let right = Double(operationsToReduce[operandIndex+1]) else { return "= out of range" } // Based on the previously designated operandIndex, giving corresponding values to "left" & "right"
            let operand = operationsToReduce[operandIndex]
            switch operand {
            case "+": calculationResult = "\(left + right)"
            case "-": calculationResult = "\(left - right)"
            case "×": calculationResult = "\(left * right)"
            case "÷": calculationResult = "\(left / right)"
            default: return "wrong operand"
            }
            operationsToReduce.remove(at: operandIndex+1) // Remove elements that were calculated, replace them with the result
            operationsToReduce.remove(at: operandIndex-1)
            operationsToReduce.insert(calculationResult, at: operandIndex)
            operationsToReduce.remove(at: operandIndex-1)
        }
        return calculationResult
    }
    
    // Takes the unnecessary decimals out to show a "cleaned result"
    private func cleanResult() {
        if let cleanedResult = (Double("\(resolve())")?.truncateExtraDecimals()) {
            calculationExpression.append(" = \(cleanedResult)")
        }
    }
    
    // MARK: - Notification methods

    // Posting "calculation error" notification to the Calculator View Controller observer
    private func notifyErrorDivisionByZero() {
        let notificationName = NSNotification.Name(rawValue: "calculation error")
        let notification = Notification(name: notificationName)
        NotificationCenter.default.post(notification)
    }
    
    // Posting "calculation updated" notification to the Calculator View Controller observer
    private func notifyCalculationUpdated() {
        let notificationName = NSNotification.Name(rawValue: "calculation updated")
        let notification = Notification(name: notificationName)
        NotificationCenter.default.post(notification)
    }
}
