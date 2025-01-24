//
//  TaskDetailView.swift
//  TaskWallet
//
//  Created by Adam Heidmann on 1/7/25.
//

//since just optionals used for preview in this drilled in view, don't need to import CoreData.
import CoreData
import SwiftUI


struct TaskDetailView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @State var task: UserTask
    @State var hoursSpent: Int = 1
    @State var markedAsComplete = false
    @Binding var credits: Int
    
    var body: some View {
        
        VStack {
            
            Text(task.name ?? "Test").font(.title).bold().padding(.top, 10)
            
            if task.accumulationStyle == "Action Based" {
                
               actionBasedTask
                
            } else if task.accumulationStyle == "Hour Based" {
                
                hourBasedTask
                
            }
            
            Divider().opacity(0.7).padding(.top, 40)
            
            if let recentEntries = task.recentEntry as? Set<RecentEntry> {
                
                if recentEntries.count >= 1 {
                    
                    recentEntriesTitle
                    
                } else {
                    
                    ContentUnavailableView("No Recent Entries", systemImage: "list.dash")
                    
                }
                
                if task.accumulationStyle == "Action Based" {
                    
                    ScrollView {
                        
                        ForEach(Array(recentEntries.sorted(by: { ($0.dateSaved ?? Date()) > ($1.dateSaved ?? Date()) }))) { entry in
                            
                            if let date = entry.dateSaved {
                                //conditional, show the view.
                                //***can't just put formateDateAsString, because yes that returns a string, but without putting it in Text, it isn't a view!
                                
                                HStack {
                                    
                                    Text(formatDateAsString(date: date))
                                    Spacer()
                                    
                                }.padding(.horizontal).padding(.bottom, 5)
                                .opacity(0.8)
                            } else {
                                
                                Text("No Date Available")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                            }
                        }
                    }
                    
                } else if task.accumulationStyle == "Hour Based" {
                   
                    ScrollView {
                        
                        ForEach(Array(recentEntries.sorted(by: { ($0.dateSaved ?? Date()) > ($1.dateSaved ?? Date()) }))) { entry in
                            
                            if let date = entry.dateSaved {
                                //conditional, show the view.
                                //***can't just put formateDateAsString, because yes that returns a string, but without putting it in Text, it isn't a view!
                                
                                HStack {
                                    
                                    Text("\(entry.creditsReceived) \(entry.creditsReceived == 1 ? "Hour" : "Hours") on \(formatDateAsString(date: date))")
                                    Spacer()
                                    
                                }.padding(.horizontal).padding(.bottom, 5)
                                    .opacity(0.8)
                                
                            } else {
                                
                                Text("No Date Available")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                            }
                        }
                    }
                }
            }
            
            Spacer()
            
        }.toolbar {
            ToolbarItem {
                Button {
                    moc.delete(task)
                    try? moc.save()
                    dismiss()
                } label: {
                    Image(systemName: "trash").foregroundStyle(.red)
                }
            }
        }
    }
    
    func formatDateAsString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy h:mm a"
        return dateFormatter.string(from: date)
    }
    
    var actionBasedTask: some View {
        VStack {
            Text("Did you finish this task today?").padding(.top, 30).font(.title3)
            Button(markedAsComplete ? "+1 Credit!" : "Mark as Complete") {
                
                credits += 1
                markedAsComplete.toggle()
                
                let newRecentEntry = RecentEntry(context: moc)
                newRecentEntry.dateSaved = Date()
                newRecentEntry.origin = task
                
                do {
                    try moc.save()
                    print(task.recentEntry?.count ?? 0)
                } catch {
                    print("Could not save recent entry.")
                }
                
            }.buttonStyle(.borderedProminent).tint(.blue).font(.title3).padding(.top, 10).disabled(markedAsComplete ? true : false).foregroundStyle(markedAsComplete ? .purple : .white)
            //**when drilled into a preview, just fill the optional part in to make it work for placeholders.
        }
    }
    
    var hourBasedTask: some View {
        VStack{
            Text("How many hours did you spend on this task today?").padding(.top, 30).font(.title3)
            Stepper("\(hoursSpent) \(hoursSpent == 1 ? "hour" : "hours")", value: $hoursSpent, in: 1...12).padding(.horizontal).padding(.top, 10).frame(width: 200)
                .disabled(markedAsComplete)
            Button(markedAsComplete ? "+\(hoursSpent) Credits!" : "Mark as Complete") {
                
                credits += hoursSpent
                markedAsComplete.toggle()
                
                let newRecentEntry = RecentEntry(context: moc)
                newRecentEntry.dateSaved = Date()
                newRecentEntry.creditsReceived = Int64(hoursSpent)
                newRecentEntry.origin = task
                
                do {
                    try moc.save()
                    print(task.recentEntry?.count ?? 0)
                } catch {
                    print("Could not save recent entry.")
                }
                
            }.buttonStyle(.borderedProminent).tint(.blue).font(.title3).padding(.top, 20).disabled(markedAsComplete ? true : false).foregroundStyle(markedAsComplete ? .purple : .white)
        }
    }
    
    var recentEntriesTitle: some View {
        HStack{
            Text("Recent Entries")
            Spacer()
        }.padding()
    }
}

#Preview {
    let container = NSPersistentContainer(name: "CoreData")

    container.loadPersistentStores { _, error in
        if let error = error {
            fatalError("Core Data failed to load: \(error.localizedDescription)")
        }
    }

    let context = container.viewContext
    let previewTask = UserTask(context: context)
    //pass in mock data.
    previewTask.name = "Test Task"
    previewTask.accumulationStyle = "Hour Based"

    return TaskDetailView(task: previewTask, credits: .constant(1))
        .environment(\.managedObjectContext, context)
}

//***we specify our file that contains our CoreData, we load the CoreData, we make the context of the core data accessible, we create a mock object, we pass that object into the preview.
