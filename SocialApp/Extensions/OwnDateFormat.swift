//
//  OwnDateFormat.swift
//  SocialApp
//
//  Created by Bartosz Pawełczyk on 10.02.2018.
//  Copyright © 2018 Bartosz Pawełczyk. All rights reserved.
//

import UIKit

extension UIViewController {
    func ownDateFormat(_ date: Date) -> String{
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        
        let selectedDate: String = dateFormatter.string(from: date)
        return selectedDate
    }
}
