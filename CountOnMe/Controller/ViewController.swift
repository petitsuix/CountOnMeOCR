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
    }
    
    
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        
        if calculation.expressionHaveResult {
            calculation.calculationView = ""
        }
        
        calculation.calculationView.append(numberText)
    }
    

    
    @IBAction func didTapOperatorButton(_ sender: UIButton) {
        if sender == operatorsButtons[0] {
            calculation.additionOrSubstraction(symbol: " + ")
        } else if sender == operatorsButtons[1] {
            calculation.additionOrSubstraction(symbol: " - ")
        } else if sender == operatorsButtons[2] {
            guard calculation.expressionIsCorrect else {
                error(message: "Entrez une expression correcte !")
            return
            }
            guard calculation.expressionHasEnoughElements else {
                error(message: "Démarrez un nouveau calcul !")
                return
            }
            calculation.equals()
        }
    }
}

extension ViewController: CalculationDelegate {
    func calculationUpdated(_ calcul: String) {
        textView.text = calcul
    }
}

extension ViewController: ErrorDelegate {

    func errorNotEnoughElements() {
        return error(message: "Il manque certains éléments pour pouvoir effectuer un calcul")
    }

    func errorExpressionIsIncorrect() {
        return error(message: "Entre une expression correcte !")
    }
}
