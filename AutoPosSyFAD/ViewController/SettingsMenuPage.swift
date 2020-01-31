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
    @IBOutlet weak var positionButtonsView: UIView!
    @IBOutlet var positionButtons: [UIButton]!
    
    @IBOutlet var currentPosSliders: [UISlider]!
    @IBOutlet var currentPosLabels: [UILabel]!
    
    private let dataProc = ModelsHolder.instance.dataProcessing
    var currentDateButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.isEnabled = false
        //set titles color
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        //set custom style for items
        AppStyle().customizationButton(chooseDateButton)
        AppStyle().customizationSegmentController(positionButtons, positionButtonsView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //send request to DB
    }
    
    @IBAction func positionButtonTapped(_ sender: Any) {
        let senderButton = sender as! UIButton
        
        for button in positionButtons {
            if button != senderButton {
                continue
            }
            setButtonState(senderButton)
        }
    }
    
    //change button tag and colour to show activity/inactive state
    func setButtonState(_ button: UIButton) {
        var count = 0
        for btn in positionButtons {
            if btn.tag == 1 {
                count += 1
            }
        }
        if button.tag == 1 && count != 1 {
            button.backgroundColor = .secondarySystemFill
            button.tag = 0
        }
        else {
            button.backgroundColor = .systemIndigo
            button.tag = 1
        }
        
    }
    //don't let sliders cross each other
    @IBAction func currentPosSlidersTapped(_ sender: Any) {
        let currentSlider = sender as! UISlider
        for slider in currentPosSliders {
            switch currentSlider.tag {
                case 0:
                    if currentSlider.value >= slider.value {
                        currentSlider.setValue(slider.value, animated: false)
                    }
                case 1:
                      if currentSlider.value <= slider.value {
                          currentSlider.setValue(slider.value, animated: false)
                      }
                default:
                    break
            }
        }
        let currentValue = Int(currentSlider.value)
        currentPosLabels[currentSlider.tag].text = String(currentValue) + "%"
        
    }
    
    @IBAction func dateButtonTapped(_ sender: Any) {
        currentDateButton = sender as? UIButton
        
        chooseDateButton.isEnabled = true
        chooseDateButton.backgroundColor = .systemIndigo
        
        for btn in dateButtons {
            btn.isEnabled = false
            btn.setTitleColor(.secondarySystemFill, for: .normal)
        }
        
        datePicker.isEnabled = true
    }
    //make sure the dates are coorect
    @IBAction func chooseDateButtonTapped(_ sender: Any) { //This is not SOLID ;c
        
        var confirmDate = false
        //take current data from date picker and format them
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        formatter.timeZone = .none
        let currentDate = formatter.string(from: datePicker!.date)
        
        confirmDate = compareDate(currentDate)
        
        if !confirmDate { return }
        //else we change date and data
        for btn in dateButtons {
            btn.isEnabled = true
            if currentDateButton == btn {
                btn.setTitle(currentDate, for: .normal)
            }
            btn.setTitleColor(.systemIndigo, for: .normal)
        }
        
        datePicker.isEnabled = false
        
        chooseDateButton.isEnabled = false
        chooseDateButton.backgroundColor = .secondarySystemFill
        
    }
    
    func compareDate (_ currentDate: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        formatter.timeZone = .none
        let currentDate = formatter.string(from: datePicker!.date)
        
        switch currentDateButton!.tag {
        case 0:
            if formatter.date(from: currentDate)! > formatter.date(from: dateButtons[1].titleLabel!.text!)! { break } //compare
            return true
        case 1:
            if formatter.date(from: currentDate)! < formatter.date(from: dateButtons[0].titleLabel!.text!)! { break } //compare
            return true
        default:
            break
        }
        return false
    }
    
}

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}
