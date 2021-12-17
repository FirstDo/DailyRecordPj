//
//  InfoModalViewController.swift
//  DailyRecordProject
//
//  Created by 김도연 on 2021/11/16.
//

import UIKit
import SnapKit

class InfoModalViewController: UIViewController {
    
    var infoTitle: String?
    var content: String?
    
    lazy var infoView: UITextView = {
        let v = UITextView()
        v.isEditable = false
        v.textContainer.lineBreakMode = .byWordWrapping
        v.font = UIFont.systemFont(ofSize: 15)
        v.dataDetectorTypes = .link
        v.text = content
        return v
    }()
    
    lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 25)
        lb.text = infoTitle
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        constraintSetting()
    }
    
    private func constraintSetting() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalToSuperview().offset(20)
        }
        
        view.addSubview(infoView)
        infoView.contentInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        infoView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
}
