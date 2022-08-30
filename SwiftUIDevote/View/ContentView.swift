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
    @State private var showNewTaskItem: Bool = false
    
    // Fetching data
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    
    // MARK: - Function
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
                // MARK: - Main View
                
                VStack {
                    // MARK: - Header
                    Spacer(minLength: 80)
                    
                    // MARK: - New task button
                    Button(action: {
                        showNewTaskItem = true
                    }, label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                        Text("New Task")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.blue)
                    })
                    // MARK: - Tasks
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
                    .listStyle(InsetGroupedListStyle())
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12)
                    .padding(.vertical, 0)
                    .frame(maxWidth: 640)
                } //: Vstack
                
                // MARK: - New task Item
            }  //: Zstack
            .onAppear() {
                UITableView.appearance().backgroundColor = UIColor.clear
            }
            .navigationTitle("Daily Tasks")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            } //: toolbar
            .background(
                BackgroundImageView()
            )
            .background(
                backgroundGradient.ignoresSafeArea(.all)
            )
        } //: NavigationView
        // show only single column
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
