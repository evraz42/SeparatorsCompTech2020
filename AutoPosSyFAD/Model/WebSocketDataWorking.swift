//
//  ResponseData.swift
//  AutoPosSyFAD
//
//  Created by Madara2hor on 01.02.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation

protocol WebSocketDataDelegate {
    func getSeparatorData(for: Separator)
}

protocol TableViewDataDelegate {
    func updateTableViewData()
    func clearTableViewData()
}

class WebSocketDataWorking: WebSocketConnectionDelegate {
    
    var webSocketConnection: WebSocketConnection!
    var webSocketDataDelegate: WebSocketDataDelegate?
    var tableViewDataDelegate: TableViewDataDelegate?
    
    var separatorsData: [Separator] = []
    var connect: Bool?
    var request: String?
    var nonce: Int = 0
    
    func initConnection() {
        webSocketConnection = WebSocketTaskConnection(url: URL(string: "ws://35.169.150.209:2092/api/v1")!)
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
        nonce += 1
        webSocketConnection.send(text: request!)
    }
    
    func subscribeRequest(_ deviceID: String) {
        request = """
        {
            \"type\": \"subscribe\",
            \"nonce\": \(nonce),
            \"id_device\": \"\(deviceID)\"
        }
        """
        nonce += 1
        webSocketConnection.send(text: request!)
    }
    
    func unsubscribeRequest(_ deviceID: String) {
        request = """
        {
            \"type\": \"unsubscribe\",
            \"nonce\": \(nonce),
            \"id_device\": \"\(deviceID)\"
        }
        """
        nonce += 1
        webSocketConnection.send(text: request!)
    }
    
    func historicalRequest(_ filter: FiltersParameters, _ sort: SortParameters, _ deviceID: String) {
        request = """
        {
            \"type\": \"historical\",
            \"nonce\": \(nonce),
            \"filters\":
            {
                \"id_device\": \"\(deviceID)\",
                \"start_time\": \(filter.minDate*1000),
                \"end_time\": \(filter.maxDate*1000),
                \"type_flag\": \(filter.flagType),
                \"positions\": \(filter.flagPositions),
                \"probability_current_max\": \(filter.maxCurProbability),
                \"probability_current_min\": \(filter.minCurProbability)
            },
            \"sort\": {
                \"time\": \(sort.time),
                \"position\": \(sort.position),
                \"probability\": \(sort.probability)
            },
            \"limit\": 500,
            \"offset\": 0
        }
        """
        nonce += 1
        webSocketConnection.send(text: request!)
    }
    
    
    func onConnected(connection: WebSocketConnection) {
        tableViewDataDelegate?.updateTableViewData()
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
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let dictonary =  try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String:AnyObject]
                if let responseDictionary = dictonary {
                    guard let msgType = responseDictionary["type"] else {
                        return
                    }
                    switch msgType as? String {
                    case "info":
                        let body = responseDictionary["body"] as! [String: AnyObject]
                        print(body["status"] as Any)
                    case "error":
                        let body = responseDictionary["body"] as! [String: AnyObject]
                        let message = body["message"] as! String
                        print(message)
                    case "devices_list":
                        let body = responseDictionary["body"] as! [String: AnyObject]
                        let devices = body["devices"] as! [AnyObject]
                        for device in devices {
                            let newDevice = device as! [String: AnyObject]
                            let separator = Separator()
                            separator.ID = newDevice["id_device"] as? String
                            separator.name = newDevice["name_device"] as? String
                            separator.number = newDevice["number_device"] as? Int
                            separatorsData.append(separator)
                        }
                    case "data_message":
                        if !validData(responseDictionary) { break }
                        let deviceID = responseDictionary["id_device"] as? String
                        let separatorData = SeparatorData(date: responseDictionary["time"] as! Int64,
                                                          type: responseDictionary["type_flag"] as! Int,
                                                          position: responseDictionary["current_position"] as! Int,
                                                          currentProbability: responseDictionary["current_probability"] as! Double,
                                                          img: responseDictionary["image_path"] as! String)
                        for separator in separatorsData {
                            if separator.ID! != deviceID { continue }
                            if separator.data == nil {
                                separator.data = [separatorData]
                            } else {
                                separator.data?.insert(separatorData, at: 0)
                            }
                            self.webSocketDataDelegate?.getSeparatorData(for: separator)
                            self.tableViewDataDelegate?.updateTableViewData()
                        }
                    case "historical":
                        let body = responseDictionary["body"] as! [String: AnyObject]
                        let historicalSeparatorData = body["flags"] as! [AnyObject]
                        var separator: Separator?
                        if historicalSeparatorData.count == 0 {
                            self.tableViewDataDelegate?.clearTableViewData()
                            return
                        }
                        let oldData = historicalSeparatorData[0]
                        let separatorID = oldData["id_device"] as! String
                        for sep in separatorsData {
                            if sep.ID! != separatorID { continue }
                            sep.data = nil
                            separator = sep
                        }
                        
                        for historicalRecord in historicalSeparatorData {
                            let oldSeparatorData = historicalRecord as! [String: AnyObject]
                            if !validData(oldSeparatorData) { break }
                            let separatorData = SeparatorData(date: oldSeparatorData["time"] as! Int64,
                                                              type: oldSeparatorData["type_flag"] as! Int,
                                                              position: oldSeparatorData["current_position"] as! Int,
                                                              currentProbability: oldSeparatorData["current_probability"] as! Double,
                                                              img: oldSeparatorData["image_path"] as! String)
                            
                            if separator!.data == nil {
                                separator!.data = [separatorData]
                            } else {
                                separator!.data?.append(separatorData)
                            }
                        }
                        
                        self.webSocketDataDelegate?.getSeparatorData(for: separator!)
                        self.tableViewDataDelegate?.updateTableViewData()
                    default:
                        break
                    }
                }
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
    func onMessage(connection: WebSocketConnection, data: Data) {
        print("Data message: \(data)")
    }
    
    func validData(_ responseDictionary: [String: Any]) -> Bool {
        guard (responseDictionary["id_device"] as? String) != nil else {
            print("Invalid device ID data")
            return false
        }
        guard (responseDictionary["time"] as? Int64) != nil else {
            print("Invalid time data")
            return false
        }
        guard (responseDictionary["type_flag"] as? Int) != nil else {
            print("Invalid flag type data")
            return false
        }
        guard (responseDictionary["current_position"] as? Int) != nil else {
            print("Invalid current position data")
            return false
        }
        guard (responseDictionary["current_probability"] as? Double) != nil else {
            print("Invalid current probability data ")
            return false
        }
        guard (responseDictionary["image_path"] as? String) != nil else {
            print("Invalid image path data")
            return false
        }
        return true
    }
    
}
