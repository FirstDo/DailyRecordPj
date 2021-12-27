//  ListViewController.swift
//  기록들을 모아서 보여주는 View

import UIKit
import SnapKit

class ListViewController: UIViewController {
    private let yearList = (2015...2040).map{String($0)}
    private let monthList = (1...12).map{String($0)}
    
    //MARK: - View의 여러가지 subview들
    //tableView
    private let tableView: UITableView = {
        let tableview = UITableView()
        
        return tableview
    }()
    //DateLabel
    private let selectedDateLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    //tempTextField
    private let tempTextField: UITextField = {
        let lb = UITextField()
        
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    //버튼을 누르면 InputView를 보여준다
    private let dateSelectButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .none
        btn.addTarget(self, action: #selector(selectButton(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    @objc func selectButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 0.5
        }
        tempTextField.becomeFirstResponder()
        
        if let year = UserDefaults.standard.value(forKey: UserDefaultKey.listYear) as? Int, let month = UserDefaults.standard.value(forKey: UserDefaultKey.listMonth) as? Int{
            
            if let yearIdx = yearList.firstIndex(of: String(year)), let monthIdx = monthList.firstIndex(of: String(month)) {
                yearPicker.selectRow(yearIdx, inComponent: 0, animated: true)
                monthPicker.selectRow(monthIdx, inComponent: 0, animated: true)
            } else {

            }
        }
    }
    
    //InputView의 ToolBar
    private let pickerToolBar: UIToolbar = {
        let tb = UIToolbar()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.frame = CGRect(x: 0, y: 0, width: 0, height: 40)
        let flexBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(clickDoneBtn(_:)))
        doneBtn.tintColor = .CustomBlack
        tb.setItems([flexBtn, doneBtn], animated: true)
        return tb
    }()
    
    //pickerView에서 Done 버튼을 눌렀을때: title Label 을 변경하고, 새로운 year, month로 fetch
    @objc func clickDoneBtn(_ sender: UIButton) {
        let yearIdx = yearPicker.selectedRow(inComponent: 0)
        let monthIdx = monthPicker.selectedRow(inComponent: 0)
        
        if let selectedYear = Int16(yearList[yearIdx]) , let selectedMonth = Int16(monthList[monthIdx]) {
            //값 저장
            UserDefaults.standard.set(selectedYear, forKey: UserDefaultKey.listYear)
            UserDefaults.standard.set(selectedMonth, forKey: UserDefaultKey.listMonth)
            //새로운 값으로 list 보여주기
            selectedDateLabel.text = "\(selectedYear)년 \(selectedMonth)월 🔽"
            self.list = DataManager.shared.fetchTask(selectedMonth, selectedYear)
            self.tableView.reloadData()
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 1.0
        }
        self.view.endEditing(true)
    }
    
    //DateInputView
    private let dateInputView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBackground
        return v
    }()
    //monthPicker
    private let monthPicker: UIPickerView = {
       let monthPicker = UIPickerView()
        monthPicker.backgroundColor = .systemBackground
        monthPicker.translatesAutoresizingMaskIntoConstraints = false
        return monthPicker
    }()
    //yearPicker
    private let yearPicker: UIPickerView = {
        let yearPicker = UIPickerView()
        yearPicker.backgroundColor = .systemBackground
        yearPicker.translatesAutoresizingMaskIntoConstraints = false
        return yearPicker
    }()

    var list = [DailyInfoEntity]()
    var changeToken: NSObjectProtocol?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        super.navigationController?.isNavigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //최초 세팅
        view.backgroundColor = .systemBackground
        let (month, year) = (Date.month, Date.year)
        list = DataManager.shared.fetchTask(month, year)
        //최초 시점에는 listView의 month, year을 current Date로 초기화
        UserDefaults.standard.set(year, forKey: UserDefaultKey.listYear)
        UserDefaults.standard.set(month, forKey: UserDefaultKey.listMonth)
        
        //notification setting
        //data가 바뀌었을때!
        changeToken = NotificationCenter.default.addObserver(forName: .dataChanged, object: nil, queue: .main, using: { [weak self] _ in
            if let month = UserDefaults.standard.value(forKey: UserDefaultKey.listMonth) as? Int16, let year = UserDefaults.standard.value(forKey: UserDefaultKey.listYear) as? Int16 {
                self?.list = DataManager.shared.fetchTask(month,year)
                self?.selectedDateLabel.text = "\(year)년 \(month)월 🔽"
            } else {
                self?.list = DataManager.shared.fetchTask(Date.month,Date.year)
                self?.selectedDateLabel.text = "\(Date.year)년 \(Date.month)월 🔽"
            }
            self?.tableView.reloadData()
        })
        
        //delegate Setting
        monthPicker.delegate = self
        monthPicker.dataSource = self
        
        yearPicker.delegate = self
        yearPicker.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        setConstraint()

        let headerNib = UINib(nibName: "CustomHeader", bundle: nil)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "customHeader")
        tableView.register(ListCell.self, forCellReuseIdentifier: "ListCell")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    private func setConstraint() {
        //addSubView
        self.view.addSubview(tableView)
        self.view.addSubview(tempTextField)
        self.view.addSubview(dateSelectButton)
        self.view.addSubview(selectedDateLabel)
        
        //DateInputView
        tempTextField.inputView = dateInputView
        dateInputView.addSubview(monthPicker)
        dateInputView.addSubview(yearPicker)
        
        dateInputView.translatesAutoresizingMaskIntoConstraints = false
        
        let yearLabel = UILabel()
        yearLabel.text = "년"
        yearLabel.textAlignment = .center
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let monthLabel = UILabel()
        monthLabel.text = "월"
        monthLabel.textAlignment = .center
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let width = view.safeAreaLayoutGuide.layoutFrame.width / 3
        
        dateInputView.addSubview(yearLabel)
        yearLabel.centerYAnchor.constraint(equalTo: yearPicker.centerYAnchor).isActive = true
        
        dateInputView.addSubview(monthLabel)
        monthLabel.centerYAnchor.constraint(equalTo: yearPicker.centerYAnchor).isActive = true
        monthLabel.trailingAnchor.constraint(equalTo: dateInputView.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        
        yearPicker.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.leading.equalTo(dateInputView.safeAreaLayoutGuide.snp.leading).offset(30)
            make.top.equalTo(dateInputView.safeAreaLayoutGuide.snp.top).offset(10)
            make.bottom.equalTo(dateInputView.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.trailing.equalTo(yearLabel.snp.leading)
        }
        
        monthPicker.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.top.bottom.equalTo(yearPicker)
            make.leading.equalTo(yearLabel.snp.trailing)
            make.trailing.equalTo(monthLabel.snp.leading)
        }

        //textfield
        tempTextField.inputAccessoryView = pickerToolBar
        tempTextField.isHidden = true
        tempTextField.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.width.equalTo(150)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            
        }
        //selectButton
        dateSelectButton.snp.makeConstraints { make in
            make.directionalEdges.equalTo(tempTextField)
        }
        
        //selectedTitlelabel
        selectedDateLabel.snp.makeConstraints { make in
            make.directionalEdges.equalTo(tempTextField)
        }
        
        selectedDateLabel.text = "\(Date.year)년 \(Date.month)월 🔽"
        
        //tableView
        tableView.snp.makeConstraints { make in
            make.top.equalTo(tempTextField.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
    }
}

//MARK: - PickerView Delegate
extension ListViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == monthPicker {
            return monthList.count
        } else {
            return yearList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == monthPicker {
            return monthList[row]
        } else {
            return yearList[row]
        }
    }
}

//MARK: - tableView Delegate
extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "customHeader") as! CustomHeaderView
        let target = list[section]
        
        if let date = target.date {
            if let idx = date.lastIndex(of: "."), let day = Int((date[idx...].dropFirst())) {
                header.dateTitle.text = " \(day) 일의 기록"
            }
        }
        switch target.mood {
        case "happy":
            header.moodImage.image = UIImage(named: "happy")
        case "sad":
            header.moodImage.image = UIImage(named: "sad1")
        case "soso":
            header.moodImage.image = UIImage(named: "soso")
        case "angry":
            header.moodImage.image = UIImage(named: "angry")
        default:
            break
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
        let target = list[indexPath.section]
        cell.goodLabel.text = "😀 " + target.good!
        cell.badLabel.text = "😵 " + target.bad!
        cell.thanksLabel.text = "🥰 " + target.thanks!
        cell.highlightLabel.text = "🤔 " + target.highlight!
        return cell
    }
}
