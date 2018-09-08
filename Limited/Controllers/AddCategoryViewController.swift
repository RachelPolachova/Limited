//
//  AddCategoryViewController.swift
//  Limited
//
//  Created by Ráchel Polachová on 7.9.18.
//  Copyright © 2018 Rachel Polachova. All rights reserved.
//

import UIKit

protocol SideAddDelegate {
    func categoryAdded(name: String, color: UIColor)
}

class AddCategoryViewController: UIViewController  {
    
    
    @IBOutlet weak var nameTextField: UITextField?
    
    var addDelegate : SideAddDelegate!
    let array = ["1", "2", "3", "4", "5", "6"]
    
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var displayLabel: UILabel!
    var redColor : Float = 0
    var greenColor : Float = 0
    var blueColor : Float = 0
    var categoryColor = UIColor(red: 128, green: 128, blue: 128, alpha: 1.0)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().backgroundColor = UIColor.green
        // Do any additional setup after loading the view.
    }


    @IBAction func addDoneButtonPressed(_ sender: UIButton) {
        
        
        if let name = nameTextField?.text, !name.isEmpty {
            addDelegate.categoryAdded(name: nameTextField!.text!, color: categoryColor)
            dismiss(animated: true, completion: nil)

        } else {

            let alert = UIAlertController(title: "Name your category", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { (alert) in }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)

        }
        
//        addDelegate.categoryAdded(name: nameTextField.text!)
        
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func redSliderAction(_ sender: UISlider) {
        changeColor()
    }
    
    @IBAction func greenSliderAciton(_ sender: UISlider) {
        changeColor()
    }
    @IBAction func blueSliderAction(_ sender: UISlider) {
        changeColor()
    }
    
    func changeDisplayLabelColor() {
        displayLabel.backgroundColor = UIColor(red: CGFloat(redColor), green: CGFloat(greenColor), blue: CGFloat(blueColor), alpha: 1.0)
        changeLabelNumbers()
        categoryColor = displayLabel.backgroundColor!
    }
    
    func changeColor() {
        redColor = redSlider.value
        greenColor = greenSlider.value
        blueColor = blueSlider.value
        changeDisplayLabelColor()
    }
    
    func changeLabelNumbers() {
        let rounderRed = String(format: "%0.0f", (redColor * 255))
        let roundedGreen = String(format: "%0.0f", (greenColor * 255))
        let roundedBlue = String(format: "%0.0f", (blueColor * 255))
        
        redLabel.text = "Red: \(rounderRed)"
        greenLabel.text = "Green: \(roundedGreen)"
        blueLabel.text = "Blue: \(roundedBlue)"
        
    }
    
}


