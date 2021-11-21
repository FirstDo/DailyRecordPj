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
    var weekToken: NSObjectProtocol?
    
    //dailyInfo
    var temp = [DailyInfoEntity]()
    var listDict  = [Int: DailyInfoEntity]()
    
    var globalEntity: DailyInfoEntity?
    
    
    lazy var formatter :DateFormatter =  {
        let f = DateFormatter()
        f.dateFormat = "yyyy.MM.dd"
        f.locale = Locale(identifier: "ko-kr")
        return f
    }()
    
    
    //FSCalendar
    let calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.headerHeight = 40
        calendar.placeholderType = .none
        
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24)
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    let nextButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .default)
        btn.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        btn.setImage(UIImage(systemName: "greaterthan.circle"), for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let prevButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(previousTapped), for: .touchUpInside)
        
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .default)
        btn.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        btn.setImage(UIImage(systemName: "lessthan.circle"), for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    @objc func nextTapped() {
        let date = Calendar.current.date(byAdding: .month, value: 1, to: calendar.currentPage)!
        calendar.setCurrentPage(date, animated: true)
    }
    
    @objc func previousTapped() {
        let date = Calendar.current.date(byAdding: .month, value: -1, to: calendar.currentPage)!
        calendar.setCurrentPage(date, animated: true)
    }
    
    let contentView: ContentView = {
        let v = ContentView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.tapButton.addTarget(self, action: #selector(makeNewReport), for: .touchUpInside)
        v.editButton.addTarget(self, action: #selector(editReport), for: .touchUpInside)
        v.deleteButton.addTarget(self, action: #selector(deleteReport), for: .touchUpInside)
        return v
    }()
    
    @objc func makeNewReport() {
        print("tapButton")
        navigationController?.pushViewController(InputViewController(), animated: true)
    }
    @objc func editReport() {
        guard let target = globalEntity else {
            print("Error. Edit Fail")
            return
        }
        
        let editVC = InputViewController()
        InputViewController.entity = target
        UserInputData.shared.setData(date: target.date, mood: target.mood, good: target.good, bad: target.bad, thanks: target.thanks, highlight: target.highlight, month: target.month, year: target.year)
        navigationController?.pushViewController(editVC, animated: true)
    }
    @objc func deleteReport() {
        guard let target = globalEntity else {
            print("Error. Edit Fail")
            return
        }
        let alertController = UIAlertController(title: "정말 삭제할까요?", message: nil, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            DataManager.shared.deleteTask(entity: target) {
                NotificationCenter.default.post(name: .dataChanged, object: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //초기화 코드: 현재 페이지의 년 월 로 fetch
        let currentPageData = calendar.currentPage
        let month = Calendar.current.component(.month, from: currentPageData)
        let year = Calendar.current.component(.year, from: currentPageData)
        //temp에 data fetch
        temp = DataManager.shared.fetchTask(Int16(month), Int16(year))
        //listDict에 일: entity 로 정렬
        listDict.removeAll()
        temp.forEach { entity in
            let date = entity.date
            if let idx = date?.lastIndex(of: "."), let day = Int((date?[idx...].dropFirst())!) {
                listDict[day] = entity
            }
        }
        
        //한주의 시작을 바꾸는 노티피케이션
        weekToken = NotificationCenter.default.addObserver(forName: .weekChanged, object: nil, queue: .main, using: { noti in
            if let noti = noti.userInfo?["week"] as? Int {
                self.calendar.firstWeekday = UInt(noti)
            }
        })
        
        //옵져버
        token = NotificationCenter.default.addObserver(forName: .dataChanged, object: nil, queue: .main, using: { _ in
            print("delete noti")
            let currentPageData = self.calendar.currentPage
            let month = currentPageData.month
            let year = currentPageData.year
            //let month = Calendar.current.component(.month, from: currentPageData)
            //let year = Calendar.current.component(.year, from: currentPageData)
            //temp에 data fetch
            self.temp = DataManager.shared.fetchTask(month, year)
            //listDict에 일: entity 로 정렬
            self.listDict.removeAll()
            self.temp.forEach { entity in
                let date = entity.date
                if let idx = date?.lastIndex(of: "."), let day = Int((date?[idx...].dropFirst())!) {
                    self.listDict[day] = entity
                }
            }
            print(self.listDict)
            let date = self.calendar.selectedDate!
            let day = Int(date.day)
            
            if let entity = self.listDict[day]{
                self.contentView.setData(entity)
                self.globalEntity = entity

            } else {
                self.contentView.setEmpty()
                let selectedDate = self.formatter.string(from: date)
                
                //초기화
                UserInputData.shared.cleanData()
                InputViewController.entity = nil
                //날짜와 달 설정
                UserInputData.shared.date = selectedDate
                
                let month = date.month, year = date.year
                
                UserInputData.shared.month = month
                UserInputData.shared.year = year
            }
        })
        view.backgroundColor = .systemBackground
        
        let backBarBtn = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = backBarBtn
        
        calendarSetting()
        contentViewSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.navigationController?.isNavigationBarHidden = true
        print(#function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        super.navigationController?.isNavigationBarHidden = false
        print(#function)
    }
}

//MARK: - contentView, calendar
extension CalendarViewController {
    func calendarSetting() {
        calendar.delegate = self
        calendar.dataSource = self
        
        view.addSubview(calendar)
        let calendarHeight = view.frame.size.height / 3.0 * 1.5
        calendar.heightAnchor.constraint(equalToConstant: calendarHeight).isActive = true
        calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        view.addSubview(prevButton)
        prevButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        prevButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        view.addSubview(nextButton)
        nextButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    }
    
    func contentViewSetting() {
        view.addSubview(contentView)
        contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        contentView.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 20).isActive = true
        
        let day = Calendar.current.component(.day, from: Date())
        calendar.select(calendar.today)
        if let entity = listDict[day] {
            globalEntity = entity
            contentView.setData(entity)
        } else {
            contentView.setEmpty()
            let date = Date()
            
            let selectedDate = formatter.string(from: date)
            
            //초기화
            UserInputData.shared.cleanData()
            InputViewController.entity = nil
            //날짜와 달 설정
            UserInputData.shared.date = selectedDate
            
            let month = date.month, year = date.year
            
            UserInputData.shared.month = month
            UserInputData.shared.year = year
            //push
        }
    }
}


extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    //border Color
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        guard let entity = listDict[Int(date.day)], let mood = entity.mood else {
            return nil
        }
        return colorDict[mood] ?? nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
        guard let entity = listDict[Int(date.day)], let mood = entity.mood else {
            return nil
        }
        return colorDict[mood] ?? nil
    }
    
    //calendar fill color
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        return .white
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return .white
    }
    
    //calendar title color
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        return .systemBlue
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        guard let _ = listDict[Int(date.day)] else {
            return .systemGray3
        }
        return .black
    }

    //will display cell
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        if cell.dateIsToday {
            cell.titleLabel.text = "today"
        }
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        //미래 날짜는 선택을 금지한다
        let difference = Calendar.current.dateComponents([.second], from: Date(), to: date).second!
        return difference <= 0
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("didselect")
        let selectedDate = formatter.string(from: date)
        
        let day = Int(date.day)
        
        //내용이 있으면 해당 내용을 보여주자
        if let entity = listDict[day]{
            contentView.setData(entity)
            globalEntity = entity
        }
        //내용이 없으면 빈 뷰를 보여주자
        else {
            contentView.setEmpty()
            //초기화
            UserInputData.shared.cleanData()
            InputViewController.entity = nil
            //날짜와 달 설정
            UserInputData.shared.date = selectedDate
            
            let month = date.month, year = date.year
            
            UserInputData.shared.month = month
            UserInputData.shared.year = year
            //push
        }
    }

    

    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        UserDefaults.standard.set(calendar.currentPage.month, forKey: UserDefaultKey.listMonth)
        UserDefaults.standard.set(calendar.currentPage.year, forKey: UserDefaultKey.listYear)
        NotificationCenter.default.post(name: .dataChanged, object: nil)
    }
}

