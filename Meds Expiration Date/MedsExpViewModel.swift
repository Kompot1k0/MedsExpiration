//
//  MedsExpContentView.swift
//  Meds Expiration Date
//
//  Created by Admin on 16.04.2023.
//

import Foundation

class MedsExpiration: ObservableObject {
    @Published private var model = MedsExp()
    
    var permissionGranted: Bool {
        model.permissionGranted
    }    
    
    func requestPermissions() {
        model.requestPermissions()
    }
    
    func sendNotification(test: Bool, dragName: String, daysToShowNottification: Int, expirationDate: Date) {
        model.sendNotification(test: test, dragName: dragName, daysToShowNottification: daysToShowNottification, expirationDate: expirationDate)
    }
}
