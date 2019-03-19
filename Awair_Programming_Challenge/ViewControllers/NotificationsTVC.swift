//
//  NotificationsTVC.swift
//  Awair_Programming_Challenge
//
//  Created by Daniel Silva on 3/13/19.
//  Copyright © 2019 D Silvv Apps. All rights reserved.
//

import UIKit


class NotificationsTVC: UITableViewController {
    
    public var NotificationInstance: NotificationModelDelegate!
    
    private let dataSource = NotificationDataModel()
    private var dateArrayData = [String]()
    private var dateDictData = [String:Int]()
    
    let link = "http://35.233.197.47/inbox?_limit=10_page=1"
    
    fileprivate var dataDict = [String: [NotificationModelItem]]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.delegate = self
        dataSource.requestDataViaURL(urlLink: link)
        
        tableView?.register(NotificationTableViewCell.nib, forCellReuseIdentifier: NotificationTableViewCell.identifier)
        
        view.backgroundColor = .white
        self.title = "Notifications"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dateArrayData.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dateArrayData[section]
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arrayIndex = dateArrayData[section]
        if let count = dateDictData[arrayIndex] {
            return count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let date = dateArrayData[indexPath.section]
        
        if let arrayOFModelItems = dataDict[date] {
    
            let indexMI = arrayOFModelItems[indexPath.row]
            if let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.identifier, for: indexPath) as? NotificationTableViewCell {
                cell.configureWithNotificationModelItem(item: indexMI)
                return cell
            } else {
                return UITableViewCell()
            }
        } else {
            return UITableViewCell()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

}

extension NotificationsTVC: NotificationModelDelegate {
    
    func didRecieveDataDictUpdate(data: [String : [NotificationModelItem]]) {
        dataDict = data
    }
    
    
    func didRecieveDateDictUpdate(dateDict: [String : Int]) {
        dateDictData = dateDict
    }
    
    func didRecieveDateArrayUpdate(dateArray: [String]) {
        dateArrayData = dateArray
    }
    
    func didFailDataUpdateWithError(error: Error) {
        print("ERROR: didFailDataUpdateWithError : ", error)
    }
}
