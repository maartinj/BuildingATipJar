//
//  BuildingATipJarApp.swift
//  BuildingATipJar
//
//  Created by Tunde Adegoroye on 16/11/2022.
//

import SwiftUI

@main
struct BuildingATipJarApp: App {

    @StateObject private var store = TipStore()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(store)
//            TestView()
        }
    }
}
