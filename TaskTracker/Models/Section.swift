//
//  Section.swift
//  TaskTracker
//
//  Created by Владимир on 26.08.2023.
//

import Foundation
import RealmSwift
import Realm

class Section: Object {
    @Persisted var id: String
    @Persisted var title: String
    @Persisted var subtitle: String?
    @Persisted var type: SectionType
    @Persisted var tasks: List<Task>
    
    typealias Item = Task
    
    convenience init(title: String, subtitle: String?, type: SectionType, tasks: List<Task>) {
        self.init()
        self.id = UUID().uuidString
        self.title = title
        self.subtitle = subtitle
        self.type = type
        self.tasks = tasks
    }
}


enum SectionType: String, PersistableEnum {
    case columns = "columns"
    case table = "table"
    case row = "row"
}

