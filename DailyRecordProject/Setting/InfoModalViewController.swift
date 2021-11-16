//
//  InfoModalViewController.swift
//  DailyRecordProject
//
//  Created by 김도연 on 2021/11/16.
//

import UIKit

class InfoModalViewController: UIViewController {
    
    var infoTitle: String?
    var content: String?
    
    lazy var infoView: UITextView = {
        let v = UITextView()
        v.isEditable = false
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textContainer.lineBreakMode = .byWordWrapping
        v.font = UIFont.systemFont(ofSize: 20)
        v.dataDetectorTypes = .link
        v.text = content
        return v
    }()
    
    lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 20)
        lb.text = infoTitle
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        view.addSubview(infoView)
        infoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        infoView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        infoView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        infoView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        
        //infoView.text = content
    }
}
