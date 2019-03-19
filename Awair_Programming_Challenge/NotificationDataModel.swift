//
//  NotificationDataModel.swift
//  Awair_Programming_Challenge
//
//  Created by Daniel Silva on 3/14/19.
//  Copyright © 2019 D Silvv Apps. All rights reserved.
//

import Foundation

protocol myURLSessionTask {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

protocol NotificationModelDelegate: class {
    func didRecieveDataUpdate(data: [NotificationModelItem])
    func didFailDataUpdateWithError(error: Error)
}

extension URLSession: myURLSessionTask {
    
}

class NotificationDataModel {
    
    weak var delegate : NotificationModelDelegate?
    private var myURLSession: myURLSessionTask?
    
    init(session: myURLSessionTask = URLSession.shared) {
        self.myURLSession = session
    }
    
    func requestDataViaURL(urlLink: String) {
        
        guard let url = URL.init(string: urlLink) else {
            print("Can't get url")
            return
        }
        
        let task = self.myURLSession?.dataTask(with: url) { (data, response, error) in
            
            guard data != nil && error == nil else {
                print("error :", error?.localizedDescription)
                self.delegate?.didFailDataUpdateWithError(error: error!)
                return
            }
            
            do {
                guard let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String: Any]] else {
                    print("Cant get jsonResult")
                    return
                }
                self.sortJSONData(jsonData: jsonResult)
            } catch {
                print("JSONParser error :", error.localizedDescription)
            }
        }
        task?.resume()
    }
    
    func sortJSONData(jsonData: [[String: Any]]) {
        
        var data = [NotificationModelItem]()
        
        for eachDict in jsonData {
            
            if let eachModelItem = NotificationModelItem(data: eachDict) {
                data.append(eachModelItem)
            }
        }
        self.delegate?.didRecieveDataUpdate(data: data)
    }
}
