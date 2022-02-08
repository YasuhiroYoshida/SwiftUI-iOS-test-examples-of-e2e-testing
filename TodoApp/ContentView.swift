//
//  ContentView.swift
//  TodoApp
//
//  Created by Yasuhiro Yoshida on 2022/02/08.
//

import SwiftUI

struct ContentView: View {

  @State private var title: String = ""
  @State private var description: String = ""
  @State private var priority: String = "Medium"
  @State private var message: String = ""
  @State private var selectedTask: Task?

  @Environment(\.managedObjectContext) private var viewContext
  @FetchRequest(fetchRequest: Task.allTasksFetchRequest()) private var allTasks: FetchedResults<Task>

  private func saveTask() {

    if title.isEmpty {
      return
    }

    do {
      // see if the Task has already been added
      if let _ = Task.by(title: title) {
        message = "Task has already been added"
      } else {

        let task = Task(context: viewContext)
        task.title = title
        task.body = description
        task.priority = priority

        // save
        try viewContext.save()
      }
    } catch {
      print(error)
    }

    title = ""
    description = ""
    priority = "Medium"
  }

  var body: some View {
    NavigationView {

      VStack(spacing: 20) {
        TextField("Enter title", text: $title)
          .textFieldStyle(.plain)
          .accessibilityIdentifier("titleTextField")

        TextField("Enter description", text: $description)
          .textFieldStyle(.plain)
          .accessibilityIdentifier("descriptionTextField")

        Picker("Priority", selection: $priority) {
          Text("Low").tag("Low")
          Text("Medium").tag("Medium")
          Text("High").tag("High")
        }.pickerStyle(.segmented)

        Button("Save") {
          saveTask()
        }
        .padding(10)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .background(Color.gray)
        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
        .accessibilityIdentifier("saveButton")

        Text(message)
          .accessibilityIdentifier("errorMessage")

        List {
          ForEach(allTasks) { task in
            HStack {
              Text(task.title ?? "")
              Spacer()

              if task.isFavorite {
                Image(systemName: "heart.fill")
                  .accessibilityLabel("heart.fill")
                  .foregroundColor(.red)
              }

              Text(task.priority ?? "")
                .frame(maxWidth: 100)
            }
            .contentShape(Rectangle())
            .onTapGesture {
              self.selectedTask = task
            }
            .sheet(item: $selectedTask) {

            } content: { task in
              TaskDetailView(task: task)
            }
          }
          .onDelete { indexSet in
            indexSet.forEach { index in
              let task = allTasks[index]
              viewContext.delete(task)

              do {
                try viewContext.save()
              } catch {
                print(error)
              }
            }
          }
        }
        .accessibilityIdentifier("tasksList")

        Spacer()

      }
      .padding()
      .navigationTitle("Tasks")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    let persistedContainer = CoreDataManager.shared.persistentContainer
    ContentView().environment(\.managedObjectContext, persistedContainer.viewContext)
  }
}
