//
//  Placeholder.swift
//  TaskTracker
//
//  Created by Владимир on 15.08.2023.
//

import Foundation

class Placeholder {
    static func randomCategoryTitle () -> String {
        let placeholders = ["Например, 'Личное'", "Например, 'Работа'", "Например, 'Домашние дела'", "Скажем, 'Духовное'", "'Социальное', как пример"]
        return placeholders.randomElement() ?? "never"
    }
    
    static func randomCategorySubtitle () -> String {
        let placeholders = ["Например, 'То, что необходимо было сделать уже вчера'", "Скажем, 'Что необходимо сделать на пути к цели X'", "Как пример, 'Сложные задачи требущие большого внимания'"]
        return placeholders.randomElement() ?? "never"
    }
}
