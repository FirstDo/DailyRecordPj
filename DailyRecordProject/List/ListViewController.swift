//  ListViewController.swift
//  기록들을 모아서 보여주는 View

import UIKit

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
                print("SelectButton ERROR")
            }
        }
    }
    
    //InputView의 ToolBar
    private let pickerToolBar: UIToolbar = {
        let tb = UIToolbar()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.frame = CGRect(x: 0, y: 0, width: 0, height: 40)
        tb.backgroundColor = .systemBackground
        let flexBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(clickDoneBtn(_:)))
        tb.setItems([flexBtn, doneBtn], animated: true)
        return tb
    }()
    
    //pickerView에서 Done 버튼을 눌렀을때: title Label 을 변경하고, 새로운 year, month로 fetch
    @objc func clickDoneBtn(_ sender: UIButton) {
        let yearIdx = yearPicker.selectedRow(inComponent: 0)
        let monthIdx = monthPicker.selectedRow(inComponent: 0)
        
        if let selectedYear = Int16(yearList[yearIdx]) , let selectedMonth = Int16(monthList[monthIdx]) {
            print(selectedYear, selectedMonth)
            //값 저장
            UserDefaults.standard.set(selectedYear, forKey: UserDefaultKey.listYear)
            UserDefaults.standard.set(selectedMonth, forKey: UserDefaultKey.listMonth)
            //새로운 값으로 list 보여주기
            selectedDateLabel.text = "\(selectedYear)년 \(selectedMonth)월"
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
        if let height = UserDefaults.standard.value(forKey: UserDefaultKey.keyboardHeight) as? CGFloat {
            v.frame = CGRect(x: 0, y: 0, width: 0, height: height)
        } else {
            print("Cannot get Keyboard Height")
            v.frame = CGRect(x: 0, y: 0, width: 0, height: 250)
        }
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
//    var reloadToken: NSObjectProtocol?
    
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
        changeToken = NotificationCenter.default.addObserver(forName: .dataChanged, object: nil, queue: .main, using: { _ in
            
            if let month = UserDefaults.standard.value(forKey: UserDefaultKey.listMonth) as? Int16, let year = UserDefaults.standard.value(forKey: UserDefaultKey.listYear) as? Int16 {
                self.list = DataManager.shared.fetchTask(month,year)
            } else {
                self.list = DataManager.shared.fetchTask(Date.month,Date.year)
            }
            self.tableView.reloadData()
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
        
        let yearLabel = UILabel()
        yearLabel.text = "년"
        yearLabel.textAlignment = .center
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let monthLabel = UILabel()
        monthLabel.text = "월"
        monthLabel.textAlignment = .center
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let width = view.safeAreaLayoutGuide.layoutFrame.width / 3
        yearPicker.widthAnchor.constraint(equalToConstant: width).isActive = true
        monthPicker.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        dateInputView.addSubview(yearLabel)
        dateInputView.addSubview(monthLabel)
        
        yearPicker.leadingAnchor.constraint(equalTo: dateInputView.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        yearPicker.topAnchor.constraint(equalTo: dateInputView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        yearPicker.bottomAnchor.constraint(equalTo: dateInputView.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        yearPicker.trailingAnchor.constraint(equalTo: yearLabel.leadingAnchor).isActive = true
        
        yearLabel.centerYAnchor.constraint(equalTo: yearPicker.centerYAnchor).isActive = true
        
        monthPicker.leadingAnchor.constraint(equalTo: yearLabel.trailingAnchor).isActive = true
        monthPicker.topAnchor.constraint(equalTo: yearPicker.topAnchor).isActive = true
        monthPicker.bottomAnchor.constraint(equalTo: yearPicker.bottomAnchor).isActive = true
        monthPicker.trailingAnchor.constraint(equalTo: monthLabel.leadingAnchor).isActive = true
        
        monthLabel.centerYAnchor.constraint(equalTo: yearPicker.centerYAnchor).isActive = true
        monthLabel.trailingAnchor.constraint(equalTo: dateInputView.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        
        tempTextField.inputAccessoryView = pickerToolBar
        
        //textfield
        tempTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tempTextField.widthAnchor.constraint(equalToConstant: 150).isActive = true
        tempTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tempTextField.isHidden = true

        //selectButton
        dateSelectButton.leadingAnchor.constraint(equalTo: tempTextField.leadingAnchor).isActive = true
        dateSelectButton.trailingAnchor.constraint(equalTo: tempTextField.trailingAnchor).isActive = true
        dateSelectButton.topAnchor.constraint(equalTo: tempTextField.topAnchor).isActive = true
        dateSelectButton.bottomAnchor.constraint(equalTo: tempTextField.bottomAnchor).isActive = true
        
        //selectedTitlelabel
        selectedDateLabel.leadingAnchor.constraint(equalTo: tempTextField.leadingAnchor).isActive = true
        selectedDateLabel.trailingAnchor.constraint(equalTo: tempTextField.trailingAnchor).isActive = true
        selectedDateLabel.topAnchor.constraint(equalTo: tempTextField.topAnchor).isActive = true
        selectedDateLabel.bottomAnchor.constraint(equalTo: tempTextField.bottomAnchor).isActive = true
        
        selectedDateLabel.text = "\(Date.year)년 \(Date.month)월"
        
        //tableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: tempTextField.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
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
        header.dateTitle.text = list[section].date! + " 기록"

        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as? ListCell else {
            print("error")
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
        let target = list[indexPath.section]
        cell.goodLabel.text = "😀 " + target.good!
        cell.badLabel.text = "🙁 " + target.bad!
        cell.thanksLabel.text = "🥰 " + target.thanks!
        cell.highlightLabel.text = "🤔 " + target.highlight!

        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { action, view, success in
            
            let deleteTarget = self.list[indexPath.section]
            
            tableView.performBatchUpdates({
                let deleteIndex = self.list.firstIndex(of: deleteTarget)!
                self.list.remove(at: deleteIndex)
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
            }, completion: nil)
            
//            DataManager.shared.deleteTask(entity: deleteTarget) {
//                NotificationCenter.default.post(name: .listDataChanged, object: nil)
//            }
            
            DataManager.shared.deleteTask(entity: deleteTarget) {
                NotificationCenter.default.post(name: .dataChanged, object: nil)
            }

            success(true)
        }
        deleteAction.image = UIImage(systemName: "delete.left")
        
        let editAction = UIContextualAction(style: .normal, title: "편집") { action, view, success in
            print("edit")
            
            let editTarget = self.list[indexPath.section]
            
            let editVC = InputViewController()
            InputViewController.entity = editTarget
            UserInputData.shared.setData(date: editTarget.date, mood: editTarget.mood, good: editTarget.good, bad: editTarget.bad, thanks: editTarget.thanks, highlight: editTarget.highlight, month: editTarget.month, year: editTarget.year)
            
            self.navigationController?.pushViewController(editVC, animated: true)
            success(true)
        }
        editAction.image = UIImage(systemName: "pencil.circle")
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}
