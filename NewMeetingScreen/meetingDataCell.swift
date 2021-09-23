//
//  meetingDataCell.swift
//  NewMeetingScreen
//
//  Created by Sridatta Nallamilli on 21/09/21.
//

import UIKit

class meetingDataCell: UITableViewCell {
    
    @IBOutlet weak var meetingView                    : UIView!
    @IBOutlet weak var dateView                       : UIView!
    @IBOutlet weak var dayLabel                       : UILabel!
    @IBOutlet weak var dateLabel                      : UILabel!
    @IBOutlet weak var titleLabel                     : UILabel!
    @IBOutlet weak var timeLabel                      : UILabel!
    @IBOutlet weak var locationLabel                  : UILabel!
    @IBOutlet weak var dividerView                    : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
