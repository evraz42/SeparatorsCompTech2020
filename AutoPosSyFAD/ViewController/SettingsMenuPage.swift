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
    
    private let webSocketData = ModelsHolder.instance.webSocketData
    private let sliderStep: Float = 10
    private var currentDateButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.isEnabled = false
        //set titles color
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        //set custom style for items
        for btn in dateButtons { AppStyle().activeCustomButton(btn) }
        AppStyle().unactiveCustomButton(chooseDateButton)
        AppStyle().customizationSegmentController(positionButtons, positionButtonsView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //send request to DB
        let minDate = stringToDate(dateButtons[0].titleLabel!.text!)
        let maxDate = stringToDate(dateButtons[1].titleLabel!.text!)
        let startTime = Int(minDate.timeIntervalSince1970)
        let endTime = Int(maxDate.timeIntervalSince1970)
        let flagType = flagsController.selectedSegmentIndex
        var flagPositions: [Int]?
        for btn in positionButtons {
            if btn.tag == 0 { continue }
            if flagPositions != nil {
                flagPositions?.append(Int(btn.titleLabel!.text!)!)
            }
            else {
                flagPositions = [Int(btn.titleLabel!.text!)!]
            }
        }
        let minCurProbability = Int(currentPosSliders[0].value)
        let maxCurProbability = Int(currentPosSliders[1].value)
        
        let requestParam = RequestParameters(minDate: startTime,
                                             maxDate: endTime,
                                             flagType: flagType,
                                             flagPositions: flagPositions!,
                                             minCurProbability: minCurProbability,
                                             maxCurProbability: maxCurProbability)
        webSocketData.historicalRequest(requestParam)
    }
    
    
    @IBAction func dateButtonTapped(_ sender: Any) {
        currentDateButton = sender as? UIButton
        
        chooseDateButton.isEnabled = true
        AppStyle().activeCustomButton(chooseDateButton)
        
        for btn in dateButtons {
            btn.isEnabled = false
            AppStyle().unactiveCustomButton(btn)
        }
        
        datePicker.isEnabled = true
    }
    //make sure the dates are coorect
    @IBAction func chooseDateButtonTapped(_ sender: Any) { //This is not SOLID ;c
        var confirmDate = false
        //take current data from date picker and format them
        let currentDate = dateToString(datePicker!.date)
        
        confirmDate = compareDate(currentDate)
        
        if !confirmDate { return }
        //else we change date and data
        for btn in dateButtons {
            btn.isEnabled = true
            if currentDateButton == btn {
                btn.setTitle(currentDate, for: .normal)
            }
            AppStyle().activeCustomButton(btn)
        }
        
        datePicker.isEnabled = false
        
        chooseDateButton.isEnabled = false
        AppStyle().unactiveCustomButton(chooseDateButton)
        
    }
    
    func compareDate (_ currentDate: String) -> Bool {
        let currentDate = dateToString(datePicker!.date)
        
        switch currentDateButton!.tag {
        case 0:
            if stringToDate(currentDate) > stringToDate(dateButtons[1].titleLabel!.text!) { break } //compare
            return true
        case 1:
            if stringToDate(currentDate) < stringToDate(dateButtons[0].titleLabel!.text!) { break } //compare
            return true
        default:
            break
        }
        return false
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
            button.backgroundColor = AppStyle().customColor
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
        let roundedStepValue = round(currentSlider.value / sliderStep) * sliderStep
        currentSlider.value = roundedStepValue
        let currentValue = Int(currentSlider.value)
        currentPosLabels[currentSlider.tag].text = String(currentValue) + "%"
        
    }
    
    func stringToDate(_ textDate: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        formatter.timeZone = .none
        return formatter.date(from: textDate)!
    }
    
    func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        formatter.timeZone = .none
        return formatter.string(from: date)
    }
}

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}
