//
//  CreateCategoryViewController.swift
//  TaskTracker
//
//  Created by Владимир on 14.08.2023.
//

import UIKit
import RxCocoa


protocol CreateCategoryViewModelProtocol {
    var title: BehaviorRelay<String> { get set }
    var subtitle: BehaviorRelay<String> { get set }
    var sectionType: BehaviorRelay<SectionType> { get set }
    var formIsValid: Bool { get set }
    func buttonDidPressed ()
}
