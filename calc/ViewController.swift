//
//  ViewController.swift
//  calc
//
//  Created by maksim_p on 17.07.17.
//  Copyright © 2017 maksim_p. All rights reserved.
//

import UIKit
import Foundation
import LTMorphingLabel

class ViewController: UIViewController, LTMorphingLabelDelegate {
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var displayLabelPink: LTMorphingLabel!
    @IBOutlet weak var displayLabelBlue: LTMorphingLabel!
    @IBOutlet weak var displayLabel: LTMorphingLabel!
    
    let formatter = NumberFormatter()
    private var brain = CalculationBrain()
    
    var userIsInTheMiddleOfTyping : Bool = false
    
    var displayValue: Double {
        get {
            return Double(displayLabel.text!)!
        }
        set {
            formatter.numberStyle = NumberFormatter.Style.decimal
            formatter.roundingMode = NumberFormatter.RoundingMode.halfUp
            formatter.maximumFractionDigits = 3
            let newValue = formatter.string(from: NSNumber(value: newValue))
            displayLabel.text = newValue == "." ? "0." : newValue
            display()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayLabel.delegate = self
        displayLabelBlue.delegate = self
        displayLabelPink.delegate = self
    }
    
    // MARK: Actions
    @IBAction func digitPressed(_ sender: UIButton) {
        
        displayLabel.morphingEffect = .scale
        displayLabelBlue.morphingEffect = .scale
        displayLabelPink.morphingEffect = .scale
        animationButton(button: sender)
        guard let digit = sender.currentTitle else {
            return
        }
        if digit == ".", displayLabel.text == "0" {
            displayLabel.text = "0."
            userIsInTheMiddleOfTyping = true
            
        }
        if userIsInTheMiddleOfTyping {
            if displayLabel.text?.range(of: ".") != nil, digit == "."  {
                displayLabel.text = displayLabel.text
            }else {
                let textCurrentlyOnDisplay = displayLabel.text
                displayLabel.text = textCurrentlyOnDisplay! + digit
            }
        }else {
            displayLabel.text = digit == "." ? "0." : digit
            userIsInTheMiddleOfTyping = true
        }
        display()
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        
        animationButton(button: sender)
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            displayLabel.morphingEffect = mathematicalSymbol == "AC" ? .pixelate : .scale
            displayLabelBlue.morphingEffect = mathematicalSymbol == "AC" ? .pixelate : .scale
            displayLabelPink.morphingEffect = mathematicalSymbol == "AC" ? .pixelate : .scale
            brain.performOperation(mathematicalSymbol)
            userIsInTheMiddleOfTyping = false
        }
        if let result = brain.result {
            displayValue = result
        }
    }
    
    //Display effect
    func display(){
        displayLabelPink.text = displayLabel.text
        displayLabelBlue.text = displayLabel.text
    }
    
    func animationButton(button:UIButton) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        button.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.1) {
                            button.transform = CGAffineTransform.identity
                        }
        })
    }
}
