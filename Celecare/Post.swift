//
// Post.swift
// Sickcall
//
// Created by Dominic Smtih on 7/19/17.
// Copyright © 2017 Sickcall LLC All rights reserved.
//

import UIKit
import Parse

public class Post: PFObject, PFSubclassing {
    
    public class func parseClassName() -> String {
        return "Post"
    }
    
    @NSManaged public var postId: String!
    @NSManaged public var userId: String!
    @NSManaged public var advisorUserId: String!
    @NSManaged public var supportURLs: [NSString: String]!
    @NSManaged public var librariesURLs: [NSString: String]!
    
}
