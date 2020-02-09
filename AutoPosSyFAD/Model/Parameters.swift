//
//  SettingParameters.swift
//  AutoPosSyFAD
//
//  Created by Madara2hor on 31.01.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation

struct FiltersParameters {
    let minDate: Int64
    let maxDate: Int64
    let flagType: Int
    let flagPositions: [Int]
    let minCurProbability: Double
    let maxCurProbability: Double
}

struct SortParameters {
    let time: Int
    let position: Int
    let probability: Int
}
