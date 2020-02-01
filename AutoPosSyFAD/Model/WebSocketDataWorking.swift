//
//  ResponseData.swift
//  AutoPosSyFAD
//
//  Created by Madara2hor on 01.02.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation

class WebSocketDataWorking: WebSocketConnectionDelegate {
    
    var webSocketConnection: WebSocketConnection!
    
    var separatorsData: [Separator] = []
    
    var request: String?
    var nonce: Int = 0
    var requestID: LatestRequestID?
    
    func initConnection() {
        webSocketConnection = WebSocketTaskConnection(url: URL(string: "ws://1.1.1.1/api/v1")!)
        webSocketConnection.delegate = self
           
        webSocketConnection.connect()
        listOfDevicesRequest()
    }
        
    func listOfDevicesRequest () {
        request = """
        {
            \"type\": \"devices_list\",
            \"nonce\": \(nonce)
        }
        """
        requestID?.listOfDevices = nonce
        nonce += 1
        webSocketConnection.send(text: request!)
    }
    
    func subscribeRequest() {
        request = """
        {
            \"type\": \"subscribe\",
            \"nonce\": \(nonce)
            \"id_device\": int
        }
        """
        requestID?.subscribe = nonce
        nonce += 1
        webSocketConnection.send(text: request!)
    }
    
    func unsubscribeRequest() {
        request = """
        {
            \"type\": \"unsubscribe\",
            \"nonce\": \(nonce)
            \"id_device\": int
        }
        """
        requestID?.unsubscribe = nonce
        nonce += 1
        webSocketConnection.send(text: request!)
    }
    
    func historicalRequest(_ requestParam: RequestParameters) {
        request = """
        {
            \"type\": \"historical\",
            \"nonce\": \(nonce),
            \"filters\":
            {
                \"start_time\": \(requestParam.minDate),
                \"end_time\": \(requestParam.maxDate),
                \"type_flag\": \(requestParam.flagType),
                \"positions\": \(requestParam.flagPositions),
                \"probability_current_max\": \(requestParam.maxCurProbability),
                \"probability_current_min\": \(requestParam.minCurProbability)
            },
            \"sort\": {
                \"time\": 0,
                \"position\": 0,
                \"probability\": 0,
            },
            \"limit\": 20,
            \"offset\": 0
        }
        """
        requestID?.historical = nonce
        nonce += 1
        webSocketConnection.send(text: request!)
    }
    
    
    func onConnected(connection: WebSocketConnection) {
        print("Connected")
    }
    
    func onDisconnected(connection: WebSocketConnection, error: Error?) {
        if let error = error {
            print("Disconnected with error:\(error)")
        } else {
            print("Disconnected normally")
        }
    }
    
    func onError(connection: WebSocketConnection, error: Error) {
        print("Connection error:\(error)")
    }
    
    func onMessage(connection: WebSocketConnection, text: String) {
        print("Text message: \(text)")
    }
    
    func onMessage(connection: WebSocketConnection, data: Data) {
        print("Data message: \(data)")
        let id = 0
        switch id {
        case requestID?.listOfDevices:
            break
        case requestID?.historical:
            break
        case requestID?.subscribe:
            break
        case requestID?.unsubscribe:
            break
        default:
            break
        }
        
    }
    
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func responseData() {
        let testSepData1 = SeparatorData(date: "24.01.2020",
                                         type: 0,
                                         position: 4,
                                         currentProbability: 98,
                                         img: "https://assets.bwbx.io/images/users/iqjWHBFdfxIU/iKIWgaiJUtss/v2/1000x-1.jpg")
        let testSepData2 = SeparatorData(date: "29.01.2020",
                                         type: 1,
                                         position: 1,
                                         currentProbability: 97,
                                         img: "https://i.barkpost.com/wp-content/uploads/2015/02/featmeme.jpg?q=70&fit=crop&crop=entropy&w=808&h=500")
        let testSep2 = Separator()
        testSep2.name = "Сепаратор_2"
        testSep2.data = [testSepData1]
        let testSep1 = Separator()
        testSep1.name = "Сепаратор_1"
        testSep1.data = [testSepData1, testSepData2]
        separatorsData.append(testSep1)
        separatorsData.append(testSep2)
    }
    
}
