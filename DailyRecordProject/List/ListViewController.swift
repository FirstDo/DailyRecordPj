//
//  ListViewController.swift
//  DailyRecordProject
//
//  Created by 김도연 on 2021/09/28.
//

import UIKit

class ListViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableview = UITableView()
        return tableview
    }()

    
    var list = [DailyInfoEntity]()
    
    var token: NSObjectProtocol?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("뷰 윌 어피얼")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        print("list 뷰 디드 로드")
        
        list = DataManager.shared.fetchTask(10)
        
        token = NotificationCenter.default.addObserver(forName: CalendarViewController.taskChanged, object: nil, queue: .main, using: { _ in
            self.list = DataManager.shared.fetchTask(10)
            self.tableView.reloadData()
        })
        
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
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return list.count
    }
    

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "customHeader") as! CustomHeaderView
        header.dateTitle.text = list[section].date
        var mood = ""
        switch list[section].mood {
        case "happy":
            mood = "☀️"
        case "sad":
            mood = "🌧"
        case "soso":
            mood = "🌤"
        case "angry":
            mood = "⚡️"
        default:
            mood = "🌀"
        }
        
        header.moodTitle.text = mood
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
        cell.goodLabel.text = "👍 " + target.good!
        cell.badLabel.text = "👎 " + target.bad!
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
            
            DataManager.shared.deleteTask(entity: deleteTarget) {
                NotificationCenter.default.post(name: CalendarViewController.taskChanged, object: nil)
            }
            
            print("delete")
            success(true)
        }
        
        deleteAction.image = UIImage(systemName: "delete.left")
        
        let editAction = UIContextualAction(style: .normal, title: "편집") { action, view, success in
            print("edit")
            
            //수정기능 구현해야 합니다.
            let editTarget = self.list[indexPath.section]
            
            let editVC = InputViewController()
            InputViewController.entity = editTarget
            UserInputData.shared.setData(date: editTarget.date, mood: editTarget.mood, good: editTarget.good, bad: editTarget.bad, thanks: editTarget.thanks, highlight: editTarget.highlight)
            
            //entity update
            self.navigationController?.pushViewController(editVC, animated: true)
            success(true)
        }
        
        editAction.image = UIImage(systemName: "pencil.circle")
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
}
