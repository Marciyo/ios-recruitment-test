//
//  TableViewCell.swift
//  iOSRecruitmentTest
//
//  Created by Bazyli Zygan on 15.06.2016.
//  Copyright © 2016 Snowdog. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemDescLabel: UILabel!
    
    var item: RecruitmentItemEntity? {
        didSet {
            self.itemTitleLabel.text = self.item?.name ?? ""
            self.itemDescLabel.text = self.item?.descriptionText ?? ""
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.iconView.layer.cornerRadius = 4
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.item = nil
        iconView.image = nil
    }
}
