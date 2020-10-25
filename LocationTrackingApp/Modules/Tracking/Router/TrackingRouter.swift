//
//  TrackingRouter.swift
//  LocationTrackingApp
//
//  Created by Ayush Gupta on 24/10/20.
//  Copyright © 2020 Ayush Gupta. All rights reserved.
//

import Foundation
import UIKit

class TrackingRouter {
    
    /// Initialize Tracking module
    static func assembleModule(bundle: [String: Any]) -> UIViewController {
        let viewController = TrackingViewController(nibName: "TrackingViewController", bundle: nil)
        
        let presenter = TrackingPresenter()
        let router = TrackingRouter()
        let interactor = TrackingInteractor()
        
        presenter.interactor = interactor
        presenter.viewController = viewController
        presenter.router = router
        
        viewController.bundle = bundle
        viewController.presenter = presenter
        
        return viewController
    }
    
    func navigateTo(destination: Destination, bundle: [String: Any], type: Int) {
        RootRouter().navigate(to: destination, bundle: bundle, type: type)
    }
}
