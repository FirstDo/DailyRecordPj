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
    var temp = [DailyInfoEntity]()
    var listDict  = [Int: DailyInfoEntity]()
    
    
    
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
        //초기화 코드: 현재 페이지의 년 월 로 fetch
        let currentPageData = calendar.currentPage
        let month = Calendar.current.component(.month, from: currentPageData)
        let year = Calendar.current.component(.year, from: currentPageData)
        //temp에 data fetch
        temp = DataManager.shared.fetchTask(Int16(month), Int16(year))
        //listDict에 일: entity 로 정렬
        temp.forEach { entity in
            let date = entity.date
            if let idx = date?.lastIndex(of: "."), let day = Int((date?[idx...].dropFirst())!) {
                listDict[day] = entity
            }
        }
        
        //옵져버
        token = NotificationCenter.default.addObserver(forName: .dataChanged, object: nil, queue: .main, using: { _ in
            let currentPageData = self.calendar.currentPage
            let month = Calendar.current.component(.month, from: currentPageData)
            let year = Calendar.current.component(.year, from: currentPageData)
            //temp에 data fetch
            self.temp = DataManager.shared.fetchTask(Int16(month), Int16(year))
            //listDict에 일: entity 로 정렬
            self.temp.forEach { entity in
                let date = entity.date
                if let idx = date?.lastIndex(of: "."), let day = Int((date?[idx...].dropFirst())!) {
                    self.listDict[day] = entity
                }
            }
        })
        
        view.backgroundColor = .systemBackground
        
        let backBarBtn = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = backBarBtn
        
        scrollViewSetting()
        calendarSetting()
        //contentViewSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        super.navigationController?.isNavigationBarHidden = false
    }
    
    lazy var contentView: ContentView = {
        let v = ContentView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
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

        let calendarHeight = view.frame.size.height / 3.0 * 2.0
        
        calendar.heightAnchor.constraint(equalToConstant: calendarHeight).isActive = true
        calendar.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        calendar.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        calendar.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor).isActive = true

    }
    
    func contentViewSetting(_ entity: DailyInfoEntity) {
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
        formatter.dateFormat = "yyyy.MM.dd"
        formatter.locale = Locale(identifier: "ko-kr")
        
        let selectedDate = formatter.string(from: date)
        print("선택한 날짜는 \(selectedDate)")
        
        let day = Calendar.current.component(.day, from: date)
        
        //내용이 있으면 보여주고
        if let entity = listDict[day]{
            contentViewSetting(entity)
            contentView.setData(entity)
        } else {
            contentView.removeFromSuperview()
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
        
        
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("deselect")
    }
}

