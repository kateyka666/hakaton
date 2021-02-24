//
//  ViewController.swift
//  Kateyka Calculator
//
//  Created by Екатерина Боровкова on 15.02.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var showResultLAbel: UILabel!
    
    var firstOperand : Double = 0
    var secondOperand : Double = 0
    var actionBool = false
    var actionToDo : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickButtonNumber(_ sender: UIButton) {
        
        if showResultLAbel.text == "0" {
            if sender.titleLabel?.text == "0"{
                return
            } else if sender.titleLabel?.text == ","{
                sender.titleLabel?.text = "0."
            } else
            if sender.titleLabel?.text == "+/-" && showResultLAbel.text == "-0" {
               sender.titleLabel?.text = "0"
           } else if sender.titleLabel?.text == "+/-" && showResultLAbel.text == "0" {
               sender.titleLabel?.text = "-0"
           } else if sender.titleLabel?.text  == "⁒" {
            return
           }
            showResultLAbel.text = sender.titleLabel?.text
            if actionBool == true {
            showResultLAbel.text?.remove(at: showResultLAbel.text!.startIndex)
            secondOperand = Double(showResultLAbel.text!) ?? 0.0
            actionBool = false
            }
        } else {
            if sender.titleLabel?.text == "," && showResultLAbel.text!.contains(".") {
                return
            } else if sender.titleLabel?.text == "," {
                sender.titleLabel?.text = "."
            } else if sender.titleLabel?.text == "+/-" && showResultLAbel.text![showResultLAbel.text!.startIndex] == "-" {
                showResultLAbel.text?.remove(at: showResultLAbel.text!.startIndex)
                return
            } else if sender.titleLabel?.text == "+/-" {
                showResultLAbel.text?.insert("-", at:  showResultLAbel.text!.startIndex)
                return
            } else if sender.titleLabel?.text  == "⁒" {
                showResultLAbel.text = showResultLAbel.text?.replacingOccurrences(of: ",", with: ".")
                let doubleForProchent = Double(showResultLAbel.text!)!
                let dod = doubleForProchent / 100
                showResultLAbel.text = String(dod)
                return
            }
            showResultLAbel.text = showResultLAbel.text! + (sender.titleLabel?.text)!
            if actionBool == true {
            showResultLAbel.text?.remove(at: showResultLAbel.text!.startIndex)
            secondOperand = Double(showResultLAbel.text!) ?? 0.0
            actionBool = false
            }
        }
    }
    @IBAction func clickButtonAction(_ sender: UIButton) {
        if showResultLAbel.text != "0" && sender.titleLabel?.text != "AC" && sender.titleLabel?.text != "=" {
            
            firstOperand = Double(showResultLAbel.text!) ?? 0.0
            
            if sender.titleLabel?.text == "÷" {
                showResultLAbel.text = "÷"
            } else if sender.titleLabel?.text  == "x" {
                showResultLAbel.text = "x"
            } else if sender.titleLabel?.text  == "-" {
                showResultLAbel.text = "-"
            } else if sender.titleLabel?.text  == "+" {
                showResultLAbel.text = "+"
            }
            actionToDo = sender.titleLabel!.text!
            actionBool = true
            
        } else if sender.titleLabel?.text == "=" {
            if actionToDo == "÷"{
                showResultLAbel.text = String(firstOperand / secondOperand)
            } else if actionToDo == "x" {
                showResultLAbel.text = String(firstOperand * secondOperand)
            } else if actionToDo == "-" {
                showResultLAbel.text = String(firstOperand - secondOperand)
            } else if actionToDo == "+" {
                showResultLAbel.text = String(firstOperand + secondOperand)
            }
            showResultLAbel.text = showResultLAbel.text?.replacingOccurrences(of: ".", with: ",")
        } else if sender.titleLabel?.text == "AC" {
            showResultLAbel.text = "0"
            firstOperand = 0
            secondOperand = 0
            
        }
    }
    

}

