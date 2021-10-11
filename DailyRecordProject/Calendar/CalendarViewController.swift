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
    
    //label
    let lb: UILabel = {
        let lb = UILabel()
        lb.text = "hi"
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let month: Int16 = 10
        let year: Int16 = 2021
        
        //옵져버
        token = NotificationCenter.default.addObserver(forName: .dataChanged, object: nil, queue: .main, using: { _ in
            self.list = DataManager.shared.fetchTask(month,year)
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
        
        print(view.frame.height)
        
        let calendarHeight = view.frame.size.height / 3.0 * 2.0
        
        calendar.heightAnchor.constraint(equalToConstant: calendarHeight).isActive = true
        calendar.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        calendar.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        calendar.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    func contentViewSetting() {
        
        let calendarHeight = view.frame.size.height / 3.0 * 2.0
        
        let contentView = ContentView(frame: CGRect(x: 0, y: calendarHeight, width: view.safeAreaLayoutGuide.layoutFrame.width, height: 300))
        
        scrollView.addSubview(contentView)
        
        contentView.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 30).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40).isActive = true
    }
}


extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        formatter.locale = Locale(identifier: "ko-kr")
        
        let selectedDate = formatter.string(from: date)
        print("선택한 날짜는 \(selectedDate)")
        
        //내용이 있으면 보여주고,
        
        //내용이 없으면 새 내용을 만들자.
        
        //초기화
        UserInputData.shared.cleanData()
        InputViewController.entity = nil
        
        //날짜와 달 설정
        UserInputData.shared.date = selectedDate
        
        let curDate = Calendar.current.dateComponents([.month, .year], from: date)
        let (month, year) = (Int16(curDate.month!), Int16(curDate.year!))

        UserInputData.shared.month = month
        UserInputData.shared.year = year
        //push
        navigationController?.pushViewController(InputViewController(), animated: true)
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("deselect")
    }
}

