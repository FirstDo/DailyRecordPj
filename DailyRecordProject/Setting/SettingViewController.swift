//
//  SettingViewController.swift
//  DailyRecordProject
//
//  Created by DuDu on 2021/11/16.
//

import UIKit
import UserNotifications
import NotificationCenter

final class SettingViewController: UITableViewController {
    @IBOutlet weak private var pushSwitch: UISwitch!
    
    var pushSwitchObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setAttribute()
        addPushAlarmObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let selectedIdx = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIdx, animated: true)
        }
    }
    
    private func setAttribute() {
        title = "앱 설정"
        
        if let value = UserDefaults.standard.value(forKey: UserDefaultKey.switchState) as? Bool {
            pushSwitch.isOn = value
        }
    }
    
    private func addPushAlarmObserver() {
        pushSwitchObserver = NotificationCenter.default.addObserver(forName: .pushChanged, object: nil, queue: .main, using: { [weak self]_ in
            if let value = UserDefaults.standard.value(forKey: UserDefaultKey.switchState) as? Bool {
                self?.pushSwitch.isOn = value
            }
        })
    }
    
    @IBAction func changeStartDay(_ sender: UISegmentedControl) {
        let value = sender.selectedSegmentIndex + 1
        NotificationCenter.default.post(name: .weekChanged, object: nil, userInfo: ["week": value])
    }
    
    @IBAction func togglePushAlarm(_ sender: UISwitch) {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    //MARK: TableView Delegate
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath.section == 1 ? indexPath : nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let openVC = OpenSourceViewController()
            navigationController?.pushViewController(openVC, animated: true)
        } else {
            moveToDeviceAppSetting()
        }
    }
    
    private func moveToDeviceAppSetting() {
        let appID = "1598246774"
        let address = "itms-apps://itunes.apple.com/app/itunes-u/id\(appID)?ls=1&mt=8&action=write-review"
        
        if let url = URL(string: address), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("error")
        }
    }
}

