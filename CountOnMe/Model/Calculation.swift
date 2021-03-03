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
            calculationExpression = "" // Ajjouter resetExpressionView
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
        
        var operationsToReduce = elements
        
        if operationsToReduce.first == "-" || operationsToReduce.first == "+" {
            operationsToReduce[0] = "\(operationsToReduce[0])\(operationsToReduce[1])"
            operationsToReduce.remove(at: 1)
        }
        
        // FIXME : condenser tout ça en une méthode resolve qui return un string
        while operationsToReduce.contains("×") || operationsToReduce.contains("÷") {
            
            for element in operationsToReduce {
                
                if element == "×" || element == "÷" {
                    let left = operationsToReduce[operationsToReduce.firstIndex(of: element)!-1]
                    let right = operationsToReduce[operationsToReduce.firstIndex(of: element)!+1]
                    
                    switch element {
                    case "×" :
                        calculationResult = "\(Double(left)! * Double(right)!)"
                    case "÷" :
                        verifyDivisionByZero(element: right)
                        calculationResult = "\(Double(left)! / Double(right)!)"
                    default :
                        break
                    }
                    operationsToReduce.remove(at: operationsToReduce.firstIndex(of: element)!+1) // @ operandIndex
                    operationsToReduce.remove(at: operationsToReduce.firstIndex(of: element)!-1)
                    operationsToReduce.insert(calculationResult, at:  operationsToReduce.firstIndex(of: element)!)
                    operationsToReduce.remove(at: operationsToReduce.firstIndex(of: element)!)
                }
            }
        }
        
        while operationsToReduce.count >= 3 {
            
            guard let left = Double(operationsToReduce[0]) else { // a retravailler
                calculationExpression = "= Erreur"
                return
            }
            let operand = operationsToReduce[1] // trouver la possibilité de changer l'index 1 et de le baser sur l'operand en question, si pas de signe divisé ou multiplié, le laisser à 1
            let right = Double(operationsToReduce[2])!
            
            switch operand {
            case "+": calculationResult = "\(left + right)"
            case "-": calculationResult = "\(left - right)"
            default:
                calculationExpression = "= Erreur"
                return
            }
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(calculationResult)", at: 0)
        }
        calculationExpression.append(" = \(operationsToReduce.first!)") // Checker String Format pour arrondir les nombres entiers
    }
}
