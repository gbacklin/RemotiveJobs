//
//  FilterViewController.swift
//  RemotiveJobs
//
//  Created by Gene Backlin on 4/27/20.
//  Copyright © 2020 Gene Backlin. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate {
    func filterSelected(filterType: SelectedFilter)
}


class FilterViewController: UIViewController {
    
    var delegate: FilterViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        preferredContentSize = CGSize(width: 350, height: 35)
    }

    @IBAction func selectFilter(_ sender: UISegmentedControl) {
        var selectedFilter: SelectedFilter
        
        switch sender.selectedSegmentIndex {
        case 0:
            selectedFilter = .title
        case 1:
            selectedFilter = .date
        case 2:
            selectedFilter = .category
        case 3:
            selectedFilter = .location
        default:
            selectedFilter = .title
        }
        delegate?.filterSelected(filterType: selectedFilter)
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

