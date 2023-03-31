//
//  CalenderCell.swift
//  SimPill
//


import UIKit

class CalenderCell: UITableViewCell {

    @IBOutlet var mDate: UILabel!
    @IBOutlet var mTitle: UILabel!
    @IBOutlet var mTime: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
