//
//  MainViewModel.swift
//  TaskTracker
//
//  Created by Владимир on 13.08.2023.
//

import UIKit
import CoreData
import RealmSwift
import RxRealm
import RxSwift


class MainViewModel: MainViewModelProtocol {
    var sections: [Section]?
    let realm = try! Realm()
    let disposeBag = DisposeBag()
    
    init() {
        let sections = realm.objects(Section.self)
        Observable.collection(from: sections).subscribe { sections in
            self.sections = sections.element?.toArray()
        }.disposed(by: disposeBag)
    }
    
    func taskDidPressed (with task: Task, from view: UIViewController) {
        let viewModel = DetailViewModel(task: task)
        let viewController = DetailViewController()
        viewController.viewModel = viewModel
        view.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func createTaskDidPressed (with category: String, categoryId: String, from view: UIViewController) {
        let viewModel = CreateTaskViewModel(category: category, categoryId: categoryId)
        let viewController = CreateTaskViewController()
        viewController.viewModel = viewModel
        view.navigationController?.present(viewController, animated: true)
    }
    
    func createCategoryDidPressed(from view: UIViewController) {
        let viewModel = CreateCategoryViewModel()
        let viewController = CreateCategoryViewController()
        viewController.viewModel = viewModel
        view.navigationController?.present(viewController, animated: true)
    }
    
    func deleteTaskByIndexPath(_ indexPath: IndexPath) {
        guard let task = sections?[indexPath.section].tasks[indexPath.item] else { return }
        try! realm.write {
            realm.delete(task)
        }
    }
}
