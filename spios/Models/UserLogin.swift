//
//  UserLogin.swift
//  spios
//
//  Created by MobileGenius on 6/11/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import Foundation
import CoreData

public class UserLogin: NSManagedObject {

    /// user id
    @NSManaged var id: String
    /// user token
    @NSManaged var token: String
    /// user name
    @NSManaged var username: String

}
