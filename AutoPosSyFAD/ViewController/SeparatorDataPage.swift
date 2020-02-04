//
//  MainPageViewController.swift
//  AutoPosSyFAD
//
//  Created by Madara2hor on 29.01.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

class SeparatorDataPage: UIViewController, UITableViewDataSource, UITableViewDelegate, WebSocketDataDelegate, TableViewDataDelegate {

    @IBOutlet weak var separatorDataTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tabBar: UINavigationItem!
    private let webSocketData = ModelsHolder.instance.webSocketData
    private let cellReuseIdentifier = "SeparatorDataCell"
    var separatorIndex: Int?
    var separator: Separator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        separatorDataTableView.delegate = self
        separatorDataTableView.dataSource = self
        
        webSocketData.webSocketDataDelegate = self
        webSocketData.tableViewDataDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.separator?.data == nil) {
            activityIndicator.startAnimating()
            separatorDataTableView.separatorStyle = .none
        }
    }
    
    func getSeparatorData(for separator: Separator) {
        OperationQueue.main.addOperation {
            self.separatorDataTableView.reloadData()
            self.separator = separator
            if (self.separator?.data == nil) {
                self.separatorDataTableView.reloadData()
                self.activityIndicator.startAnimating()
                self.separatorDataTableView.separatorStyle = .none
            }
        }
    }
    
    func updateTableViewData() {
          OperationQueue.main.addOperation {
              if (self.separator?.data != nil) {
                  self.activityIndicator.stopAnimating()
                  self.separatorDataTableView.separatorStyle = .singleLine
                  self.separatorDataTableView.reloadData()
              }
          }
      }
    
    func clearTableViewData() {
        OperationQueue.main.addOperation {
            self.separator?.data = nil
            self.separatorDataTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return separator?.name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return separator?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //init custom cell
        let cell:MainPageTableViewCell = self.separatorDataTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MainPageTableViewCell
        
        let separatorData = separator?.data
        //fill custom cell
            ImageProcessing().fetchImage(from: (separatorData?[indexPath.row].img)!) { (imageData) in
                if let data = imageData {
                    DispatchQueue.main.async {
                        cell.cellImg.image = UIImage(data: data)
                    }
                } else {
                    DispatchQueue.main.async {
                        cell.cellImg.image = UIImage(named: "noImage")
                    }
                    print("Error loading image");
                }
            }
        cell.date.text = Date(timeIntervalSince1970: TimeInterval((separatorData?[indexPath.row].date)!)/1000).stringValue
        switch separatorData?[indexPath.row].type {
            case 0:
                cell.type.text = "Левый"
            case 1:
                cell.type.text = "Правый"
            default:
                cell.type.text = "Нет данных"
        }
        cell.position.text = separatorData?[indexPath.row].position != nil ? "\(separatorData![indexPath.row].position)" : "Нет данных"
        cell.probability.text = separatorData?[indexPath.row].currentProbability != nil ? "\(separatorData![indexPath.row].currentProbability)%" : "Нет данных"
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCellData" {
            if let indexPath = self.separatorDataTableView.indexPathForSelectedRow {
                let controller = segue.destination as! PresentDataPage
                controller.separatorData = self.separator?.data?[indexPath.row]
                controller.separatorID = self.separator?.ID
            }
        }
        
        if segue.identifier == "ShowSettingPage" {
            let controller = segue.destination as! SettingsMenuPage
            
            controller.separatorID = self.separator?.ID
        }
        if let dest = segue.destination as? SettingsMenuPage {
            dest.separatorID = separator?.ID
        }
    }
    

}
