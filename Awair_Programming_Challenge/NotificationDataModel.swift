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
    func didRecieveDateArrayUpdate(dateArray: [String])
    func didRecieveDateDictUpdate(dateDict: [String:Int])
    func didFailDataUpdateWithError(error: Error)
}

extension URLSession: myURLSessionTask {
    
}

class NotificationDataModel {
    
    weak var delegate : NotificationModelDelegate?
    private var myURLSession: myURLSessionTask?
    private var dateDictionary = [String:Int]()
    
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
                self.addJSONData(jsonData: jsonResult)
            } catch {
                print("JSONParser error :", error.localizedDescription)
            }
        }
        task?.resume()
    }
    
    func addJSONData(jsonData: [[String: Any]]) {
        
        var data = [NotificationModelItem]()
        var dateArray = [String]()
        
        for eachDict in jsonData {
            
            if let eachModelItem = NotificationModelItem(data: eachDict) {
                let dateString = dateFormatter(modelItem: eachModelItem)
                dateArray.append(dateString)
                data.append(eachModelItem)
            }
        }
        
        let dateUniqueArray = Array(Set(dateArray))
        self.delegate?.didRecieveDataUpdate(data: data)
        self.delegate?.didRecieveDateArrayUpdate(dateArray: dateUniqueArray)
        self.delegate?.didRecieveDateDictUpdate(dateDict: dateDictionary)
    }
    
    func dateFormatter(modelItem: NotificationModelItem) -> String {
        
        let dateFormatGetter = DateFormatter()
        let dateFormatPrinter = DateFormatter()
        dateFormatGetter.dateFormat = "yyyy-MM-dd"
        dateFormatPrinter.dateFormat = "MMM-dd-yyyy"
        var dateString = ""
        
        let timeStamp = modelItem.timestamp as! String
        let endIndex = timeStamp.index(timeStamp.endIndex, offsetBy: -14)
        let dateSubString = timeStamp[..<endIndex]
        let date = String(dateSubString)
        
        
        
        if let dateFormatted = dateFormatGetter.date(from: date) {
            dateString = dateFormatPrinter.string(from: dateFormatted)
            if dateDictionary[dateString] != nil {
                var dateCount = dateDictionary[dateString] as! Int
                dateCount += 1
                dateDictionary[dateString] = dateCount
            } else {
                dateDictionary[dateString] = 1
            }
            return dateString
        
        } else {
            print("There was an error printing the date")
            return dateString
        }
        
    }
}
