//
//  FFPrayerTimeCell.swift
//  Prayer Times
//
//  Created by Fisnik Fejzullahu on 1/4/19.
//  Copyright © 2019 Katrori. All rights reserved.
//

import UIKit

class FFPrayerTimeCell: UITableViewCell {

    @IBOutlet weak var prayerTitle: UILabel!
    @IBOutlet weak var prayerTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
