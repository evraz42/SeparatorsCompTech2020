//
//  CustomSegmentController.swift
//  AutoPosSyFAD
//
//  Created by Madara2hor on 29.01.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

class AppStyle {
    
    let customColor = UIColor(red: 100/255, green: 151/255, blue: 219/255, alpha: 1)
    
    func customizationSegmentController(_ positionsController: [UIButton], _ positionsView: UIView) {
        for btn in positionsController {
            activeCustomButton(btn)
        }
        positionsView.layer.cornerRadius = 10
        positionsView.clipsToBounds = true
    }
    
    func activeCustomButton(_ btn: UIButton) {
        btn.backgroundColor = customColor
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 7
        btn.clipsToBounds = true
    }
    
    func unactiveCustomButton(_ btn: UIButton) {
        btn.backgroundColor = UIColor.systemFill
        btn.setTitleColor(.lightGray, for: .normal)
        btn.layer.cornerRadius = 7
        btn.clipsToBounds = true
    }
    
    func customControllerButton(_ btn: UIButton) {
        btn.layer.cornerRadius = 10
        btn.clipsToBounds = true
    }
}
