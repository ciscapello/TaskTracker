//
//  CreateTaskViewModel.swift
//  TaskTracker
//
//  Created by Владимир on 14.08.2023.
//

import Foundation
import RxRelay
import RxSwift
import RxCocoa
import RealmSwift

class CreateTaskViewModel: CreateTaskViewModelProtocol {
    
    let disposeBag = DisposeBag()
    
    let descr = BehaviorRelay(value: "")
    var color = BehaviorRelay(value: TaskColors.colors[0])
    var title = BehaviorRelay(value: "")
    var isValid = false
    
    var category: String?
    var categoryId: String
    
    let realm = try! Realm()
    
    
    init(category: String, categoryId: String) {
        self.category = category
        self.categoryId = categoryId
        
        Observable.combineLatest(title, descr, color).subscribe { title, descr, color in
            print(title, descr, color.name)
            if !title.isEmpty, !descr.isEmpty {
                self.isValid = true
            } else {
                self.isValid = false
            }
        }.disposed(by: disposeBag)
    }
    
    func buttonPressed() {
        let task = Task(title: title.value, descr: descr.value, textColor: UIColor().hexStringFromColor(color: color.value.textColor), backgroundColor: UIColor().hexStringFromColor(color: color.value.backgroundColor))
        let sections = realm.objects(Section.self)
        let section = sections.where {
            $0.id == categoryId
        }
        try! realm.write {
            realm.add(task)
            section[0].tasks.insert(task, at: 0)
        }
    }
}

