//
//  ViewController.swift
//  calculate
//
//  Created by Little.Daddly on 16/4/25.
//  Copyright © 2016年 Little.Daddly. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!

    var userIsInputNum = false
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!

        if userIsInputNum {
            display.text = display.text! + digit
        }else{
            display.text = digit
            print("display.text =  \(display.text!)")
            userIsInputNum = true
        }
    }
    

    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInputNum{
            enter()
        }
        switch operation{
            case "×" : performOperation{ $0 * $1 }
            case "÷" : performOperation{ $1 / $0 }
            case "−" : performOperation{ $1 - $0 }
            case "+" : performOperation{ $0 + $1 }
            case "√" : performOperation{ sqrt($0) }
            default  : break
        
        }
    }
    
    func performOperation(operation : (Double , Double) -> Double){
        if openrandStack.count >= 2{
            displayValue = operation(openrandStack.removeLast(),openrandStack.removeLast())
            print("displayValue =  \(displayValue)")
            enter()
        }
    
    
    }
   
    private func performOperation(operation : Double -> Double){
        if openrandStack.count >= 1{
            displayValue = operation(openrandStack.removeLast())
            enter()
        }

        
    }

    var openrandStack = Array<Double>()
    @IBAction func enter() {
        userIsInputNum = false
        openrandStack.append(displayValue)
        print("openrandStack = \(openrandStack)")
    }
    
    var displayValue : Double{
        get{
            return (NSNumberFormatter().numberFromString(display.text!)!.doubleValue)
        }
        set{
            display.text = "\(newValue)"
            userIsInputNum = false
        }
    }


    @IBAction func emptyStack() {
        openrandStack.removeAll()
        displayValue = 0.0
        print("openrandStack = \(openrandStack)")
    }
 
}

