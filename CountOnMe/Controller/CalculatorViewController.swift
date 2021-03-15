//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var textView: UITextView!

    var calculation = Calculation()

    // MARK: - Methods
    
    @objc func calculationUpdated() {
        textView.text = calculation.calculationExpression
    }
    
    @objc func errorDivisionByZero() {
            let alertVC = UIAlertController(title: "Erreur", message: "Division par zéro impossible", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: - View Life cycles methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let notificationName = NSNotification.Name(rawValue: "calculation updated")
        NotificationCenter.default.addObserver(self, selector: #selector(calculationUpdated), name: notificationName, object: nil)
        
        let notificationErrorName = NSNotification.Name(rawValue: "calculation error")
        NotificationCenter.default.addObserver(self, selector: #selector(errorDivisionByZero), name: notificationErrorName, object: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func tappedACButton() {
        calculation.resetCalculationExpression()
    }
    
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else { return }
        calculation.addNumbers(numbers: numberText)
    }
    
    @IBAction func tappedOperatorButton(_ sender: UIButton) {
        guard let operatorSymbol = sender.title(for: .normal) else { return }
        calculation.addOperator(symbol: operatorSymbol)
    }
    
    @IBAction func tappedEqualButton() {
        calculation.equals()
    }
}
