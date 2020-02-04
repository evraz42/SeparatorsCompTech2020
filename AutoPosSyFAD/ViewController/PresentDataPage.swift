//
//  PresentSeparatorData.swift
//  AutoPosSyFAD
//
//  Created by Madara2hor on 30.01.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

class PresentDataPage: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dataTableView: UITableView!
    
    private let webSocketData = ModelsHolder.instance.webSocketData
    private let cellReuseIdentifier = "DataCell"
    private var currentSection = 0
    
    var separatorData: SeparatorData?
    var separatorID: String?
    var titles = ["Дата:", "Тип флажка:", "Позиция", "Вероятность текущей позиции:"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataTableView.delegate = self
        dataTableView.dataSource = self
        
        ImageProcessing().fetchImage(from: (separatorData?.img)!) { (imageData) in
            if let data = imageData {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            } else {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(named: "noImage")
                }
                print("Error loading image");
            }
        }
        
        //webSocketData.unsubscribeRequest(separatorID!)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //webSocketData.subscribeRequest(separatorID!)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titles[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SeparatorDataCell = self.dataTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! SeparatorDataCell
        
        var data: String?
        data = configureCellData(indexPath, separatorData!)
        
        cell.cellData.text = data
        return cell
    }
    //serch data from separatorData by titles
    func configureCellData(_ indexPath: IndexPath, _ separator: SeparatorData) -> String { //This is not SOLID ;c
        var data: String?
        switch indexPath.section {
        case 0:
            data = Date(timeIntervalSince1970: TimeInterval((separator.date))/1000).stringValue
        case 1:
            if separator.type == 0 {
                data = "Левый"
            }
            else {
                data = "Правый"
            }
        case 2:
            data = "\(separator.position)"
        case 3:
            data = "\(separator.currentProbability)%"
        default:
            break
        }
        return data ?? ""
    }

}
