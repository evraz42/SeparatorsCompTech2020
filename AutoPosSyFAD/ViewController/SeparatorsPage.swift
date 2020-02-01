//
//  SeparatorsPage.swift
//  AutoPosSyFAD
//
//  Created by Madara2hor on 30.01.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

class SeparatorsPage: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var separatorsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let cellReuseIdentifier = "SeparatorDataCell"
    
    private var webSocketData: WebSocketDataWorking?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        separatorsTableView.delegate = self
        separatorsTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (webSocketData == nil) {
            activityIndicator.startAnimating()

            separatorsTableView.separatorStyle = .none

            OperationQueue.main.addOperation() {
                Thread.sleep(forTimeInterval: 2)
                self.webSocketData = ModelsHolder.instance.webSocketData
                self.webSocketData?.initConnection()
                self.webSocketData?.responseData() //Delet after testing connection

                self.activityIndicator.stopAnimating()

                self.separatorsTableView.separatorStyle = .singleLine
                self.separatorsTableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return webSocketData?.separatorsData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SeparatorDataCell = self.separatorsTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! SeparatorDataCell
        
        let separatorsData = webSocketData?.separatorsData
        cell.cellData.text = separatorsData?[indexPath.row].name
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSeparatorData" {
            if let indexPath = self.separatorsTableView.indexPathForSelectedRow {
                let controller = segue.destination as! SeparatorDataPage
                OperationQueue.main.addOperation {
                    controller.separator = self.webSocketData?.separatorsData[indexPath.row]
                }
            }
        }
    }

}
