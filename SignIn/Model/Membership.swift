//
//  Membership.swift
//  SignIn
//
//  Created by Momoko Saunders on 7/1/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation

class Membership: NSObject {
    let membershipExpiration = NSDate()
    
    enum membershipType: String {
        case
        Monthly = "Monthly",
        SixMonth = "6 Month",
        Yearly = "Yearly",
        LifeTime = "Life Time",
        NonMember = "Non Member"
    }
}