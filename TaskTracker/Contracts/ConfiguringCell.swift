//
//  ConfiguringCell.swift
//  TaskTracker
//
//  Created by Владимир on 13.08.2023.
//

import Foundation

protocol ConfiguringCell {
    static var identifier: String { get }
    func configure(with task: Task)
}
