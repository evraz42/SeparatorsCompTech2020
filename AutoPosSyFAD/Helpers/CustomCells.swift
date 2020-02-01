//
//  CustomCell.swift
//  AutoPosSyFAD
//
//  Created by Madara2hor on 29.01.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

class MainPageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImg: UIImageView!
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var probability: UILabel!
    
}

class SeparatorDataCell: UITableViewCell {
    
    @IBOutlet weak var cellData: UILabel!
    
}

