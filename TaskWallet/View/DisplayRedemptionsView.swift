//
//  DisplayRedemptionsView.swift
//  TaskWallet
//
//  Created by Adam Heidmann on 1/19/25.
//

import SwiftUI

struct DisplayRedemptionsView: View {
    
    @State var viewModel = DisplayRedemptionsViewViewModel()
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Reward.rewardName, ascending: true)]) var rewards: FetchedResults<Reward>
    @Binding var editModeOn: Bool
    @Binding var credits: Int
    @Binding var counter: Int
    
    var body: some View {
        
        ForEach(rewards){i in
            
            if i.archived {
                
                VStack {
                    
                    HStack {
                        
                        Spacer()
                        
                        if editModeOn {
                            
                            Button(role: .destructive){
                                
                                moc.delete(i)
                                try? moc.save()
                                editModeOn = false
                                
                            }label:{
                                
                                removeRedemptionButton
                                
                            }
                        }
                    }
                    
                    HStack {
                        
                        //for EACH reward:
                        if let imageUUID = i.imageUUID {
                            //if the reward has an imageUUID stored, proceed.
                            
                            let rewardUIImage = viewModel.retrieveFromDocumentsDirectory(imageUUID: imageUUID)
                            
                            if UIDevice.current.userInterfaceIdiom == .phone {
                                
                                Image(uiImage: rewardUIImage ?? UIImage()).resizable().aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                
                            } else if UIDevice.current.userInterfaceIdiom == .pad {
                                
                                Image(uiImage: rewardUIImage ?? UIImage()).resizable().aspectRatio(contentMode: .fill)
                                    .frame(width: 200, height: 200)
                                    .clipShape(Circle())
                                
                            }
                            
                        } else {
                            
                            if UIDevice.current.userInterfaceIdiom == .phone {
                                
                                Image(systemName: "gift").resizable()
                                    .frame(width: 100, height: 100).foregroundStyle(.orange).opacity(0.6).fontWeight(.light)
                           
                            } else if UIDevice.current.userInterfaceIdiom == .pad {
                                
                                Image(systemName: "gift")
                                    .resizable()
                                    .frame(width: 200, height: 200).foregroundStyle(.orange).opacity(0.6).fontWeight(.light)
                                
                            }
                        }
                        
                        Spacer()
                        
                        VStack {
                            
                            if UIDevice.current.userInterfaceIdiom == .phone {
                                
                                Text(i.rewardName ?? "").padding(.top, 10)
                                
                            } else if UIDevice.current.userInterfaceIdiom == .pad {
                                
                                Text(i.rewardName ?? "").font(.title).padding(.top, 10)
                                
                            }

                            HStack {
                                if i.redeemPressed {
                                    
                                    lockOpenImage
                                    
                                } else {
                                    
                                    lockClosedImage
                                }
                                
                                Text("\(String(i.creditsRequired)) \(i.creditsRequired == 1 ? "Credit" : "Credits")")
                                
                            }.padding(.top, 10).bold()
                            
                            
                            Button {
                                credits -= Int(i.creditsRequired)
                                i.redeemPressed.toggle()
                                try? moc.save()
                                //***call moc.save() anytime a core data property is changed in value by a button, or just changed at all.
                                
                                counter += 1
                                
                                
                            } label: {
                                if i.redeemPressed {
                                    HStack(spacing: 5){
                                        Image(systemName: "checkmark.circle")
                                        Text("Redeemed")
                                    }
                                } else {
                                    Text("Redeem")
                                }
                            }
                            .disabled(credits < i.creditsRequired ? true : false).buttonStyle(.borderedProminent).tint(.purple).foregroundStyle(i.redeemPressed ? .green : .white)
                            .disabled(i.redeemPressed)
                            
                        }
                        
                        Spacer()
                        
                    }
                    Divider().opacity(0.7).padding(.horizontal).padding(.top, 15)
                }
            }
        }.padding()
    }
    
    var lockOpenImage: some View {
        Image(systemName: "lock.open.fill").foregroundStyle(.orange)
    }
    
    var lockClosedImage: some View {
        Image(systemName: "lock.fill")
    }
    
    var removeRedemptionButton: some View {
        HStack(spacing: 5){
            
            Text("Remove")
            Image(systemName: "trash").opacity(0.7)
            
        }.foregroundStyle(.red)
    }
    
}

#Preview {
    DisplayRedemptionsView(editModeOn: .constant(false), credits: .constant(0), counter: .constant(0))
}
