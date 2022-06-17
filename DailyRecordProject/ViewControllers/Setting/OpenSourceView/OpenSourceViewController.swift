//
//  OpenSourceViewController.swift
//  DailyRecordProject
//
//  Created by DuDu on 2021/11/16.
//

import UIKit

final class OpenSourceViewController: UITableViewController {
    
    private let versionInfo = [
        "1.0",
        "1.1"
    ].reversed().map{$0}
    
    private let versionContent = [
        "업데이트내용 없음",
        """
            1. 다크모드 지원
            2. 레이아웃 수정
                2-1. 런치스크린 이미지/타이틀 변경
            3. 버그 픽스
                3-1. 색상이 제대로 보이지 않는 버그 수정
        """
    ].reversed().map{$0}
    
    private let openSource = [
        "FSCalendar",
        "SnapKit"
    ]
    
    private let openSourceContent = [
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
""",

"""
Copyright (c) 2011-Present SnapKit Team - https://github.com/SnapKit

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
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
"""
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "오픈소스 & 앱 버전"
        tableView.register(PlainTableViewCell.self, forCellReuseIdentifier: "cell")
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PlainTableViewCell else {
            return UITableViewCell()
        }

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
            modalVC.infoTitle = "version " + versionInfo[indexPath.row]
            modalVC.content = versionContent[indexPath.row]
        }
        
        present(modalVC, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
