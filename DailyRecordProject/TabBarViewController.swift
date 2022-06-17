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
        tabBar.tintColor = .CustomBlack
        tabBar.unselectedItemTintColor = .systemGray3
        selectedIndex = 1
    }
    
    private func configureChildViewControllers() {
        let calendarVC = UINavigationController(rootViewController: CalendarViewController())
        calendarVC.tabBarItem.selectedImage = UIImage(systemName: "calendar")
        calendarVC.tabBarItem.title = "캘린더"
        calendarVC.tabBarItem.image = UIImage(systemName: "calendar")
        
        let settingVC = UINavigationController(rootViewController: SettingViewController())
        settingVC.tabBarItem.selectedImage = UIImage(systemName: "gearshape.fill")
        settingVC.tabBarItem.title = "설정"
        settingVC.tabBarItem.image = UIImage(systemName: "gearshape.fill")
        
        let analysisVC = UINavigationController(rootViewController: AnalysisViewController())
        analysisVC.tabBarItem.selectedImage = UIImage(systemName: "chart.pie.fill")
        analysisVC.tabBarItem.title = "분석"
        analysisVC.tabBarItem.image = UIImage(systemName: "chart.pie.fill")
        
        let listVC = UINavigationController(rootViewController: ListViewController())
        listVC.tabBarItem.selectedImage = UIImage(systemName: "list.bullet")
        listVC.tabBarItem.title = "모아보기"
        listVC.tabBarItem.image = UIImage(systemName: "list.bullet")
        
        viewControllers = [analysisVC, calendarVC, listVC, settingVC]
    }
}
