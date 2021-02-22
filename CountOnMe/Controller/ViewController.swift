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

    var calculation = Calculation()

    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calculation.calculationAndErrorDelegates = self
    }
    
    @IBAction func tappedEqualButton() {
        calculation.equals()
    }
    
    @IBAction func tappedACButton() {
        calculation.resetCalculationExpression()
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
    }
}

extension ViewController: CalculationAndErrorDelegates {
  
    func calculationUpdated(_ calcul: String) {
        textView.text = calcul
    }

    func calculationError(_ message: String) {
        let alertVC = UIAlertController(title: "Zéro!", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
