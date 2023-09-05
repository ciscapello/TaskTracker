//
//  CreateCategoryViewModel.swift
//  TaskTracker
//
//  Created by Владимир on 14.08.2023.
//

import RxRelay
import RxCocoa
import RxSwift
import RealmSwift

class CreateCategoryViewModel: CreateCategoryViewModelProtocol {
    
    let disposeBag = DisposeBag()
    
    var title = BehaviorRelay(value: "")
    var subtitle = BehaviorRelay(value: "")
    var sectionType = BehaviorRelay(value: SectionType.columns)
    
    let realm = try! Realm()
    
    var formIsValid = false
    
    init () {
        Observable.combineLatest(title, subtitle, sectionType).subscribe { title, subtitle, type in
            if title.isEmpty {
                self.formIsValid = false
            } else {
                self.formIsValid = true
            }
        }.disposed(by: disposeBag)
    }
    
    func buttonDidPressed () {
        let section = Section(title: title.value, subtitle: subtitle.value, type: sectionType.value, tasks: List<Task>())
        try! realm.write {
            realm.add(section)
        }
    }
}
