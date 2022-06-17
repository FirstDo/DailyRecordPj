//
//  CustomHeaderView.swift
//  DailyRecordProject
//
//  Created by 김도연 on 2021/10/06.
//

import UIKit

class CustomHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var dateTitle: UILabel!
    @IBOutlet weak var moodImage: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
