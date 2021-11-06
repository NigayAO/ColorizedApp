//
//  ViewController.swift
//  ColorizedApp
//
//  Created by Alik Nigay on 05.11.2021.
//

import UIKit

protocol SettingColorViewControllerDelegate {
    func installColor(for color: ChooseColor)
}

class ResultViewController: UIViewController {
    
    private var baseColor = ChooseColor(red: 0.5, green: 0.1, blue: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = baseColor.getColor()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settinColorVC = segue.destination as? SettingColorViewController else { return }
        settinColorVC.chooseColor = baseColor
        settinColorVC.delegate = self
    }
    
}

//MARK: - SettingColorViewControllerDelegate

extension ResultViewController: SettingColorViewControllerDelegate {
    func installColor(for color: ChooseColor) {
        baseColor.red = color.red
        baseColor.green = color.green
        baseColor.blue = color.blue
        
        view.backgroundColor = baseColor.getColor()
    }
}
