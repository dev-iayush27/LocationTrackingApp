//
//  TrackingTVCell.swift
//  LocationTrackingApp
//
//  Created by Ayush Gupta on 24/10/20.
//  Copyright © 2020 Ayush Gupta. All rights reserved.
//

import UIKit

class TrackingTVCell: UITableViewCell {
    
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    func getUserData(data: UserInfo) {
        self.latitudeLabel.text = data.latitude
        self.longitudeLabel.text = data.longitude
        self.timestampLabel.text = data.timeStamp
    }
}
