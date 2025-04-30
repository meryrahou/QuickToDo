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
    var createdDate: Date // Added property to track the creation date
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
        let newTask = Task(title: title, createdDate: Date()) // Set createdDate to the current date and time
            tasks.insert(newTask, at: 0)
    }

    func toggleTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            withAnimation {
                tasks[index].isCompleted.toggle()
            }
        }
    }

    func deleteTask(task: Task) {
        tasks.removeAll { $0.id == task.id }
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
                .textFieldStyle(PlainTextFieldStyle())
                .padding(6)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .frame(height: 30)
                
                Button(action: {
                    if !newTaskTitle.isEmpty {
                        viewModel.addTask(title: newTaskTitle)
                        newTaskTitle = ""
                    }
                }) {
                    Image(systemName: "plus")
                        .padding(6)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .padding(.horizontal)
            
            // List Section for Tasks
            List {
                // Active Tasks Section
                Section(header:
                    Text("Active Tasks")
                ) {
                    ForEach(viewModel.tasks.filter { !$0.isCompleted }) { task in
                        HStack {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .onTapGesture {
                                    viewModel.toggleTask(task)
                                }
                            VStack(alignment: .leading) {
                                Text(task.title)
                                    .strikethrough(task.isCompleted)
                                Text("Created on: \(formattedDate(task.createdDate))")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let taskToDelete = viewModel.tasks.filter { !$0.isCompleted }[index]
                            viewModel.deleteTask(task: taskToDelete)
                        }
                    }
                }
                .listRowInsets(EdgeInsets())

                // Completed Tasks Section
                Section(header: Text("Completed Tasks")) {
                    ForEach(viewModel.tasks.filter { $0.isCompleted }) { task in
                        HStack {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .onTapGesture {
                                    viewModel.toggleTask(task)
                                }
                            VStack(alignment: .leading) {
                                Text(task.title)
                                    .strikethrough(task.isCompleted)
                                Text("Completed on: \(formattedDate(task.createdDate))")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let taskToDelete = viewModel.tasks.filter { $0.isCompleted }[index]
                            viewModel.deleteTask(task: taskToDelete)
                        }
                    }
                }
                .listRowInsets(EdgeInsets())
            }
        }
        .padding()
        .background(VisualEffectBackground())
    }
    
    // Helper function to format the date
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

