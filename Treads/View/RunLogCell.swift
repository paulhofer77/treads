//
//  RunLogCell.swift
//  Treads
//
//  Created by Paul Hofer on 31.10.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import UIKit

class RunLogCell: UITableViewCell {

    //    MARK: - Outlets
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var averagePaceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(run: Run) {
        durationLabel.text = run.duration.formatTimeDurationToString()
        distanceLabel.text = "\(run.distance.meterToKm(decimalPlaces: 2))km"
        averagePaceLabel.text = run.pace.formatTimeDurationToString()
        dateLabel.text = run.date.getDateString()
    }

}
