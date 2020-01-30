//
//  Data.swift
//  AutoPosSyFAD
//
//  Created by Madara2hor on 29.01.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation

class DataProcessing {
    var separatorsData: [Separator] = []
    
    func getDataFromDatabase() {
        let testSepData1 = SeparatorData(date: "29.01.2020", type: "Left", position: 4, currentProbability: 98.32, otherProbability: 3.74, img: "menu")
        let testSepData2 = SeparatorData(date: "29.01.2020", type: "Right", position: 1, currentProbability: 97.94, otherProbability: 1.22, img: "logo")
        let testSep2 = Separator()
        testSep2.name = "Separator_1"
        testSep2.data = [testSepData1, testSepData2]
        let testSep1 = Separator()
        testSep1.name = "Separator_2"
        testSep1.data = [testSepData1, testSepData2]
        separatorsData.append(testSep1)
        separatorsData.append(testSep2)
    }
    
}
