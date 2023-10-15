//
//  ContentView.swift
//  TestProject<CoreData>
//
//  Created by Anonymous on 14/10/2023.
//

import SwiftUI
import CoreData




struct ContentView: View{
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
            animation: .default)
    private var items: FetchedResults<Item>
    @State var primaryText: String = ""
    @State private var secondaryText: String = ""
    @State private var savedPrimaryText: String = ""
    var body: some View{
        NavigationStack{
            VStack{
                Text("Enter your message")
                TextField("Primary", text: $primaryText)
                    .padding()
                    .frame(width: 350, height: 30, alignment: .center)
                    .shadow(radius: 10)
                    .textFieldStyle(.roundedBorder)
                TextField("Secondary", text: $secondaryText)
                    .padding()
                    .frame(width: 250, height: 100, alignment: .center)
                    .textFieldStyle(.automatic)
                Text(savedPrimaryText)
                    .padding()
                
                HStack{
                    

                    NavigationLink(destination: Context_ContentView(primaryText: $primaryText)){
                        Text("Context")
                    }
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .frame(width: 100, height: 80, alignment: .center)
                            .foregroundColor(Color.white)
                    
                        
                        Button("Save text"){
                            saveText()
                        }.padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .frame(width: 200, height: 80, alignment: .center)
                            .foregroundColor(Color.white)
                    
                }.padding(.leading, 70)
            }
        }
    }
    
    private func saveText() {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.primaryText = primaryText

            do {
                try viewContext.save()
                savedPrimaryText = primaryText
          //      savedDate = newItem.timestamp
            } catch {
                let nsError = error as NSError
                fatalError("Не удается сохранить: \(nsError)")
            }
        }
   }










struct Context_ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @Binding var primaryText: String
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                        Text(primaryText)
                    } label: {
                        Text(item.timestamp!, formatter: itemFormatter)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.primaryText = primaryText
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
