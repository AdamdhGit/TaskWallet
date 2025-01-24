//
//  DisplayRedemptionsViewViewModel.swift
//  TaskWallet
//
//  Created by Adam Heidmann on 1/19/25.
//

import Foundation
import SwiftUI
    
    @Observable class DisplayRedemptionsViewViewModel:Observable {
        
        func retrieveFromDocumentsDirectory(imageUUID: String) -> UIImage? {
            //all this is doing is accepting a string. we don't have to declare any properties here or initialize anything.
            
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // Append the imageUUID to the Documents directory URL to form the file URL
            let fileURL = documentsURL.appendingPathComponent(imageUUID)
            
            // Try to load image data from file URL
            if let imageData = try? Data(contentsOf: fileURL) {
                
                return UIImage(data: imageData)
                
            }
            
            return nil
            
        }
        
    }
