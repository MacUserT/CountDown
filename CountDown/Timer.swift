//
//  Timer.swift
//  CountDown
//
//  Created by Paul Hertroys on 04-03-16.
//  Copyright © 2016 Aurelius Technology Solutions. All rights reserved.
//

import UIKit

class Timer: NSObject, NSCoding {

    //MARK: - Properties
    struct PropertyKey {
        //Unpublished struct is for retrieving the stored information of the track. All the other information can be obtained from the location array.
        static let nameKey = "date"
    }
    var countdownDate : NSDate?
    static let documentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let dateStore = documentsDirectory.URLByAppendingPathComponent("CountdownDate")
    
    //MARK: - Initializers
    init(storedDate : NSDate) {
        super.init()

        self.countdownDate = storedDate
    }
    
    convenience override init() {
        
        let storedDate = NSDate()
        self.init(storedDate : storedDate)
    }
    
    //MARK: NSCoding.
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(countdownDate, forKey: PropertyKey.nameKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let storedDate = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! NSDate

        self.init(storedDate : storedDate)
    }
}
