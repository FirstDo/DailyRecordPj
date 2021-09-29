//
//  TabBarViewController.swift
//  DailyRecordProject
//
//  Created by 김도연 on 2021/09/28.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .red
        tabBar.unselectedItemTintColor = .blue
        
        
        let CalendarVC = UINavigationController(rootViewController: CalendarViewController())
        CalendarVC.tabBarItem.selectedImage = UIImage(systemName: "calendar")
        CalendarVC.tabBarItem.title = "캘린더"
        CalendarVC.tabBarItem.image = UIImage(systemName: "calendar")
        
        let SettingVC = UINavigationController(rootViewController: SettingViewController())
        SettingVC.tabBarItem.selectedImage = UIImage(systemName: "command")
        SettingVC.tabBarItem.title = "설정"
        SettingVC.tabBarItem.image = UIImage(systemName: "command")
        
        let AnalysisVC = UINavigationController(rootViewController: AnalysisViewController())
        AnalysisVC.tabBarItem.selectedImage = UIImage(systemName: "chart.pie.fill")
        AnalysisVC.tabBarItem.title = "분석"
        AnalysisVC.tabBarItem.image = UIImage(systemName: "chart.pie.fill")
        
        let ListVC = UINavigationController(rootViewController: ListViewController())
        ListVC.tabBarItem.selectedImage = UIImage(systemName: "list.bullet")
        ListVC.tabBarItem.title = "리스트"
        ListVC.tabBarItem.image = UIImage(systemName: "list.bullet")
        
        //viewControllers = [AnalysisVC, CalendarVC, ListVC, SettingVC]
        viewControllers = [AnalysisVC,CalendarVC,ListVC,SettingVC]
        
        
        // Do any additional setup after loading the view.
    }
    

}
