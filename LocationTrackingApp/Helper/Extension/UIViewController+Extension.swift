//
//  Date+Extension.swift
//  LocationTrackingApp
//
//  Created by Ayush Gupta on 24/10/20.
//  Copyright © 2020 Ayush Gupta. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    /// get current date is custom format
    func getCurrentDate(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let currentDate = formatter.string(from: Date())
        return currentDate
    }
}
