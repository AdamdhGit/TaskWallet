//
//  MainView.swift
//  TaskWallet
//
//  Created by Adam Heidmann on 1/7/25.
//

import CoreData
import SwiftUI

struct MainView: View {
    
    @AppStorage("credits") var credits: Int = 0
    
    var body: some View {
        
        TabView {
            
            ContentView(credits: $credits).tabItem {
                Image(systemName: "list.bullet")
            }
            
            ShopView(credits: $credits).tabItem {
                Image(systemName: "creditcard.fill")
            }
            
        }
    }
}

#Preview {
    let loadCoreData = LoadCoreData()
    
    MainView().environment(\.managedObjectContext, loadCoreData.container.viewContext)
}
