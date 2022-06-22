//
//  TabBarViewController.swift
//  DailyRecordProject
//
//  Created by dudu on 2021/09/28.
//

import UIKit

final class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        configureTabBar()
        configureChildViewControllers()
    }
    
    private func configureTabBar() {
        tabBar.unselectedItemTintColor = .systemGray3
        selectedIndex = 1
    }
    
    private func configureChildViewControllers() {
        let calendarVC = UINavigationController(rootViewController: CalendarViewController())
        calendarVC.tabBarItem.selectedImage = UIImage(systemName: "calendar")
        calendarVC.tabBarItem.title = "캘린더"
        calendarVC.tabBarItem.image = UIImage(systemName: "calendar")
        
        viewControllers = [calendarVC]
    }
}
