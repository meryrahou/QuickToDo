//
//  ContentView.swift
//  QuickToDo
//
//  Created by mery Rahou on 27/4/2025.
//

import SwiftUI

struct Task: Identifiable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
}

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = [] {
        didSet {
            saveTasks()
        }
    }

    private let tasksKey = "tasksKey"

    init() {
        loadTasks()
    }

    func addTask(title: String) {
        let newTask = Task(title: title)
        tasks.append(newTask)
    }

    func toggleTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }

    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }

    private func saveTasks() {
        if let data = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(data, forKey: tasksKey)
        }
    }

    private func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: tasksKey),
           let savedTasks = try? JSONDecoder().decode([Task].self, from: data) {
            tasks = savedTasks
        }
    }
}

struct ContentView: View {
    @StateObject private var viewModel = TaskViewModel()
    @State private var newTaskTitle = ""

    var body: some View {
        VStack {
            HStack {
                TextField("New Task", text: $newTaskTitle, onCommit: {
                    if !newTaskTitle.isEmpty {
                        viewModel.addTask(title: newTaskTitle)
                        newTaskTitle = ""
                    }
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    if !newTaskTitle.isEmpty {
                        viewModel.addTask(title: newTaskTitle)
                        newTaskTitle = ""
                    }
                }) {
                    Image(systemName: "plus")
                }
            }
            .padding()

            List {
                ForEach(viewModel.tasks) { task in
                    HStack {
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .onTapGesture {
                                viewModel.toggleTask(task)
                            }
                        Text(task.title)
                            .strikethrough(task.isCompleted)
                    }
                }
                .onDelete(perform: viewModel.deleteTask)
            }
        }
        .frame(width: 300, height: 400)
        .padding()
    }
}
