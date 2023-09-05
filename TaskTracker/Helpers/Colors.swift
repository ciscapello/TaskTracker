//
//  Color.helpers.swift
//  TaskTracker
//
//  Created by Владимир on 13.08.2023.
//

import UIKit

enum Colors: String {
    case background = "background"
    case fieldBackground = "fieldBackground"
    case mainText = "mainText"
    case fieldText = "fieldText"
    case placeholder = "placeholder"
    case buttonBackground = "buttonBackground"
    case buttonText = "buttonText"
    case borderColor = "borderColor"
    case sectionHeader = "sectionHeader"
}

struct ColorForTask {
    let backgroundColor: UIColor
    let textColor: UIColor
    let name: String
}

class TaskColors {
    static let colors = [ColorForTask(backgroundColor: UIColor(hexString: "#34baeb"), textColor: UIColor(hexString: "#092a36"), name: "Голубой"),
                         ColorForTask(backgroundColor: UIColor(hexString: "#cf3691"), textColor: UIColor(hexString: "#451330"), name: "Розовый"),
                         ColorForTask(backgroundColor: UIColor(hexString: "#ab2e43"), textColor: UIColor(hexString: "#290a0f"), name: "Красный"),
                         ColorForTask(backgroundColor: UIColor(hexString: "#bdb133"), textColor: UIColor(hexString: "#121105"), name: "Жёлтый"),
                         ColorForTask(backgroundColor: UIColor(hexString: "#0f8c26"), textColor: UIColor(hexString: "#031707"), name: "Зелёный"),
                         ColorForTask(backgroundColor: UIColor(hexString: "#e37610"), textColor: UIColor(hexString: "#0a0602"), name: "Оранжевый")
                        ]

}
