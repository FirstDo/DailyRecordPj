//
//  SettingViewController.swift
//  DailyRecordProject
//
//  Created by 김도연 on 2021/11/16.
//

import UIKit

class SettingViewController: UITableViewController {
    //한주의 시작 요일을 변경하자
    @IBAction func changeStartDay(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            print("일요일")
        } else {
            print("월요일")
        }
    }
    
    //푸쉬알람 설정 코드
    @IBAction func togglePushAlarm(_ sender: UISwitch) {
    
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath.section == 1 ? indexPath : nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
        //리뷰 남기기
            
            
        } else {
        //오픈소스 라이센스
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "앱 설정"
    }
}

