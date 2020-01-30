//
//  CustomSegmentController.swift
//  AutoPosSyFAD
//
//  Created by Madara2hor on 29.01.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

class AppStyle {
    
    func customizationSegmentController(_ positionsController: [UIButton], _ positionsView: UIView) {
        for btn in positionsController {
            btn.layer.cornerRadius = 10
            btn.clipsToBounds = true
        }
        positionsView.layer.cornerRadius = 10
        positionsView.clipsToBounds = true
    }
    
}
