//
//  MenuPageViewController.swift
//  AutoPosSyFAD
//
//  Created by Madara2hor on 28.01.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

class SettingsMenuPage: UITableViewController {

    
    @IBOutlet var dateButtons: [UIButton]!
    @IBOutlet weak var chooseDateButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var flagsController: UISegmentedControl!
    @IBOutlet weak var positionsControllerView: UIView!
    @IBOutlet var positionsController: [UIButton]!
    
    @IBOutlet var currentPosLabels: [UILabel]!
    
    @IBOutlet var otherPosLabels: [UILabel]!
    
    var tapChecker = Array(repeating: true, count: 7)
    var currentDateButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.isEnabled = false
        
        AppStyle().customizationSegmentController(positionsController, positionsControllerView)
    }
    
    @IBAction func positionControllerButtonTapped(_ sender: Any) {
        let btn = sender as! UIButton
        for button in positionsController {
            if btn == button {
                setButtonState(button.tag)
            }
        }
    }
    
    func setButtonState(_ element: Int) {
        if tapChecker[element] {
            positionsController[element].backgroundColor = .secondarySystemFill
            positionsController[element].titleLabel?.font = UIFont(name: "\(element)", size: 15)
            tapChecker[element] = false
        }
        else {
            positionsController[element].backgroundColor = .white
            positionsController[element].titleLabel?.font = UIFont(name: "\(element)", size: 17)
            tapChecker[element] = true
        }
    }
    
    @IBAction func currentPosSlidersTapped(_ sender: Any) {
        let slider = sender as! UISlider
        currentPosLabels[slider.tag].text = formatSliderValue(slider)
        
    }
    
    @IBAction func otherPosSlidersTapped(_ sender: Any) {
        let slider = sender as! UISlider
        otherPosLabels[slider.tag].text = formatSliderValue(slider)
    }
    
    func formatSliderValue(_ slider: UISlider) -> String {
        var value = String(format: "%.3f", slider.value)
        if Float(value) == 100 {
            value = "100"
        } else if Float(value) == 0 {
            value = "0"
        }
        let result = "\(value)%"
        return result
    }
    
    @IBAction func dateButtonTapped(_ sender: Any) {
        chooseDateButton.isEnabled = true
        for btn in dateButtons {
            btn.isEnabled = false
        }
        currentDateButton = sender as? UIButton
        datePicker.isEnabled = true
    }
    
    @IBAction func chooseDateButtonTapped(_ sender: Any) {
        chooseDateButton.isEnabled = false
        let choosedData = datePicker.date
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        for btn in dateButtons {
            btn.isEnabled = true
            if currentDateButton == btn {
                btn.setTitle(formatter.string(from: choosedData), for: .normal)
            }
        }
        datePicker.isEnabled = false
    }
}
