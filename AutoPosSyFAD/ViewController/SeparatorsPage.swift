//
//  SeparatorsPage.swift
//  AutoPosSyFAD
//
//  Created by Madara2hor on 30.01.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

class SeparatorsPage: UIViewController, UITableViewDelegate, UITableViewDataSource, WebSocketDataDelegate, TableViewDataDelegate {
    
    @IBOutlet weak var separatorsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let webSocketData = ModelsHolder.instance.webSocketData
    private let cellReuseIdentifier = "SeparatorDataCell"
    private var tappedSeparatorID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        separatorsTableView.delegate = self
        separatorsTableView.dataSource = self
        
        webSocketData.initConnection()
        webSocketData.tableViewDataDelegate = self
        webSocketData.webSocketDataDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (webSocketData.separatorsData.count == 0) {
            activityIndicator.startAnimating()

            separatorsTableView.separatorStyle = .none
            OperationQueue.main.addOperation() {
                Thread.sleep(forTimeInterval: 2)
                self.activityIndicator.stopAnimating()
                self.separatorsTableView.separatorStyle = .singleLine
                self.separatorsTableView.reloadData()
            }
        }
        guard (tappedSeparatorID) != nil else {
            return
        }
        webSocketData.unsubscribeRequest(tappedSeparatorID!)
        webSocketData.connect = false
        for separator in webSocketData.separatorsData {
            if separator.ID != tappedSeparatorID { continue }
            separator.data = nil
        }
    }
    
    func getSeparatorData(for: Separator) {
        print("getData")
    }
    
    func updateTableViewData() {
        OperationQueue.main.addOperation {
            self.activityIndicator.stopAnimating()
            self.separatorsTableView.separatorStyle = .singleLine
            self.separatorsTableView.reloadData()
        }
    }
    
    
    func clearTableViewData() {
        print("clear")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return webSocketData.separatorsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SeparatorDataCell = self.separatorsTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! SeparatorDataCell
        cell.cellData.text = webSocketData.separatorsData[indexPath.row].name
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSeparatorData" {
            if let indexPath = self.separatorsTableView.indexPathForSelectedRow {
                let controller = segue.destination as! SeparatorDataPage
                let separatorID = webSocketData.separatorsData[indexPath.row].ID
                controller.separatorIndex = indexPath.row
                tappedSeparatorID = webSocketData.separatorsData[indexPath.row].ID
                webSocketData.subscribeRequest(separatorID!)
                webSocketData.connect = true
            }
        }
    }

}
