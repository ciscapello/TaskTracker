//
//  DetailViewModel.swift
//  TaskTracker
//
//  Created by Владимир on 14.08.2023.
//

import Foundation

class DetailViewModel: DetailViewModelProtocol {
    var task: Task? = nil
    
    init(task: Task) {
        self.task = task
    }

}
