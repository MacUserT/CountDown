//
//  ViewController.swift
//  CountDown
//
//  Created by Paul Hertroys on 04-03-16.
//  Copyright © 2016 Aurelius Technology Solutions. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Properties
    var startOfCountdown : Timer?
    var allowedDate : NSDate?
    //let daysLeft : NSTimeInterval = 172800.0
    let daysLeft : NSTimeInterval = 100.0
    var updateTimer = NSTimer()

    //MARK: - Outlets
    @IBOutlet weak var remainingTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        if let savedDate = NSKeyedUnarchiver.unarchiveObjectWithFile(Timer.dateStore.path!) as? Timer {
            
            self.startOfCountdown = savedDate
            self.allowedDate = self.startOfCountdown?.countdownDate!.dateByAddingTimeInterval(daysLeft)
            if (!self.updateTimer.valid) {
                self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "showCountingDown", userInfo: nil, repeats: true)
            }
        }
    }

    //MARK: Viewcontroller methods
    
    func showCountingDown() {
        
        let currentDate = NSDate()
        var countdownCounter = UInt32((allowedDate?.timeIntervalSinceDate(currentDate))!)
        
        if (countdownCounter > 0) {
            
            let remainingDays = countdownCounter / 86400
            countdownCounter -= remainingDays * 86400
            let remainingHours = countdownCounter / 3600
            countdownCounter -= remainingHours * 3600
            let remainingMinutes = countdownCounter / 60
            countdownCounter -= remainingMinutes * 60
            let remainingSeconds = countdownCounter
            
            let stringDays = String(format: "%02d", remainingDays)
            let stringHours = String(format: "%02d", remainingHours)
            let stringMinutes = String(format: "%02d", remainingMinutes)
            let stringSeconds = String(format: "%02d", remainingSeconds)
            self.remainingTime.text = "\(stringDays) days \(stringHours):\(stringMinutes):\(stringSeconds) hours"
            
//            if remainingSeconds > 9 {
//                self.remainingTime.text = "\(stringDays) days \(stringHours):\(stringMinutes):\(stringSeconds) hours"
//            } else {
//                self.remainingTime.text = "\(remainingDays) days \(remainingHours):\(remainingMinutes):0\(remainingSeconds) hours"
//
//            }
        } else {
            self.setLabelToRed()
        }
    }
    
    func setLabelToRed() {
        
        self.remainingTime.text = "00 days 00:00:00 hours"
        self.remainingTime.backgroundColor = UIColor.redColor()
        self.remainingTime.textColor = UIColor.whiteColor()
        self.updateTimer.invalidate()
    }
    
    func saveDateToDisk() {
        
        let isSuccessFulSave = NSKeyedArchiver.archiveRootObject(startOfCountdown!, toFile: Timer.dateStore.path!)
        print("We have a successful save, \(isSuccessFulSave).\n")
    }
    
    //MARK: - Action methods
    @IBAction func startCountdown(sender: AnyObject) {
        
        self.startOfCountdown = Timer()
        self.allowedDate = self.startOfCountdown?.countdownDate!.dateByAddingTimeInterval(daysLeft)
        if (!self.updateTimer.valid) {
            self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "showCountingDown", userInfo: nil, repeats: true)
        }
    }

    @IBAction func saveTimer(sender: AnyObject) {
        
        self.saveDateToDisk()
    }
    
    @IBAction func stopCountdown(sender: AnyObject) {
        
        updateTimer.invalidate()
        do {
            try NSFileManager().removeItemAtPath(Timer.documentsDirectory.path!)
        } catch {
            print("This shouldn't happen.\n")
        }
    }
}

