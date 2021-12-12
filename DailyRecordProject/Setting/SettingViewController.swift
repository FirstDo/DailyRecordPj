//
//  SettingViewController.swift
//  DailyRecordProject
//
//  Created by 김도연 on 2021/11/16.
//

import UIKit
import UserNotifications
import NotificationCenter

class SettingViewController: UITableViewController {
    @IBOutlet weak var pushSwitch: UISwitch!
    
    var token: NSObjectProtocol?
    
    //한주의 시작 요일 변경 action
    @IBAction func changeStartDay(_ sender: UISegmentedControl) {
        let value = sender.selectedSegmentIndex + 1
        NotificationCenter.default.post(name: .weekChanged, object: nil, userInfo: ["week": value])
    }
    
    //푸쉬알람 스위치 action
    @IBAction func togglePushAlarm(_ sender: UISwitch) {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath.section == 1 ? indexPath : nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let openVC = OpenSourceViewController()
        navigationController?.pushViewController(openVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "앱 설정"
        
        if let value = UserDefaults.standard.value(forKey: UserDefaultKey.switchState) as? Bool {
            pushSwitch.isOn = value
        }
        
        token = NotificationCenter.default.addObserver(forName: .pushChanged, object: nil, queue: .main, using: { [weak self]_ in
            if let value = UserDefaults.standard.value(forKey: UserDefaultKey.switchState) as? Bool {
                self?.pushSwitch.isOn = value
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let selectedIdx = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIdx, animated: true)
        }
    }
}

