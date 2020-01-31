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
    let url = URL(string: "ws://1.1.1.1/api/v1")
    let urlSession = URLSession(configuration: .default)
    
    
    func openConnection(){
        let webSocketTask = urlSession.webSocketTask(with: url!)
        webSocketTask.resume()
    }
    
    func getDataFromDatabase() {
        let testSepData1 = SeparatorData(date: "24.01.2020",
                                         type: 0,
                                         position: 4,
                                         currentProbability: 98.32,
                                         img: "logo")
        let testSepData2 = SeparatorData(date: "29.01.2020",
                                         type: 1,
                                         position: 1,
                                         currentProbability: 97.94,
                                         img: "logo")
        let testSep2 = Separator()
        testSep2.name = "Сепаратор_2"
        testSep2.data = [testSepData1]
        let testSep1 = Separator()
        testSep1.name = "Сепаратор_1"
        testSep1.data = [testSepData1, testSepData2]
        separatorsData.append(testSep1)
        separatorsData.append(testSep2)
    }
    
    func requestSending(_ request: RequestParameters) {
        
    }
    
}
