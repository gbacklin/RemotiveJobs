//
//  DetailViewController.swift
//  RemotiveJobs
//
//  Created by Gene Backlin on 4/27/20.
//  Copyright © 2020 Gene Backlin. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {
    var job: JobDetails?
    @IBOutlet weak var titleTableViewCell: UITableViewCell!
    @IBOutlet weak var companyTableViewCell: UITableViewCell!
    @IBOutlet weak var descriptionTableViewCell: UITableViewCell!
    @IBOutlet weak var categoryTableViewCell: UITableViewCell!
    @IBOutlet weak var jobTypeTableViewCell: UITableViewCell!
    @IBOutlet weak var locationTableViewCell: UITableViewCell!
    @IBOutlet weak var salaryTableViewCell: UITableViewCell!
    @IBOutlet weak var viewListingTableViewCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if job != nil {
            titleTableViewCell.textLabel?.text = job!.title
            titleTableViewCell.detailTextLabel?.text = Remotive.shared.convertDate(dateString: job!.publication_date)
            companyTableViewCell.textLabel?.text = job!.company_name
            descriptionTableViewCell.textLabel?.text = Remotive.shared.htmlToTextView(html: job!.description)!.string
            categoryTableViewCell.textLabel?.text = job?.category
            jobTypeTableViewCell.textLabel?.text = job?.job_type
            locationTableViewCell.textLabel?.text = job?.candidate_required_location
            salaryTableViewCell.textLabel?.text = job?.salary
            viewListingTableViewCell.textLabel?.text = "View Listing"
            viewListingTableViewCell.accessoryType = .disclosureIndicator
            viewListingTableViewCell.isUserInteractionEnabled = true
        } else {
            titleTableViewCell.textLabel?.text = "Select a job from the Job List."
            titleTableViewCell.detailTextLabel?.text = ""
            companyTableViewCell.textLabel?.text = ""
            descriptionTableViewCell.textLabel?.text = ""
            categoryTableViewCell.textLabel?.text = ""
            jobTypeTableViewCell.textLabel?.text = ""
            locationTableViewCell.textLabel?.text = ""
            salaryTableViewCell.textLabel?.text = ""
            viewListingTableViewCell.textLabel?.text = ""
            viewListingTableViewCell.accessoryType = .none
            viewListingTableViewCell.isUserInteractionEnabled = false
        }
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowWebView" {
            let controller: WebViewController = segue.destination as! WebViewController
            controller.url = job?.url
        }
    }
    
}

extension DetailViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.row == 0 {
            UIApplication.shared.open(URL(string: job!.url)!)
        }
    }
}
