//
//  OpenSourceViewController.swift
//  DailyRecordProject
//
//  Created by 김도연 on 2021/11/16.
//

import UIKit

class OpenSourceViewController: UITableViewController {
    
    let versionInfo = ["1.0.0"]
    let versionContent = ["최초버전: 업데이트내용 없음"]
    let openSource = ["FSCalendar"]
    let openSourceContent = [
"""
     Copyright (c) 2013-2016 FSCalendar (https://github.com/WenchaoD/FSCalendar)
     
     Permission is hereby granted, free of charge, to any person obtaining a copy
     of this software and associated documentation files (the "Software"), to deal
     in the Software without restriction, including without limitation the rights
     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
     copies of the Software, and to permit persons to whom the Software is
     furnished to do so, subject to the following conditions:

     The above copyright notice and this permission notice shall be included in
     all copies or substantial portions of the Software.

     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
     OUT OF OR IN
     CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
     THE SOFTWARE.
"""
    ]
    
    override func viewDidLoad() {
        title = "오픈소스 & 앱 버전"
        super.viewDidLoad()
        tableView.register(PlainTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? openSource.count : versionInfo.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "오픈소스"
        } else {
            return "버전 정보"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlainTableViewCell
        cell.accessoryType = .detailButton
        let target = indexPath.row
        
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = indexPath.section == 0 ? openSource[target] : versionInfo[target]
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = indexPath.section == 0 ? openSource[target] : versionInfo[target]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let modalVC = InfoModalViewController()
        
        if indexPath.section == 0 {
            modalVC.infoTitle = openSource[indexPath.row]
            modalVC.content = openSourceContent[indexPath.row]
        } else {
            modalVC.infoTitle = versionInfo[indexPath.row]
            modalVC.content = versionContent[indexPath.row]
        }
        present(modalVC, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
