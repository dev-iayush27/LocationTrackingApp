//
//  TrackingViewController.swift
//  LocationTrackingApp
//
//  Created by Ayush Gupta on 24/10/20.
//  Copyright © 2020 Ayush Gupta. All rights reserved.
//

import UIKit
import CoreLocation
import Toast_Swift

enum TrackingStatus {
    case start
    case stop
}

class TrackingViewController: UIViewController {
    
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var userDataTableView: UITableView!
    @IBOutlet weak var savedDataCountLabel: UILabel!
    
    var presenter: TrackingPresenter?
    var bundle: [String: Any] = [:]
    
    let locationManager = CLLocationManager()
    fileprivate var latitude = 0.0
    fileprivate var longitude = 0.0
    
    fileprivate var status: TrackingStatus = .stop
    fileprivate var timer: Timer? = nil {
        willSet {
            self.timer?.invalidate()
        }
    }
    fileprivate var timerForDBData: Timer? = nil {
        willSet {
            self.timerForDBData?.invalidate()
        }
    }
    fileprivate var arrUserData: [UserInfo] = []
    fileprivate var isGetInitialLocationData: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpLocationManager()
        self.initTableView()
    }
    
    func initTableView() {
        self.userDataTableView.delegate = self
        self.userDataTableView.dataSource = self
        self.userDataTableView.register(UINib(nibName: "TrackingTVCell", bundle: nil), forCellReuseIdentifier: "TrackingTVCell")
    }
    
    func setUpLocationManager() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    @IBAction func tapOnStartTrackingBtn(_ sender: UIButton) {
        if self.status != .start {
            self.view.makeToast("Tracking is started.")
            self.status = .start
            self.locationManager.startUpdatingLocation()
            self.startProgressTimer()
            self.startProgressTimerForSendDBData()
        }
    }
    
    @IBAction func tapOnStopTrackingBtn(_ sender: UIButton) {
        if self.status == .start  {
            self.view.makeToast("Tracking is stopped.")
            self.status = .stop
            self.locationManager.stopUpdatingLocation()
            self.stopProgressTimer()
            self.stopTimerForSavedDataFetching()
            self.presenter?.deleteUserInfoList()
            DispatchQueue.main.async {
                self.displayUpdatedUserData(latitude: String(self.latitude), longitude: String(self.longitude), timeStamp: self.getCurrentDate(format: "dd-MM-yyyy hh:mm:ss"))
            }
        }
    }
    
    func displayUpdatedUserData(latitude: String, longitude: String, timeStamp: String) {
        self.latitudeLabel.text = latitude
        self.longitudeLabel.text = longitude
        self.timestampLabel.text = timeStamp
    }
    
    deinit {
        self.stopProgressTimer()
        self.stopTimerForSavedDataFetching()
    }
}

// MARK:- Response from local database
extension TrackingViewController {
    
    func insertDataSuccessResponse(status: String) {
        // do some task after getting success response
        print(status)
    }
    
    func insertDataFailureResponse(error: Error) {
        self.view.makeToast(error.localizedDescription)
    }
    
    func fetchUserDataSuccessResponse(response: [UserInfo]) {
        if response.count > 0 {
            self.arrUserData.removeAll()
            self.arrUserData = response
            self.savedDataCountLabel.text = String(self.arrUserData.count)
            self.userDataTableView.reloadData()
            self.presenter?.deleteUserInfoList()
        }
    }
    
    func fetchUserDataFailureResponse(error: Error) {
        self.view.makeToast(error.localizedDescription)
    }
    
    func deleteUserDataSuccessResponse(status: String) {
        // do some task after getting success response
        print(status)
    }
    
    func deleteUserDataFailureResponse(error: Error) {
        self.view.makeToast(error.localizedDescription)
    }
}

// MARK:- location manager delegate function (getting latitude and longitude when user moves)
extension TrackingViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationvalue: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        self.latitude = locationvalue.latitude
        self.longitude = locationvalue.longitude
        
        if !isGetInitialLocationData {
            self.isGetInitialLocationData = true
            DispatchQueue.main.async {
                self.displayUpdatedUserData(latitude: String(self.latitude), longitude: String(self.longitude), timeStamp: self.getCurrentDate(format: "dd-MM-yyyy hh:mm:ss"))
            }
        }
    }
}

// MARK:- Timer related functions...
extension TrackingViewController {
    
    /// A function to start timer progress...
    func startProgressTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 13, target: self, selector: #selector(self.callAPIForTimeCovered), userInfo: nil, repeats: true)
    }
    
    /// A function to stop timer prgress...
    func stopProgressTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    /// function will call every 13 second (if internet connection is available it will display updated user info else data will store in local database)...
    @objc func callAPIForTimeCovered() {
        let currentTime = self.getCurrentDate(format: "dd-MM-yyyy hh:mm:ss")
        DispatchQueue.main.async {
            self.displayUpdatedUserData(latitude: String(self.latitude), longitude: String(self.longitude), timeStamp: self.getCurrentDate(format: "dd-MM-yyyy hh:mm:ss"))
        }
        if !Reachability.isConnectedToNetwork() {
            self.presenter?.addUserInfo(latitude: String(self.latitude), longitude: String(self.longitude), timeStamp: currentTime)
        }
    }
    
    /// A function to start timer progress...
    func startProgressTimerForSendDBData() {
        self.timerForDBData = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.displaySavedData), userInfo: nil, repeats: true)
    }
    
    /// A function to stop timer prgress...
    func stopTimerForSavedDataFetching() {
        self.timerForDBData?.invalidate()
        self.timerForDBData = nil
    }
    
    /// function will call every 5 second to check internet connection, if connection will come again it will print saved user info and delete saved data from local database...
    @objc func displaySavedData() {
        if Reachability.isConnectedToNetwork() {
            self.presenter?.getUserInfoList()
        }
    }
}

// MARK:- Table View
extension TrackingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrUserData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackingTVCell", for: indexPath) as! TrackingTVCell
        cell.getUserData(data: self.arrUserData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
}
