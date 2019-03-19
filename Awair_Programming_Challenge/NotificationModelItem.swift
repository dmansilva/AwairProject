//
//  NotificationModelItem.swift
//  Awair_Programming_Challenge
//
//  Created by Daniel Silva on 3/14/19.
//  Copyright © 2019 D Silvv Apps. All rights reserved.
//

import Foundation

class NotificationModelItem {
    
    var title : String?
    var device_name : String?
    var description : String?
    var icon_url : String?
    var timestamp : String?
    var link : String?
    
    init? (data: [String: Any]?) {
        
        if let data = data {
        
            if let title = data["title"] {
                self.title = title as? String
            }

            if let device_name = data["device_name"] {
                self.device_name = device_name as? String
            }

            if let description = data["description"] {
                self.description = description as? String
            }

            if let icon_url = data["icon_url"] {
                self.icon_url = icon_url as? String
            }
            
            if let timestamp = data["timestamp"] {
                self.timestamp = timestamp as? String
            }
            
            if let link = data["link"] {
                self.link = link as? String
            }
        } else {
            return nil
        }
    }
}
