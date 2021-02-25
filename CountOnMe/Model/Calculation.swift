//
//  ModelCountOnMe.swift
//  CountOnMe
//
//  Created by Richardier on 10/02/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

// MARK: - Protocols


class Calculation {
    
    // MARK: - Instanciated Calculation and Error delegates
    
    
    // MARK: - Instanciated textView
    var calculationExpression: String = "" {
        didSet {
            //            calculationAndErrorDelegates?.calculationUpdated(calculationExpression)
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
    
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "×" && elements.last != "÷"
    }
    
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "×" && elements.last != "÷"
    }
    
    var expressionHasResult: Bool {
        return calculationExpression.firstIndex(of: "=") != nil
    }
    
    enum Errors: String {
        case notEnoughElements = "Il manque un élément à ce calcul"
        case errorExpressionIsIncorrect = "Entrez une expression correcte !"
        case operandIsAlreadySet = "Un opérateur est déjà en place"
        case haveResultAlready = "Faites un nouveau calcul !"
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
        if canAddOperator {
            calculationExpression.append(" \(symbol) ")
        } else {
            calculationExpression = "Erreur"
        }
    }
    
    func equals() { // resolve
        
        guard haveEnoughElements else {
            calculationExpression = "Erreur"
            return
        }
        
        guard expressionIsCorrect else {
            calculationExpression = "Erreur"
            return
        }
        
        
        
        var operationsToReduce = elements
        
        
        while operationsToReduce.contains("×") || operationsToReduce.contains("÷") {
            
            for element in operationsToReduce {
                
                if element == "×" {
                    
                    let left = operationsToReduce[operationsToReduce.firstIndex(of: element)!-1]
                    let right = operationsToReduce[operationsToReduce.firstIndex(of: element)!+1]
                    
                    calculationResult = "\(Double(left)! * Double(right)!)"
                    
                    operationsToReduce.remove(at: operationsToReduce.firstIndex(of: element)!+1)
                    operationsToReduce.remove(at: operationsToReduce.firstIndex(of: element)!-1)
                    operationsToReduce.insert(calculationResult, at:  operationsToReduce.firstIndex(of: element)!)
                    operationsToReduce.remove(at: operationsToReduce.firstIndex(of: element)!)
                    
                    
                } else if element == "÷" {
                    let left = operationsToReduce[operationsToReduce.firstIndex(of: element)!-1]
                    let right = operationsToReduce[operationsToReduce.firstIndex(of: element)!+1]
                    if right == "0" {
                        notifyErrorDivisionByZero()
                        return
                    }
                    calculationResult = "\(Double(left)! / Double(right)!)"
                    
                    operationsToReduce.remove(at: operationsToReduce.firstIndex(of: element)!+1)
                    operationsToReduce.remove(at: operationsToReduce.firstIndex(of: element)!-1)
                    operationsToReduce.insert(calculationResult, at:  operationsToReduce.firstIndex(of: element)!)
                    operationsToReduce.remove(at: operationsToReduce.firstIndex(of: element)!)
                    
                }
            }
            
        }
        
        while operationsToReduce.count >= 3 {
            let left = Double(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Double(operationsToReduce[2])!
            
            switch operand {
            case "+": calculationResult = "\(left + right)"
            case "-": calculationResult = "\(left - right)"
            default:
                if expressionHasResult {
                    calculationExpression = "Erreur"
                }
                return
            }
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(calculationResult)", at: 0)
        }
        calculationExpression.append(" = \(operationsToReduce.first!)")
    }
}
