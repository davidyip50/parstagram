//
//  commentCell.swift
//  Parstagram
//
//  Created by David Yip on 2/21/19.
//  Copyright © 2019 David Yip. All rights reserved.
//

import UIKit

class commentCell: UITableViewCell {

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
