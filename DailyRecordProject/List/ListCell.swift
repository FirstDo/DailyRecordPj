//
//  ListCell.swift
//  DailyRecordProject
//
//  Created by 김도연 on 2021/10/05.
//

import UIKit

class ListCell: UITableViewCell {
    
    private let goodLable: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "👍"
        return lb
    }()
    
    private let badLable: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "👎"
        return lb
    }()
    
    private let greatLable: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "🥰"
        return lb
    }()
    
    private func setContraint() {
        contentView.addSubview(goodLable)
        contentView.addSubview(badLable)
        contentView.addSubview(greatLable)
        
        goodLable.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        goodLable.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor).isActive = true
        
        
        badLable.leadingAnchor.constraint(equalTo: goodLable.leadingAnchor).isActive = true
        badLable.topAnchor.constraint(equalTo: goodLable.bottomAnchor, constant: 20).isActive = true
        greatLable.leadingAnchor.constraint(equalTo: goodLable.leadingAnchor).isActive = true
        greatLable.topAnchor.constraint(equalTo: badLable.bottomAnchor, constant: 20).isActive = true
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setContraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
