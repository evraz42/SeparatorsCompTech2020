//
//  MainPageViewController.swift
//  AutoPosSyFAD
//
//  Created by Madara2hor on 29.01.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

class SeparatorDataPage: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var separatorDataTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let cellReuseIdentifier = "SeparatorDataCell"
    var separator: Separator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        separatorDataTableView.delegate = self
        separatorDataTableView.dataSource = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (separator == nil) {
            activityIndicator.startAnimating()

            separatorDataTableView.separatorStyle = .none

            OperationQueue.main.addOperation() {

                self.activityIndicator.stopAnimating()

                self.separatorDataTableView.separatorStyle = .singleLine
                self.separatorDataTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return separator?.name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return separator?.data!.count ?? 0
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
                cell.cellImg.image = UIImage(named: "logo")
                print("Error loading image");
            }
        }
        
        cell.date.text = separatorData?[indexPath.row].date
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
            }
        }
    }

}
