//
//  SettingColorViewController.swift
//  ColorizedApp
//
//  Created by Alik Nigay on 05.11.2021.
//

import UIKit

class SettingColorViewController: UIViewController {
    
    @IBOutlet weak var displayView: UIView!
    
    @IBOutlet weak var redValue: UILabel!
    @IBOutlet weak var greenValue: UILabel!
    @IBOutlet weak var blueValue: UILabel!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var redTextField: UITextField!
    @IBOutlet weak var greenTextField: UITextField!
    @IBOutlet weak var blueTextField: UITextField!
    
    var chooseColor: ChooseColor!
    var delegate: SettingColorViewControllerDelegate!
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        redTextField.delegate = self
        greenTextField.delegate = self
        blueTextField.delegate = self
        
        customization()
        initialSet()
    }
    
    @IBAction func applyPressed(_ sender: UIButton) {
        delegate.installColor(for: chooseColor)
        dismiss(animated: true)
    }
    
    @IBAction func moveSlider(_ sender: UISlider) {
        updateUI()
    }
    
    @IBAction func editWithTextField(_ sender: UITextField) {
        
        redTextField.tag = 0
        greenTextField.tag = 1
        blueTextField.tag = 2
        
        guard let value = sender.text else { return }
        
        switch sender.tag {
        case 0:
            redSlider.value = Float(value) ?? 0
            redValue.text = value
        case 1:
            greenSlider.value = Float(value) ?? 0
            greenValue.text = value
        case 2:
            blueSlider.value = Float(value) ?? 0
            blueValue.text = value
        default:
            print("Not work")
        }
        updateUI()
    }
    
    private func customization() {
        button.layer.cornerRadius = 10
        displayView.layer.cornerRadius = 15
        setTrakTint()
    }
    
    private func initialSet() {
        redTextField.text = "0.00"
        greenTextField.text = "0.00"
        blueTextField.text = "0.00"
        
        let red = chooseColor.red
        let green = chooseColor.green
        let blue = chooseColor.blue
        
        setSliderValue(red: red, green: green, blue: blue)
        
        updateUI()
    }
    
    private func setTrakTint() {
        redSlider.minimumTrackTintColor = .systemRed
        greenSlider.minimumTrackTintColor = .systemGreen
        blueSlider.minimumTrackTintColor = .systemBlue
    }
    
    private func setSliderValue(red: Float, green: Float, blue: Float) {
        redSlider.value = red
        greenSlider.value = green
        blueSlider.value = blue
    }
    
    private func setValueForLabel(red: Float, green: Float, blue: Float) {
        redValue.text = String(format: "%.2f", red)
        greenValue.text = String(format: "%.2f", green)
        blueValue.text = String(format: "%.2f", blue)
    }
    
    private func setValueForTextField(red: Float, green: Float, blue: Float) {
        redTextField.text = String(format: "%.2f", red)
        greenTextField.text = String(format: "%.2f", green)
        blueTextField.text = String(format: "%.2f", blue)
    }
    
    private func updateChooseColor(red: Float, green: Float, blue: Float) {
        chooseColor.red = red
        chooseColor.green = green
        chooseColor.blue = blue
    }
    
    private func updateUI() {
        
        let red = redSlider.value
        let green = greenSlider.value
        let blue = blueSlider.value
        
        updateChooseColor(red: red, green: green, blue: blue)
        setValueForLabel(red: red, green: green, blue: blue)
        setValueForTextField(red: red, green: green, blue: blue)
        
        displayView.backgroundColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
    }
    
}

//MARK: - extension for TextFiel

extension SettingColorViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
