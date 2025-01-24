//
//  AddTaskView.swift
//  TaskWallet
//
//  Created by Adam Heidmann on 1/7/25.
//

import StoreKit
import SwiftUI

struct AddTaskView: View {
    
    @Environment(\.requestReview) var requestReview
    @State var taskName:String = ""
    var accumulationStyles:[String] = ["Action Based", "Hour Based"]
    @State var selectedAccumulationStyle:String = "Action Based"
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    @AppStorage("taskCreationCount") var taskCreationCount = 0
    
    var body: some View {
        
        VStack(spacing: 10) {
            
            Text("Create A New Task").font(.title).padding(.top, 30)
                .onChange(of: taskCreationCount) { oldValue, newValue in
                    if newValue == 4 {
                        requestReview()
                    }
                }
            
            Divider().padding(.horizontal)
            
            Text("Title Your Task").font(.title3).bold()
            
            Text("(Required)").opacity(0.5).offset(y:-7)
            
            TextField("Example: Workout", text: $taskName).padding(.horizontal)
            
            Divider().padding(.horizontal).opacity(0.5)
            
            Text("Credit Accumulation Style").font(.title3).bold()
            
            Picker("test", selection: $selectedAccumulationStyle) {
                ForEach(accumulationStyles, id: \.self){i in
                    Text(i)
                }
            }.pickerStyle(.segmented).padding()
            
            Text("Credits are earned at a rate of 1 per action or 1 per hour.").font(.footnote)
            
            Divider().padding(.horizontal).opacity(0.5)
            
            Button("Create Task"){
                
                taskCreationCount += 1
                
                let newTask = UserTask(context: moc)
                newTask.name = taskName
                newTask.accumulationStyle = selectedAccumulationStyle
                
                try? moc.save()
                
                dismiss()
                
            }.buttonStyle(.borderedProminent).tint(.blue).font(.title2).padding(.top, 30).disabled(taskName.isEmpty)
            
            Spacer()
  
        }.padding(.horizontal, 20)
    }
}

#Preview {
    AddTaskView()
}
