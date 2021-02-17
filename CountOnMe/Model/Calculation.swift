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
    
    // func calculationError a base d'enum :
    func errorNotEnoughElements()
    func errorExpressionIsIncorrect()
    func errorOperandIsAlreadySet()
    func errorUnknownOperand()
}


class Calculation {
    
    var calculationDelegate: CalculationAndErrorDelegates?
    
    var showErrorDelegate: CalculationAndErrorDelegates?
    
    var calculationExpression: String = "" {
            didSet {
                calculationDelegate?.calculationUpdated(calculationExpression)
            }
        }
    
    var elements: [String] {
        return calculationExpression.split(separator: " ").map { (operand) -> String in
            return "\(operand)"
        } //.map { "\($0)" }
    }
    
    // FIXME: ressortir haveEnoughElements
    var expressionIsCorrect: Bool {
        return elements.count >= 3 && elements.last != "+" && elements.last != "-" && elements.last != "×" && elements.last != "×" && elements.last != "÷"
    }
    
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "×" && elements.last != "×" && elements.last != "÷"
    }
    
    var expressionHasResult: Bool {
        return calculationExpression.firstIndex(of: "=") != nil
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
            showErrorDelegate?.errorOperandIsAlreadySet()
        }
    }
    
//    func addition(firstNumber: Int, secondNumber: Int) -> String {
//        let result = firstNumber + secondNumber
//        return "\(result)"
//    }
//    
//    func substraction(firstNumber: Int, secondNumber: Int) -> String {
//        let result = firstNumber - secondNumber
//        return "\(result)"
//    }
//    
//    func multiplication(firstNumber: Int, secondNumber: Int) -> String {
//        let result = firstNumber * secondNumber
//        return "\(result)"
//    }
//    
//    func division(firstNumber: Int, secondNumber: Int) -> String {
//        let result = firstNumber / secondNumber
//        return "\(result)"
//    }
    
    // créer une méthode ou on a appuyé sur le bouton "operator"
    
    // tappedNumberButton doit être mis sous forme de méthode ici
    
    //
    
    func equals() { // resolve
        
        guard expressionIsCorrect else {
            showErrorDelegate?.errorExpressionIsIncorrect()
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
                showErrorDelegate?.errorUnknownOperand()
                return
            }
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        
        calculationExpression.append(" = \(operationsToReduce.first!)")
    }
}
