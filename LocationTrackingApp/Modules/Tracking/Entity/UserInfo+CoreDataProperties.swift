//
//  UserInfo+CoreDataProperties.swift
//  
//
//  Created by Ayush Gupta on 23/10/20.
//
//

import Foundation
import CoreData

extension UserInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserInfo> {
        return NSFetchRequest<UserInfo>(entityName: "UserInfo")
    }

    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var timeStamp: String?
}
