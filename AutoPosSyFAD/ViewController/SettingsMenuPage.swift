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
    @IBOutlet var settingTableView: UITableView!
    @IBOutlet weak var chooseDateButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var applyFilters: UIButton!
    @IBOutlet weak var dropFilters: UIButton!
    
    
    @IBOutlet weak var flagsController: UISegmentedControl!
    @IBOutlet weak var positionButtonsView: UIView!
    @IBOutlet var positionButtons: [UIButton]!
    
    @IBOutlet var currentPosSliders: [UISlider]!
    @IBOutlet var currentPosLabels: [UILabel]!
    
    @IBOutlet var sortControllers: [UISegmentedControl]!
    
    private let webSocketData = ModelsHolder.instance.webSocketData
    private let sliderStep: Float = 10
    private var currentDateButton: UIButton?
    var separatorID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTableView.tableFooterView?.isHidden = false
        for btn in dateButtons {
            btn.setTitle((datePicker.date).stringValue, for: .normal)
        }
        datePicker.isEnabled = false
        
        //set titles color
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        //set custom style for items
        for btn in dateButtons {
            AppStyle().activeCustomButton(btn)
        }
        AppStyle().activeCustomButton(applyFilters)
        AppStyle().activeCustomButton(dropFilters)
        AppStyle().unactiveCustomButton(chooseDateButton)
        AppStyle().customizationSegmentController(positionButtons, positionButtonsView)
    }
    
   
    @IBAction func applyFiltersButtonTapped(_ sender: Any) {
        let minDate = dateButtons[0].titleLabel!.text!.dateValue
        let maxDate = dateButtons[1].titleLabel!.text!.dateValue
        let startTime = Int64(minDate.timeIntervalSince1970)
        let endTime = Int64(maxDate.timeIntervalSince1970)
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
        
        let filter = FiltersParameters(minDate: startTime,
                                                maxDate: endTime,
                                                flagType: flagType,
                                                flagPositions: flagPositions!,
                                                minCurProbability: Double(minCurProbability),
                                                maxCurProbability: Double(maxCurProbability))
        var timeSort: Int?
        var posSort: Int?
        var probSort: Int?
        for typeSort in sortControllers {
            switch typeSort.tag {
            case 0:
                timeSort = typeSort.selectedSegmentIndex
            case 1:
                posSort = typeSort.selectedSegmentIndex
            case 2:
                probSort = typeSort.selectedSegmentIndex
            default:
                break
            }

        }
        let sort = SortParameters(time: timeSort!, position: posSort!, probability: probSort!)
        guard (separatorID != nil) else {
            return
        }
        if webSocketData.connect! {
            webSocketData.unsubscribeRequest(separatorID!)
            webSocketData.connect = false
        }
        webSocketData.historicalRequest(filter, sort, separatorID!)
    }
    
    @IBAction func dropFiltersButtonTapped(_ sender: Any) {
        if !webSocketData.connect! {
            webSocketData.subscribeRequest(separatorID!)
            webSocketData.connect = true
        }
        
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
        let currentDate = datePicker!.date.stringValue
        
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
        let currentDate = datePicker!.date.stringValue
        
        switch currentDateButton!.tag {
        case 0:
            if currentDate.dateValue > dateButtons[1].titleLabel!.text!.dateValue { break } //compare
            return true
        case 1:
            if currentDate.dateValue < dateButtons[0].titleLabel!.text!.dateValue { break } //compare
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
    
    @IBAction func filterSegmentControllerTapped(_ sender: Any) {
        let segmentController = sender as! UISegmentedControl
        for controller in sortControllers {
            if controller == segmentController { continue }
            if controller.selectedSegmentIndex == 0 {
                controller.selectedSegmentIndex = 1
            }
        }
    }
    
}
