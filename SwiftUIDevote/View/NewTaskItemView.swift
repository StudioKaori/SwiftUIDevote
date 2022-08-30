//
//  NewTaskItemView.swift
//  SwiftUIDevote
//
//  Created by Kaori Persson on 2022-08-30.
//

import SwiftUI

struct NewTaskItemView: View {
    // MARK: - Properties
    @Environment(\.managedObjectContext) private var viewContext
    @State private var task: String = ""
    
    private var isNewTaskSaveButtonDisabled: Bool {
        task.isEmpty
    }
    
    // MARK: - Function
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = task
            newItem.id = UUID()
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
            // Empty the task text field
            task = ""
            hideKeyboard()
        }
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            Spacer()
            
            // New Task text field
            VStack(spacing: 16){
                TextField("New Task", text: $task)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                
                // Save button
                Button(action: {
                    addItem()
                }, label: {
                    Spacer()
                    Text("Save")
                    Spacer()
                })
                .disabled(isNewTaskSaveButtonDisabled)
                .padding()
                .font(.headline)
                .foregroundColor(.white
                )
                .background(isNewTaskSaveButtonDisabled ? Color.gray: Color.pink)
                .cornerRadius(10)
            } //: Vstack
            .padding(.horizontal)
            .padding(.vertical, 20)
            
        } //: Vstack
    }
}

struct NewTaskItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskItemView()
            .previewDevice("iPhone 12 Pro")
            .background(Color.gray.edgesIgnoringSafeArea(.all))
    }
}
