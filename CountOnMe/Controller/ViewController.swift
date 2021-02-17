//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet var operatorsButtons: [UIButton]!
    
    var calculation = Calculation()
    
    private func error(message: String) {
        let alertVC = UIAlertController(title: "Zéro!", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calculation.calculationDelegate = self
        calculation.showErrorDelegate = self
    }
    
    @IBAction func tappedEqualButton() {
        calculation.equals()
    }
    
    @IBAction func tappedACButton() {
        calculation.calculationExpression = ""
    }
    
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        calculation.addNumbers(numbers: numberText)
    }
    
    @IBAction func didTapOperatorButton(_ sender: UIButton) {
        guard let operatorSymbol = sender.title(for: .normal) else {
            return
        }
        calculation.addOperator(symbol: operatorSymbol)
        
//        if sender == operatorsButtons[0] {
//            calculation.additionOrSubstraction(symbol: " + ")
//        } else if sender == operatorsButtons[1] {
//            calculation.additionOrSubstraction(symbol: " - ")
//        } else if sender == operatorsButtons[2] {
//            calculation.equals() // peut être mettre le égal comme le AC, à part
//        } else if sender == operatorsButtons[3] {
//            calculation.additionOrSubstraction(symbol: " × ")
//        } else if sender == operatorsButtons[4] {
//            calculation.additionOrSubstraction(symbol: " ÷ ")
//        }
    }
}

extension ViewController: CalculationAndErrorDelegates {
    func calculationUpdated(_ calcul: String) {
        textView.text = calcul
    }
    func errorNotEnoughElements() {
        return error(message: "Il manque certains éléments pour pouvoir effectuer un calcul")
    }
    func errorExpressionIsIncorrect() {
        return error(message: "L'expression n'est pas correcte")
    }
    func errorOperandIsAlreadySet() {
        return error(message: "Un opérateur est déjà mis !")
    }
    func errorUnknownOperand() {
        return error(message: "Erreur")
    }
}
