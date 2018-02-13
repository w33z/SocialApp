//
//  OwnDateFormat.swift
//  SocialApp
//
//  Created by Bartosz Pawełczyk on 10.02.2018.
//  Copyright © 2018 Bartosz Pawełczyk. All rights reserved.
//

import UIKit

extension UIViewController {
    func ownDateFormat(_ date: Date) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        
        let selectedDate = dateFormatter.string(from: date)
        return selectedDate
    }
}

extension UIView{
    func messageDataFormat(_ timestamp: NSNumber) -> String {
        let timestampDate = Date(timeIntervalSince1970: timestamp.doubleValue)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm d.MMM"
        
        let formattedDate = dateFormatter.string(from: timestampDate)
        return formattedDate
    }
}
