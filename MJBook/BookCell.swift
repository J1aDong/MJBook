//
// Created by J1aDong on 2017/10/29.
// Copyright (c) 2017 J1aDong. All rights reserved.
//

import Foundation
import UIKit

class BookCell:UITableViewCell{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var starCountLabel: UILabel!
    
    var book: Book?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let book = self.book {
            self.titleLabel.text = book.title
            self.summaryLabel.text = book.summary
            self.starCountLabel.text = "★  \(book.starCount)"
        }
    }
}
