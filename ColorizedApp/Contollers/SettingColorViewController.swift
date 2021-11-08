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
    
    @IBOutlet weak var button: UIButton!
    
    var currentColor: UIColor!
    var delegate: SettingColorViewControllerDelegate!
    var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        redTextField.delegate = self
        greenTextField.delegate = self
        blueTextField.delegate = self
        displayView.backgroundColor = currentColor
        startSet()
        updateUI()
        customization()
    }
    
    @IBAction func applyPressed(_ sender: UIButton) {
        delegate.installColor(for: displayView.backgroundColor ?? .clear)
        dismiss(animated: true)
    }
    
    @IBAction func moveSlider(_ sender: UISlider) {
        updateUI()
    }
}

//MARK: - Private function

extension SettingColorViewController {
    private func customization() {
        button.layer.cornerRadius = 10
        displayView.layer.cornerRadius = 15
        setTrakTint()
    }
    
    private func startSet() {
        let color = currentColor
        
        redSlider.value = Float(color?.colorComponents?.red ?? 1)
        greenSlider.value = Float(color?.colorComponents?.green ?? 1)
        blueSlider.value = Float(color?.colorComponents?.blue ?? 1)
        
    }
    
    private func setTrakTint() {
        redSlider.minimumTrackTintColor = .systemRed
        greenSlider.minimumTrackTintColor = .systemGreen
        blueSlider.minimumTrackTintColor = .systemBlue
    }
    
    private func setSliderValue(red: CGFloat, green: CGFloat, blue: CGFloat) {
        redSlider.value = Float(red)
        greenSlider.value = Float(green)
        blueSlider.value = Float(blue)
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
    
    private func updateUI() {
        let red = redSlider.value
        let green = greenSlider.value
        let blue = blueSlider.value
        
        setValueForLabel(red: red, green: green, blue: blue)
        setValueForTextField(red: red, green: green, blue: blue)
        displayView.backgroundColor = UIColor(red: CGFloat(red),
                                              green: CGFloat(green),
                                              blue: CGFloat(blue),
                                              alpha: 1)
    }
}

//MARK: - TextFielDelegate

extension SettingColorViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        toolbar(textField: textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let number = Double(textField.text!) else { return }
        if number > 1 {
            showAlert(textField: textField)
        } else {
            guard let value = textField.text else { return }
            switch textField.tag {
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
        }
        updateUI()
    }
}

//MARK: - Toolbar
extension SettingColorViewController {
    func toolbar(textField: UITextField) {
        let toolbar = UIToolbar()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: self,
                                            action: nil)
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .done,
                                         target: self,
                                         action: #selector(didTapDone))
        
        toolbar.items = [flexibleSpace, doneButton]
        toolbar.sizeToFit()
        textField.inputAccessoryView = toolbar
    }
    
    @objc private func didTapDone() {
        view.endEditing(true)
    }
}

//MARK: - AlertController

extension SettingColorViewController {
    
    private func showAlert(textField: UITextField) {
        let alert = UIAlertController(title: "Error!", message: "Value can't be more than 1", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel) { _ in
            textField.text = "1.00"
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
}
