//
//  customTableViewCell.swift
//  iQuiz
//
//  Created by Matthew Ramirez on 5/9/22.
//

import UIKit

class customTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var cellImage: UIImageView!
    
    @IBOutlet weak var cellSubject: UILabel!
    
    @IBOutlet weak var cellDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
