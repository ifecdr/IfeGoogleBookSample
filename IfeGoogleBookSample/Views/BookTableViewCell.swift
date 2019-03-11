//
//  BookTableViewCell.swift
//  IfeGoogleBookSample
//
//  Created by MAC Consultant on 3/9/19.
//  Copyright © 2019 MAC Consultant. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    //@IBOutlet weak var imageViewer: BookTableViewCell!
    @IBOutlet weak var imageViewer: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
