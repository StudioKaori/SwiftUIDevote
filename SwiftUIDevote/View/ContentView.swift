//
//  ContentView.swift
//  SwiftUIDevote
//
//  Created by Kaori Persson on 2022-08-24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // MARK: - Properties
    
    @State var task: String = ""
    
    private var isNewTaskSaveButtonDisabled: Bool {
        task.isEmpty
    }
    
    // Fetching data
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    
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
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            
            ZStack {
                VStack {
                    
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
                    .padding()
                    
                    
                    List {
                        ForEach(items) { item in
                            //                        NavigationLink {
                            //                            Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                            //                        } label: {
                            //                            Text(item.timestamp!, formatter: itemFormatter)
                            //                        }
                            VStack(alignment: .leading) {
                                Text(item.task ?? "")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            } //: list item
                        }
                        .onDelete(perform: deleteItems)
                    } //: list
                } //: Vstack
            }  //: Zstack
            .navigationTitle("Daily Tasks")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            } //: toolbar
        } //: NavigationView
    }
    
    
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
