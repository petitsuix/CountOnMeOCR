//
//  ModelCountOnMe.swift
//  CountOnMe
//
//  Created by Richardier on 10/02/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

protocol CalculationDelegate: class {
    func calculationUpdated(_ calcul: String)
}

protocol ErrorDelegate: class {
    func errorNotEnoughElements()
    func errorExpressionIsIncorrect()
}

class Calculation {
    
    var calculationDelegate: CalculationDelegate?
    
    var showErrorDelegate: ErrorDelegate?
    
    var calculationView: String = "" {
            didSet {
                calculationDelegate?.calculationUpdated(calculationView)
            }
        }
    
    var elements: [String] {
        return calculationView.split(separator: " ").map { "\($0)" }
    }
    
    // Error check computed variables
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-"
    }
    
    var expressionHasEnoughElements: Bool {
        return elements.count >= 3
    }
    
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-"
    }
    
    var expressionHaveResult: Bool {
        return calculationView.firstIndex(of: "=") != nil
    }
    
    func additionOrSubstraction(symbol: String) {
        if canAddOperator {
            calculationView.append(symbol)
        } else { // Fix error message : Un opérateur est déjà mis !
            showErrorDelegate?.errorExpressionIsIncorrect()
        }
    }
    
    func addition(firstNumber: Int, secondNumber: Int) -> String {
        let result = firstNumber + secondNumber
        return "\(result)"
    }
    
    func substraction(firstNumber: Int, secondNumber: Int) -> String {
        let result = firstNumber - secondNumber
        return "\(result)"
    }
    
    func multiplication(firstNumber: Int, secondNumber: Int) -> String {
        let result = firstNumber * secondNumber
        return "\(result)"
    }
    
    func division(firstNumber: Int, secondNumber: Int) -> String {
        let result = firstNumber / secondNumber
        return "\(result)"
    }
    
    func equals() {
        
        var operationsToReduce = elements
        
        while operationsToReduce.count > 1 {
            let left = Int(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Int(operationsToReduce[2])!
            
            let result: String
            switch operand {
            case "+": result = addition(firstNumber: left, secondNumber: right)
            case "-": result = substraction(firstNumber: left, secondNumber: right)
            case "×": result = multiplication(firstNumber: left, secondNumber: right)
            case "÷": result = multiplication(firstNumber: left, secondNumber: right)
        //  case "=" where expressionIsIncorrect
            default: fatalError("Unknown operator !")
            }
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        
        calculationView.append(" = \(operationsToReduce.first!)")
    }
}
