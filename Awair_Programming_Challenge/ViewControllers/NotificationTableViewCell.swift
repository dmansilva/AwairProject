//
//  NotificationTableViewCell.swift
//  Awair_Programming_Challenge
//
//  Created by Daniel Silva on 3/17/19.
//  Copyright © 2019 D Silvv Apps. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    class var identifier : String {
        return String(describing: self)
    }
    
    class var nib : UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureWithNotificationModelItem(item: NotificationModelItem) {
        
        if item.icon_url != nil {
            setImageWithURL(url: item.icon_url!)
        }
        
        titleLabel.text = item.title
        descriptionLabel.text = item.description
        
        if item.timestamp != nil {
            configureTime(timeStamp: item.timestamp!, device_name: item.device_name!)
        }
        
    }
    
    func setImageWithURL(url: String) {
        
        let imageCache = NSCache<NSString, AnyObject>()
        
        guard let urlLink = URL(string: url) else {
            print("Cannot convert URLString to URLLink")
            return
        }
        
        if let cacheImage = imageCache.object(forKey: urlLink.absoluteString as NSString) as? UIImage {
            self.iconImage.image = cacheImage
        } else {
            URLSession.shared.dataTask(with: urlLink) { data, response, error in
                
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data)
                    imageCache.setObject(imageToCache!, forKey: url as NSString)
                    self.iconImage.image = imageToCache
                }
            }
            .resume()
        }
    }
    
    func configureTime(timeStamp: String, device_name: String) {
        
        let indexStart = timeStamp.index(timeStamp.startIndex, offsetBy: 11)
        let indexEnd = timeStamp.index(timeStamp.endIndex, offsetBy: -8)
        let subString = timeStamp[indexStart..<indexEnd]
        let hourIndex = subString.index(subString.endIndex, offsetBy: -3)
        let minuteIndex = subString.index(subString.startIndex, offsetBy: 2)
        let hourSubstring = subString[..<hourIndex]
        let minuteSubstring = subString[minuteIndex...]
        let hourString = String(hourSubstring)
        let hourInt = Int(hourString)
        
        if hourInt! > 12 {
            let hourDiff = hourInt! - 12
            let hourDiffString = String(hourDiff)
            let dnTimeString = device_name + "   " + hourDiffString + minuteSubstring + " PM"
            deviceName.text = dnTimeString
        } else {
            let dnTimeString = device_name + "   " + hourString + minuteSubstring + " AM"
            deviceName.text = dnTimeString
        }
        
    }
    
}
