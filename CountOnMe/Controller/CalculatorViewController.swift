//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!

    var calculation = Calculation()

    @objc func calculationUpdated() {
        textView.text = calculation.calculationExpression
    }
    
    @objc func errorDivisionByZero() {
            let alertVC = UIAlertController(title: "Erreur", message: "Division par zéro impossible", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
    }
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        calculation.calculationAndErrorDelegates = self
        let notificationName = NSNotification.Name(rawValue: "calculation updated")
        NotificationCenter.default.addObserver(self, selector: #selector(calculationUpdated), name: notificationName, object: nil)
        
        let notificationErrorName = NSNotification.Name(rawValue: "calculation error")
        NotificationCenter.default.addObserver(self, selector: #selector(errorDivisionByZero), name: notificationErrorName, object: nil)
    }
    
    @IBAction func tappedEqualButton() {
        calculation.equals()
    }
    
    @IBAction func tappedACButton() {
        calculation.resetCalculationExpression()
    }
    
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else { return }
        calculation.addNumbers(numbers: numberText)
    }
    
    @IBAction func didTapOperatorButton(_ sender: UIButton) {
        guard let operatorSymbol = sender.title(for: .normal) else { return }
        calculation.addOperator(symbol: operatorSymbol)
    }
}
