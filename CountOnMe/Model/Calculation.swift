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
    
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "×" && elements.last != "÷"
    }
    
    var canAddOperator: Bool {
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
        if canAddOperator {
            calculationExpression.append(" \(symbol) ")
        } else {
            calculationExpression = "= Erreur"
        }
    }
    
    func verifyDivisionByZero(element: String) {
        if element == "0" {
            notifyErrorDivisionByZero()
            calculationExpression = ""
            return
        }
    }
    
    func equals() { // resolve calculation
        guard haveEnoughElements else {
            calculationExpression = "= Erreur"
            return
        }
        
        guard expressionIsCorrect else {
            calculationExpression = "= Erreur"
            return
        }
        var operationsToReduce = elements
        
        if operationsToReduce[0] == "-" || operationsToReduce[0] == "+" {
            operationsToReduce[0] = "\(operationsToReduce[0])\(operationsToReduce[1])"
            operationsToReduce.remove(at: 1)
        }
        
        while operationsToReduce.contains("×") || operationsToReduce.contains("÷") {
            
            for element in operationsToReduce {
                
                switch element {
                case "×" :
                    let left = operationsToReduce[operationsToReduce.firstIndex(of: element)!-1]
                    let right = operationsToReduce[operationsToReduce.firstIndex(of: element)!+1]
                    
                    calculationResult = "\(Double(left)! * Double(right)!)"
                    
                    operationsToReduce.remove(at: operationsToReduce.firstIndex(of: element)!+1)
                    operationsToReduce.remove(at: operationsToReduce.firstIndex(of: element)!-1)
                    operationsToReduce.insert(calculationResult, at: operationsToReduce.firstIndex(of: element)!)
                    operationsToReduce.remove(at: operationsToReduce.firstIndex(of: element)!)
                case "÷" :
                    let left = operationsToReduce[operationsToReduce.firstIndex(of: element)!-1]
                    let right = operationsToReduce[operationsToReduce.firstIndex(of: element)!+1]
                    
                    verifyDivisionByZero(element: right)
                    
                    calculationResult = "\(Double(left)! / Double(right)!)"
                    
                    operationsToReduce.remove(at: operationsToReduce.firstIndex(of: element)!+1)
                    operationsToReduce.remove(at: operationsToReduce.firstIndex(of: element)!-1)
                    operationsToReduce.insert(calculationResult, at:  operationsToReduce.firstIndex(of: element)!)
                    operationsToReduce.remove(at: operationsToReduce.firstIndex(of: element)!)
                default :
                    break
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
                calculationExpression = "= Erreur"
                return
            }
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(calculationResult)", at: 0)
        }
        calculationExpression.append(" = \(operationsToReduce.first!)")
    }
}
