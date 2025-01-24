//
//  ContentView.swift
//  TaskWallet
//
//  Created by Adam Heidmann on 1/6/25.
//

import CoreData
import SwiftUI

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \UserTask.name, ascending: true)]) var tasks: FetchedResults<UserTask>
    @State var addTaskSheetIsShowing = false
    @Binding var credits: Int
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
               taskWalletLogoAndName
                
                HStack {
                    
                    creditsDisplayed
                    
                    Spacer().frame(width: 10)
                    
                    addTaskButton
                    
                }.frame(height: 40)
                
                Divider().padding(.top, 20)
                
                if !tasks.isEmpty {
                 
                        VStack {
                            
                           tasksTitle
                            
                            if tasks.count == 1 {
                                
                                taskCreationGuideText
                                
                            }
                        }
                }
                
                if !tasks.isEmpty {
                    
                   tasksDisplayed
                    
                } else {
                    
                    ContentUnavailableView("Task List Empty", systemImage: "moon.zzz", description: Text("Set tasks, build habits, and stay on track toward your goals.")).frame(height: 250).padding(.top, 50)
                    
                    Button("Get Started"){
                        
                        addTaskSheetIsShowing.toggle()
                        
                    }.buttonStyle(.borderedProminent).tint(.blue)
                }
                
                Spacer()
                
            }
            .padding()
            .sheet(isPresented: $addTaskSheetIsShowing) {
                AddTaskView()
            }
        }
    }
    
    func assetLogoColor(preferredColorScheme: ColorScheme) -> String {
        if preferredColorScheme == .light { // Compiler knows this is referring to PreferredColorSchemeKey.light
            return "TaskWalletLogoAssetLight"
        } else if preferredColorScheme == .dark {
            return "TaskWalletLogoAssetDark"
        }
        return "TaskWalletLogoAssetLight"
    }
    
    var taskWalletLogoAndName: some View {
        HStack {
            Image(assetLogoColor(preferredColorScheme: colorScheme)).resizable().frame(width: 50, height: 50)
            Text("TaskWallet").font(.title).bold()
        }
    }
    
    var creditsDisplayed: some View {
        HStack {
            Image(systemName: "dollarsign.circle.fill").font(.title2).foregroundStyle(.purple).bold()
            Text("Credits: \(credits)").bold()
        }.foregroundStyle(.purple).bold()
            .padding(.horizontal, 15)
            .frame(maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
                    .foregroundColor(.purple)
            )
    }
    
    var addTaskButton: some View {
        HStack {
            Button {
                addTaskSheetIsShowing.toggle()
            } label: {
                HStack {
                        HStack {
                            Image(systemName: "plus").font(.title2)
                            Text("Add Task")
                        }
                    
                }.bold()
                .padding(.horizontal, 15)
                .frame(maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                )
            }
        }
    }
    
    var tasksTitle: some View {
        HStack {
            Text("Tasks").padding(.top, 10).font(.title2).bold().padding(.top, 10)
            Spacer()
        }
    }
    
    var taskCreationGuideText: some View {
        HStack {
            Text("Tap a task to view details and mark it complete.").padding(.bottom, 30).font(.caption).foregroundStyle(.gray)
            Spacer()
        }
    }
    
    var tasksDisplayed: some View {
        ScrollView {
            ForEach(tasks){i in
                NavigationLink(value: i) {
                    HStack {
                        Text(i.name ?? "").padding(.vertical, 20).font(.title3)
                        Spacer()
                    }.contentShape(Rectangle())
                    //content shape matches the size of the view it covers, or can be made larger with .frame
                }
                
                Divider().opacity(0.7)
            }.navigationDestination(for: UserTask.self) { selection in
                TaskDetailView(task: selection, credits: $credits)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 5)
        }
    }
}

#Preview {
    let loadCoreData = LoadCoreData()
    //for previews, simply make the core data loaded and accessible here.
    
    ContentView(credits: .constant(1)).environment(\.managedObjectContext, loadCoreData.container.viewContext)
    //then toss the core data into the environment's managed object context of the preview!
}
