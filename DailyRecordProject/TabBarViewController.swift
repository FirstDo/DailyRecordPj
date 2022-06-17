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
        tabBar.tintColor = .CustomBlack
        tabBar.unselectedItemTintColor = .systemGray3
        
        let calendarVC = UINavigationController(rootViewController: CalendarViewController())
        calendarVC.tabBarItem.selectedImage = UIImage(systemName: "calendar")
        calendarVC.tabBarItem.title = "캘린더"
        calendarVC.tabBarItem.image = UIImage(systemName: "calendar")
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "Setting") as? SettingViewController else { return }

        
        let settingVC = UINavigationController(rootViewController: vc)
        //let SettingVC = UINavigationController(rootViewController: SettingViewController())
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
        
        viewControllers = [analysisVC,calendarVC,listVC,settingVC]
        selectedIndex = 1
    }
}
