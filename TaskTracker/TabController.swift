//
//  TabController.swift
//  TaskTracker
//
//  Created by Владимир on 13.08.2023.
//

import UIKit

class TabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        // Do any additional setup after loading the view.
    }
    
    private func setupTabs () {
        let mainController = MainViewController()
        let calendarController = CalendarViewController()
        let cabinetController = CabinetViewController()

        let home = self.createNav(with: "Главная", and: UIImage(systemName: "house"), viewController: mainController)
        let checkout = self.createNav(with: "Календарь", and: UIImage(systemName: "calendar"), viewController: calendarController)
        let cabinet = self.createNav(with: "Профиль", and: UIImage(systemName: "person.circle.fill"), viewController: cabinetController)
        
        self.tabBar.tintColor = UIColor.black

        self.setViewControllers([home, checkout, cabinet], animated: true)
        
    }
    
    private func createNav (with title: String, and image: UIImage?, viewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: viewController)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
                
        return nav
    }
}
