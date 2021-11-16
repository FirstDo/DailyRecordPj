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
        
        // MARK: - color와 image 나중에 최종수정해야함
        tabBar.tintColor = .red
        tabBar.unselectedItemTintColor = .black
        
        let CalendarVC = UINavigationController(rootViewController: CalendarViewController())
        CalendarVC.tabBarItem.selectedImage = UIImage(systemName: "calendar")
        CalendarVC.tabBarItem.title = "캘린더"
        CalendarVC.tabBarItem.image = UIImage(systemName: "calendar")
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let vc = storyboard.instantiateViewController(withIdentifier: "Setting") as! SettingViewController

        
        let SettingVC = UINavigationController(rootViewController: vc)
        //let SettingVC = UINavigationController(rootViewController: SettingViewController())
        SettingVC.tabBarItem.selectedImage = UIImage(systemName: "command")
        SettingVC.tabBarItem.title = "설정"
        SettingVC.tabBarItem.image = UIImage(systemName: "command")
        
        let AnalysisVC = UINavigationController(rootViewController: AnalysisViewController())
        AnalysisVC.tabBarItem.selectedImage = UIImage(systemName: "chart.pie.fill")
        AnalysisVC.tabBarItem.title = "분석"
        AnalysisVC.tabBarItem.image = UIImage(systemName: "chart.pie.fill")
        
        let ListVC = UINavigationController(rootViewController: ListViewController())
        ListVC.tabBarItem.selectedImage = UIImage(systemName: "list.bullet")
        ListVC.tabBarItem.title = "모아보기"
        ListVC.tabBarItem.image = UIImage(systemName: "list.bullet")
        
        viewControllers = [AnalysisVC,CalendarVC,ListVC,SettingVC]
        selectedIndex = 1
        
    }
}
