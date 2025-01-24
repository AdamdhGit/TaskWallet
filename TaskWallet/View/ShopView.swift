//
//  ShopView.swift
//  TaskWallet
//
//  Created by Adam Heidmann on 1/7/25.
//

import ConfettiSwiftUI
import CoreData
import SwiftUI

struct ShopView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Binding var credits: Int
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Reward.rewardName, ascending: true)]) var rewards: FetchedResults<Reward>
    @State var addRewardSheetIsShowing = false
    @State var editModeOn = false
    @State var counter = 0
    @State var selectedShopView = "Rewards"
    var shopViewTypes = ["Rewards", "Redemptions"]
    
    var body: some View {
        
        VStack {
            
            Text("Shop Rewards").font(.title).bold().padding(.top, 30)
            
            HStack {
                
                displayCredits
                
                Spacer().frame(width: 10)
                
                HStack {
                    
                    Button {
                        
                        addRewardSheetIsShowing.toggle()
                        selectedShopView = "Rewards"
                        
                    } label: {
                        
                        addRewardButton
                        
                    }
                    
                }.foregroundStyle(.orange)
                
            }.frame(height: 40)
            
            Divider().padding(.top, 20).padding(.bottom, 20)
            
            if !rewards.isEmpty {
                
                shopViewStylePicker
                
                if selectedShopView == "Rewards" {
                    
                    if rewards.filter({ $0.archived == false }).count >= 1 {
                        
                        ScrollView {
                            
                            editRewardsButton
                            
                            DisplayRewardsView(editModeOn: $editModeOn, credits: $credits, counter: $counter)
                            
                        }
                        
                    } else {
                        
                        noCurrentRewardsText
                        
                    }
                    
                } else if selectedShopView == "Redemptions" {
                    
                    if rewards.filter({ $0.archived == true }).count >= 1 {
                        
                        ScrollView {
                            
                            editRedemptionsButton
                            
                            DisplayRedemptionsView(editModeOn: $editModeOn, credits: $credits, counter: $counter)
                            
                        }
                        
                    } else {
                        
                        noArchivedRedemptionsText
                        
                    }
                    
                }
                
            } else {
                
                ContentUnavailableView("Rewards List Empty", systemImage: "cart", description: Text("Reward yourself for your hard work with something you've been dreaming of—like that vacation or those new shoes you've been putting off.")).frame(height: 250).padding(.top, 50)
                
                getStartedButton
                
            }
            
            Spacer()
            
        }
        .sheet(isPresented: $addRewardSheetIsShowing) {
            
            AddRewardView()
            
        }
        .confettiCannon(counter: $counter)
        
    }
    
    func retrieveFromDocumentsDirectory(imageUUID: String) -> UIImage? {
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
    
    var displayCredits: some View {
        HStack {
            Image(systemName: "dollarsign.circle.fill").font(.title2).foregroundStyle(.purple)
            Text("Credits: \(credits)").bold()
            
        }.foregroundStyle(.purple).bold()
            .padding(.horizontal, 15)
            .frame(maxHeight: .infinity)
        // Add padding inside the overlay
            .background(
                //.overlay doesn't mix with padding. use border in that case.
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
                    .foregroundColor(.purple)
            )
    }
    
    var addRewardButton: some View {
        HStack {
            Image(systemName: "plus").font(.title2)
            Text("Add Reward").bold()
        }
        .padding(.horizontal, 15)
        .frame(maxHeight: .infinity)
        // Add padding inside the overlay
        .background(
            //.overlay doesn't mix with padding. use border in that case.
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 2)
        )
    }
    
    var shopViewStylePicker: some View {
        Picker("Shop View Style", selection: $selectedShopView) {
            
            ForEach(shopViewTypes, id: \.self){i in
                Text(i)
            }
            
        }.pickerStyle(.segmented)
            .padding(.horizontal)
    }
    
    var editRewardsButton: some View {
        HStack {
            Spacer()
            Button(editModeOn ? "Done Editing" : "Edit Rewards"){
                editModeOn.toggle()
            }.padding()
        }.foregroundStyle(.gray)
            .opacity(0.7)
    }
    
    var editRedemptionsButton: some View {
        HStack {
            Spacer()
            Button(editModeOn ? "Done Editing" : "Edit Redemptions"){
                editModeOn.toggle()
            }.padding()
        }.foregroundStyle(.gray)
            .opacity(0.7)
    }
    
    var noArchivedRedemptionsText: some View {
        Text("No Archived Redemptions").padding(.top, 30).foregroundStyle(.gray).opacity(0.7).font(.title3)
    }
    
    var noCurrentRewardsText: some View {
        Text("No Current Rewards").padding(.top, 30).foregroundStyle(.gray).opacity(0.7).font(.title3)
    }
    
    var getStartedButton: some View {
        Button("Get Started"){
            addRewardSheetIsShowing.toggle()
            selectedShopView = "Rewards"
        }.buttonStyle(.borderedProminent)
    }
    
}

#Preview {
    ShopView(credits: .constant(1))
}
