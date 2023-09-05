//
//  TaskModel.swift
//  TaskTracker
//
//  Created by Владимир on 13.08.2023.
//

import Foundation

class TaskModel {
    let id: UUID
    let title: String
    let description: String
    let deadline: Date
    let priority: Priority
    
    init(title: String, description: String, deadline: Date, priority: Priority) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.deadline = deadline
        self.priority = priority
    }
    
    func priorityLabel () -> String {
        switch priority {
        case .low:
            return "Низкий приоритет"
        case .normal:
            return "Средний приоритет"
        case .high:
            return "Высокий приоритет"
        }
    }
}

enum Priority {
    case low
    case normal
    case high
}

extension TaskModel: Hashable, Equatable {
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (lhs: TaskModel, rhs: TaskModel) -> Bool {
        lhs.id == rhs.id
    }

}
