//
//  TaskWalletApp.swift
//  TaskWallet
//
//  Created by Adam Heidmann on 1/6/25.
//

import SwiftUI

@main
struct TaskWalletApp: App {
    
    @StateObject var loadCoreData = LoadCoreData()
    
    var body: some Scene {
        
        WindowGroup {
            
            MainView()
                //.preferredColorScheme(.light)
                .environment(\.managedObjectContext, loadCoreData.container.viewContext)
                //takes the context of the CoreData and puts it into the managedObjectContext
            
        }
    }
}
