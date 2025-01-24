//
//  AddRewardViewViewModel.swift
//  TaskWallet
//
//  Created by Adam Heidmann on 1/19/25.
//

import Foundation
import SwiftUI
    
    @Observable class AddRewardViewViewModel:Observable {
        
        var rewardName:String = ""
        var creditsToUnlock:Double = 5
        
        func saveToDocumentsDirectory(data: Data){
            @Environment(\.managedObjectContext) var moc
            @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Reward.rewardName, ascending: true)]) var rewards: FetchedResults<Reward>
                
                let fileName = UUID().uuidString + ".png"
                
                let fileManager = FileManager.default
                let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                
                let fileURL = documentsURL.appendingPathComponent(fileName)
                
                do {
                    try data.write(to: fileURL)
                } catch {
                    print("Error saving image to documents directory: \(error)")
                }
                
                let reward = Reward(context: moc)
                reward.rewardName = rewardName
                reward.imageUUID = fileName
                reward.creditsRequired = Int64(creditsToUnlock)
                
                do {
                    try moc.save()
                } catch {
                    print("Error saving to Core Data: \(error)")
                }
            }
        
    }
