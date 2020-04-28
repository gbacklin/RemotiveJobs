//
//  JobTableViewCell.swift
//  RemotiveJobs
//
//  Created by Gene Backlin on 4/27/20.
//  Copyright © 2020 Gene Backlin. All rights reserved.
//

import UIKit

class JobTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var datePosted: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var location: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
