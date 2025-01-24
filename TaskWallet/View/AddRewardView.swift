//
//  AddRewardView.swift
//  TaskWallet
//
//  Created by Adam Heidmann on 1/9/25.
//

import CoreData
import PhotosUI
import SwiftUI

struct AddRewardView: View {
    
    @State var rewardName : String = ""
    @State var creditsToUnlock:Double = 5
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @State var maxLength:Int = 30
    @State private var selectedPhoto: PhotosPickerItem?
    //item picked in photo library
    @State private var extractedImage: Image?
    //item selected from photo library to grab
    @State private var imageAsData:Data?
    
    var body: some View {
        
        ScrollView {
            
            Text("Create A New Reward").font(.title).padding(.top, 30)
            
            Divider().padding(.horizontal)

            Text("Title Your Reward").font(.title3).bold()

            Text("(Required)").opacity(0.8)
                
            HStack {
                
                rewardTitleTextField
                
                Spacer()
                
                rewardLetterCountOfMax
            }
            
            Divider().padding(.horizontal).opacity(0.5)
            
            creditsRequiredToUnlockText
            
            creditsToUnlockSlider
            
            creditText
            
            Divider().padding(.horizontal).opacity(0.5)
            
            VStack (spacing: 10) {
                
                uploadAPictureOfRewardText
                
                recommendedText
                
                pictureMotivationText

                uploadPictureButton
                
                if UIDevice.current.userInterfaceIdiom == .phone {
                    
                    if let theExtractedImage = extractedImage {
                        VStack {
                            theExtractedImage.resizable().aspectRatio(contentMode: .fill).frame(width: 100).clipShape(Circle()).padding(.top, 10)
                        }.frame(height: 100)
                    }
                  
                } else if UIDevice.current.userInterfaceIdiom == .pad {
                    if let theExtractedImage = extractedImage {
                        
                        VStack {
                            
                            theExtractedImage.resizable().aspectRatio(contentMode: .fill).frame(width: 300).clipShape(Circle()).padding(.top, 10)
                            
                        }.frame(height: 100)
                    }
                }
                
                createRewardButton
                
            }
            
            Spacer()
            
        }.padding(.horizontal)
    }
    
    var rewardTitleTextField: some View {
        TextField("Examples: New shoes; take a vacation.", text: $rewardName).onChange(of: rewardName) { oldValue, newValue in
            if newValue.count > 30 {
                rewardName = oldValue
            }
        }
    }
    
    var creditsToUnlockSlider: some View {
        Slider(value: $creditsToUnlock, in: 1...100, step: 1).tint(.purple)
    }
    
    var creditText: some View {
        Text("\(Int(creditsToUnlock)) \(creditsToUnlock == 1 ? "Credit" : "Credits")").foregroundStyle(.purple).bold()
    }
    
    var pictureMotivationText: some View {
        Text("Stay motivated by uploading from your photo album a screenshot you find online of the reward. Maybe that pair of shoes you've been wanting, or an image of a beautiful Maui beach for that next vacation.").font(.caption).padding(.top, 5)
    }
    
    var uploadPictureButton: some View {
        PhotosPicker("Upload Image", selection: $selectedPhoto, matching: .images).buttonStyle(.borderedProminent).tint(.orange).font(.title3).padding(.top, 10)
            .onChange(of: selectedPhoto) {
            //as soon as something gets picked

                Task {
                    if let data = try? await selectedPhoto?.loadTransferable(type: Data.self), let imageFound = try? await selectedPhoto?.loadTransferable(type: Image.self)
                        //as soon as something is selected, transfer that photos data type to that of Data.
                    {
                        extractedImage = imageFound
                        imageAsData = data
                        
                    }
                }
            }
    }
    
    var createRewardButton: some View {
        Button("Create Reward"){

            if let imageAsDataToSave = imageAsData {
                saveToDocumentsDirectory(data: imageAsDataToSave)
            } else {
                saveWithoutPicture()
            }
            
            dismiss()
            
        }.buttonStyle(.borderedProminent).font(.title).disabled(rewardName.isEmpty).padding(.top, 10)
    }
    
    var recommendedText: some View {
        HStack {
            Text("(Recommended)")
            Spacer()
        }.foregroundStyle(.gray)
    }
    
    var rewardLetterCountOfMax: some View {
        Text("(\(rewardName.count)/\(maxLength))").foregroundStyle(.gray).opacity(0.7)
    }
    
    var creditsRequiredToUnlockText: some View {
        HStack {
            Text("Credits Required To Unlock").font(.title3).bold()
            Spacer()
        }
    }
    
    var uploadAPictureOfRewardText: some View {
        HStack {
            
            Text("Upload A Picture Of Your Reward").font(.title3).bold()
            Spacer()
        }
    }
    
    func saveWithoutPicture(){
        //properties in @Observable class. @Environment valus in functions.
        
        let reward = Reward(context: moc)
        reward.rewardName = rewardName
        reward.creditsRequired = Int64(creditsToUnlock)
        
        do {
            
            try moc.save()
            
        } catch {
            
            print("Error saving to Core Data: \(error)")
            
        }
    }
    
    func saveToDocumentsDirectory(data: Data) {
            
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

#Preview {
    let loadCoreData = LoadCoreData()
    
    AddRewardView().environment(\.managedObjectContext, loadCoreData.container.viewContext)
}
