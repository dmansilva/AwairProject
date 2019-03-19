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
    
    let link = "http://35.233.197.47/inbox?_limit=10_page=1"
    
    fileprivate var JSONData = [NotificationModelItem]() {
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return JSONData.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let indexDict = self.JSONData[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.identifier, for: indexPath) as? NotificationTableViewCell {
            cell.configureWithNotificationModelItem(item: indexDict)
            return cell
        } else {
            return UITableViewCell()
        }

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

}

extension NotificationsTVC: NotificationModelDelegate {
    
    func didRecieveDataUpdate(data: [NotificationModelItem]) {
        JSONData = data
    }
    
    func didFailDataUpdateWithError(error: Error) {
        print("ERROR: didFailDataUpdateWithError : ", error)
    }
}
