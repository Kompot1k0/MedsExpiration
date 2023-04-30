//
//  MedsExpModel.swift
//  Meds Expiration Date
//
//  Created by Admin on 16.04.2023.
//

import Foundation
import SwiftUI

struct MedsExp {
    @State var permissionGranted = false
    
    init() {
        UNUserNotificationCenter.current().getNotificationSettings { [self] settings in
            if settings.authorizationStatus == .authorized {
                self.permissionGranted = true
            }
        }
    }
    
    func requestPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                permissionGranted = true
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func sendNotification(test: Bool, dragName: String, daysToShowNottification: Int, expirationDate: Date) {
        let trigger: UNCalendarNotificationTrigger
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "MedsExp"
        notificationContent.subtitle = "\(dragName.isEmpty ? "Meds" : dragName) expiry date ends: \(dateForNotification(expirationDate))"
        notificationContent.sound = UNNotificationSound.default

        if test {
            trigger = UNCalendarNotificationTrigger(dateMatching:
                Calendar.current.dateComponents([.second],
                from: Date().addingTimeInterval(2)),
                repeats: false)
        } else {
            guard var triggerDate = Calendar.current.date(byAdding: .day, value: -daysToShowNottification, to: expirationDate)
            else { return }
            triggerDate = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: triggerDate)!
            trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year,
                                                .month,
                                                .day,
                                                .hour,
                                                .minute,
                                                .second],
                                                from: triggerDate), repeats: false)
        }
        let req = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)

        UNUserNotificationCenter.current().add(req)
    }
    
    private func dateForNotification(_ expirationDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: expirationDate)
        return dateString
    }
    
//    private func hideKeyboard() {
//        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//    }
}
