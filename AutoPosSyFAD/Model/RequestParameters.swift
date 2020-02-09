//
//  SettingParameters.swift
//  AutoPosSyFAD
//
//  Created by Madara2hor on 31.01.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation

struct RequestParameters {
    let minDate: Int
    let maxDate: Int
    let flagType: Int
    let flagPositions: [Int]
    let minCurProbability: Int
    let maxCurProbability: Int
}
