//
//  MainViewModelProtocol.swift
//  TaskTracker
//
//  Created by Владимир on 13.08.2023.
//

import UIKit

protocol MainViewModelProtocol {
    var sections: [Section]? { get set }
    func taskDidPressed (with task: Task, from view: UIViewController)
    func createTaskDidPressed (with category: String, categoryId: String, from view: UIViewController)
    func createCategoryDidPressed (from view: UIViewController)
    func deleteTaskByIndexPath (_ indexPath: IndexPath)
}
