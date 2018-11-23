//
//  NotificationViewController.swift
//  test
//
//  Created by Muhammad Hunble Dhillon on 11/16/18.
//  Copyright © 2018 Arrivy. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func fireNotification(_ sender: Any) {
        if #available(iOS 12.0, *) {
            scheduleGroupedNotifications()
        } else {
            // Fallback on earlier versions
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @available(iOS 12.0, *)
    func scheduleGroupedNotifications() {
        for i in 1...6 {
            let notificationContent = UNMutableNotificationContent()

            notificationContent.body = "Do not forget the pizza!"
            notificationContent.sound = UNNotificationSound.default
            
            if i % 2 == 0 {
                notificationContent.title = "Hello! (from wife)"
                notificationContent.threadIdentifier = "Guerrix-Wife"
                notificationContent.summaryArgument = "your wife"
            } else {
                notificationContent.title = "Hello! (from son)"
                notificationContent.threadIdentifier = "Guerrix-Son"
                notificationContent.summaryArgument = "your son"
            }
            
            // Deliver the notification in five seconds.
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            // Schedule the notification.
            let request = UNNotificationRequest(identifier: "\(i)FiveSecond", content: notificationContent, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request) { (error: Error?) in
                if let theError = error {
                    print(theError)
                }
            }
        }
    }
}
