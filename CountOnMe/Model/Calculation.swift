//
//  ModelCountOnMe.swift
//  CountOnMe
//
//  Created by Richardier on 10/02/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

protocol CalculationAndErrorDelegates: class {
    func calculationUpdated(_ calcul: String)
    func calculationError(_ message: String)
}

class Calculation {
    
    var calculationAndErrorDelegates: CalculationAndErrorDelegates!
    
    var calculationExpression: String = "" {
            didSet {
                calculationAndErrorDelegates?.calculationUpdated(calculationExpression)
            }
        }
    
    var elements: [String] {
        return calculationExpression.split(separator: " ").map { (operand) -> String in
            return "\(operand)"
        } //.map { "\($0)" }
    }
    
    var haveEnoughElements: Bool {
        return elements.count >= 3
    }
    
    // FIXME: ressortir haveEnoughElements
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "×" && elements.last != "÷"
    }
    
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "×" && elements.last != "÷"
    }
    
    var expressionHasResult: Bool {
        return calculationExpression.firstIndex(of: "=") != nil
    }
    
    private enum Errors: String {
        case notEnoughElements = "Il manque un élément à ce calcul"
        case errorExpressionIsIncorrect = "Entrez une expression correcte !"
        case operandIsAlreadySet = "Un opérateur est déjà en place"
        case errorUnknownOperand = "Opérateur inconnu"
    }
    
    func addNumbers(numbers: String) {
        if expressionHasResult {
            calculationExpression = ""
        }
        calculationExpression.append(numbers)
    }
    
    func addOperator(symbol: String) {
        if canAddOperator {
            calculationExpression.append(" \(symbol) ")
        } else {
            calculationAndErrorDelegates.calculationError(Errors.operandIsAlreadySet.rawValue)
        }
    }
    
    func equals() { // resolve
        
        guard expressionIsCorrect else {
            calculationAndErrorDelegates.calculationError(Errors.errorExpressionIsIncorrect.rawValue)
        return
        }
        
        guard haveEnoughElements else {
            calculationAndErrorDelegates.calculationError(Errors.notEnoughElements.rawValue)
        return
        }
        
        var operationsToReduce = elements
        
        while operationsToReduce.count > 1 {
            let left = Double(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Double(operationsToReduce[2])!
            
            var result: Double = 0.00
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "×": result = left * right
            case "÷": result = left / right
            default:
                calculationAndErrorDelegates.calculationError(Errors.errorExpressionIsIncorrect.rawValue)
                return
            }
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        
        calculationExpression.append(" = \(operationsToReduce.first!)")
    }
}
