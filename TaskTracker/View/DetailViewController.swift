//
//  DetailViewController.swift
//  TaskTracker
//
//  Created by Владимир on 14.08.2023.
//

import UIKit

class DetailViewController: UIViewController {
    
    var viewModel: DetailViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: Colors.background.rawValue)
    }

}
