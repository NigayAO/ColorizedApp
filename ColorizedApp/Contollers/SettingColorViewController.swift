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
    var activeTextField: UITextField?
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        redTextField.delegate = self
        greenTextField.delegate = self
        blueTextField.delegate = self
        
        customization()
        initialSet()
        addObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
        
        guard let number = Double(sender.text!) else { return }
        
        if number > 1 {
            showAlert(textField: sender)
        } else {
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
        }
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
    
    private func initialSet() {
        redTextField.text = "0.00"
        greenTextField.text = "0.00"
        blueTextField.text = "0.00"
        
        let red = chooseColor.red
        let green = chooseColor.green
        let blue = chooseColor.blue
        
        setSliderValue(red: red, green: green, blue: blue)
        
        toolbar(textField: redTextField)
        toolbar(textField: greenTextField)
        toolbar(textField: blueTextField)
        
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

//MARK: - TextFielDelegate

extension SettingColorViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
}

//MARK: - Toolbar
extension SettingColorViewController {
    func toolbar(textField: UITextField) {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDone))
        
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
            textField.text = "1.0"
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
}

//MARK: - Move keyboard

extension SettingColorViewController {
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        view.frame.origin.y = 0 - keyboardSize.height
    }
    
    @objc private func keyboardWillHide() {
        view.frame.origin.y = 0
    }
}


