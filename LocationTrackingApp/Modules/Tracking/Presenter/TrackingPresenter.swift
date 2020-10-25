//
//  TrackingPresenter.swift
//  LocationTrackingApp
//
//  Created by Ayush Gupta on 24/10/20.
//  Copyright © 2020 Ayush Gupta. All rights reserved.
//

import Foundation
import UIKit

class TrackingPresenter {
    weak var viewController: TrackingViewController?
    var router: TrackingRouter?
    var interactor: TrackingInteractor?
}

/// Presenter -> Interactor
extension TrackingPresenter {
    
    func addUserInfo(latitude: String, longitude: String, timeStamp: String) {
        interactor?.addUserInfo(latitude: latitude, longitude: longitude, timeStamp: timeStamp, onSuccess: { [weak self] status in
            self?.viewController?.insertDataSuccessResponse(status: status)
            }, onFailure: { [weak self] error in
                self?.viewController?.insertDataFailureResponse(error: error)
        })
    }
    
    func getUserInfoList() {
        interactor?.fetchUserInfoList(onSuccess: { [weak self] response in
            self?.viewController?.fetchUserDataSuccessResponse(response: response)
            }, onFailure: { [weak self] error in
                self?.viewController?.fetchUserDataFailureResponse(error: error)
        })
    }
    
    func deleteUserInfoList() {
        interactor?.deleteUserInfoList(onSuccess: { [weak self] status in
            self?.viewController?.deleteUserDataSuccessResponse(status: status)
            }, onFailure: { [weak self] error in
                self?.viewController?.deleteUserDataFailureResponse(error: error)
        })
    }
}

/// Presenter -> Router
extension TrackingPresenter {
    func navigateTo(destination: Destination, bundle: [String: Any], type: Int) {
        router?.navigateTo(destination: destination, bundle: bundle, type: type)
    }
}
