//
//  TrackingInteractor.swift
//  LocationTrackingApp
//
//  Created by Ayush Gupta on 24/10/20.
//  Copyright © 2020 Ayush Gupta. All rights reserved.
//

import Foundation
import CoreData

class TrackingInteractor {
    
    fileprivate let context = CoreDataManager.shared.persistentContainer.viewContext
}

extension TrackingInteractor {
    
    // MARK:- Create/Add user info
    func addUserInfo(latitude: String, longitude: String, timeStamp: String, onSuccess: @escaping (String) -> (), onFailure: @escaping (Error) -> ()) {
        let user = NSEntityDescription.insertNewObject(forEntityName: "UserInfo", into: self.context) as! UserInfo
        
        user.setValue(latitude, forKey: "latitude")
        user.setValue(longitude, forKey: "longitude")
        user.setValue(timeStamp, forKey: "timeStamp")
        
        do {
            try self.context.save()
            onSuccess("Success")
        } catch let fetchErr {
            print("Failed to create user info: ", fetchErr)
            onFailure(fetchErr)
        }
    }
    
    // MARK:- Fetch user info list
    func fetchUserInfoList(onSuccess: @escaping ([UserInfo]) -> (), onFailure: @escaping (Error) -> ()) {
        let fetchRequest = NSFetchRequest<UserInfo>(entityName: "UserInfo")
        let sort = NSSortDescriptor.init(key: "timeStamp", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        do {
            let event = try self.context.fetch(fetchRequest)
            onSuccess(event)
        } catch let fetchErr {
            print("Failed to fetch user list: ", fetchErr)
            onFailure(fetchErr)
        }
    }
    
    // MARK:- Delete user info list
    func deleteUserInfoList(onSuccess: @escaping (String) -> (), onFailure: @escaping (Error) -> ()) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try self.context.execute(deleteRequest)
            try self.context.save()
            onSuccess("Success")
        } catch let fetchErr {
            print ("Entity not deleted.", fetchErr)
            onFailure(fetchErr)
        }
    }
}
