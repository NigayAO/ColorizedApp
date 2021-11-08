//
//  ViewController.swift
//  ColorizedApp
//
//  Created by Alik Nigay on 05.11.2021.
//

import UIKit

protocol SettingColorViewControllerDelegate {
    func installColor(for color: UIColor)
}

class ResultViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settinColorVC = segue.destination as? SettingColorViewController else { return }
        settinColorVC.currentColor = view.backgroundColor
        settinColorVC.delegate = self
    }
}

//MARK: - SettingColorViewControllerDelegate

extension ResultViewController: SettingColorViewControllerDelegate {
    func installColor(for color: UIColor) {
        view.backgroundColor = color
    }
}

//MARK: - Extension for UIColor

extension UIColor {
    var colorComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        guard let components = self.cgColor.components else { return nil }

        return (
            red: components[0],
            green: components[1],
            blue: components[2],
            alpha: components[3]
        )
    }
}
