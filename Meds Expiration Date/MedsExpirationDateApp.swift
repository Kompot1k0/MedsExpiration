//
//  Meds_Expiration_DateApp.swift
//  Meds Expiration Date
//
//  Created by Admin on 12.04.2023.
//

import SwiftUI

@main
struct MedsExpirationDateApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    private let meds = MedsExpiration()
    var body: some Scene {
        WindowGroup {
            MedsContentView(medsModel: meds)
        }
    }
}
