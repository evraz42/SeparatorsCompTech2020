//
//  MainPageViewController.swift
//  AutoPosSyFAD
//
//  Created by Madara2hor on 29.01.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

class MainPage: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let cellReuseIdentifier = "CustomCell"
    let dataProc = DataProcessing()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        dataProc.getDataFromDatabase()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let separatorsData = dataProc.separatorsData
        return separatorsData[section].name
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataProc.separatorsData.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sepData = dataProc.separatorsData
        return sepData[section].data!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //init custom cell
        let cell:CustomTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! CustomTableViewCell
        
        let separatorsData = dataProc.separatorsData
        let separator = separatorsData[indexPath.section].data
        
        
        //fill custom cell
        cell.cellImg.image = UIImage(named: separator![indexPath.row].img)
        cell.date.text = separator![indexPath.row].date
        cell.type.text = separator![indexPath.row].type
        cell.position.text = String(separator![indexPath.row].position)
        
        return cell
    }

}
