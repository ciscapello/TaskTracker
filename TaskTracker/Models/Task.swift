//
//  Task.swift
//  TaskTracker
//
//  Created by Владимир on 26.08.2023.
//

import Foundation
import RealmSwift
import Realm

class Task: Object {
    @Persisted var id: String
    @Persisted var title: String
    @Persisted var descr: String
    @Persisted var updatedAt: Date
    @Persisted var textColor: String
    @Persisted var backgroundColor: String
    
    convenience init(title: String, descr: String, textColor: String, backgroundColor: String) {
        self.init()
        self.id = UUID().uuidString
        self.title = title
        self.descr = descr
        self.updatedAt = Date()
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }
}
