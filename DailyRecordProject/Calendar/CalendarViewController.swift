//
//  ViewController.swift
//  DailyRecordProject
//
//  Created by 김도연 on 2021/09/28.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController{
    
    //notification
    static let taskChanged = Notification.Name("taskChanged")
    var token: NSObjectProtocol?
    
    //dailyInfo
    var list = [DailyInfoEntity]()
    
    //scrollView
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    //FSCalendar
    let calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.headerHeight = 40
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24)
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    //ContentView
    let contentView: UIView = {
        let v = UIView()
        v.backgroundColor = .red
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    //label
    let lb: UILabel = {
        let lb = UILabel()
        lb.text = "hi"
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //옵져버
        token = NotificationCenter.default.addObserver(forName: CalendarViewController.taskChanged, object: nil, queue: .main, using: { _ in
            self.list = DataManager.shared.fetchTask(10)
            print(self.list)
        })
        
        
        view.backgroundColor = .systemBackground
        
        let backBarBtn = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = backBarBtn
        
        scrollViewSetting()
        calendarSetting()
        contentViewSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        super.navigationController?.isNavigationBarHidden = false
    }
    
    //Hide navigation Bar
}

//MARK: - scrollView, contentView, calendar
extension CalendarViewController {
    
    func scrollViewSetting() {
        view.addSubview(scrollView)
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        scrollView.addSubview(calendar)
    }
    
    func calendarSetting() {
        calendar.delegate = self
        calendar.dataSource = self
        
        let calendarHeight = view.frame.size.height - 350
        
        calendar.heightAnchor.constraint(equalToConstant: calendarHeight).isActive = true
        calendar.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        calendar.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        calendar.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    func contentViewSetting() {
        scrollView.addSubview(contentView)
        
        contentView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 30).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40).isActive = true
    }
}


extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.locale = Locale(identifier: "ko-kr")
        
        let now = formatter.string(from: date)
        
        //내용이 있으면 보여주고,
        
        //내용이 없으면 새 내용을 만들자.
        UserInputData.shared.cleanData()
        UserInputData.shared.date = now
        let vc = InputViewController()
        InputViewController.isEdit = false
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("deselect")
    }
}

