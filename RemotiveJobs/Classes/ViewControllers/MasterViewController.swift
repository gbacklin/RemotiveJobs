//
//  MasterViewController.swift
//  RemotiveJobs
//
//  Created by Gene Backlin on 4/27/20.
//  Copyright © 2020 Gene Backlin. All rights reserved.
//

import UIKit

let QUERY = "https://remotive.io/api/remote-jobs"

class MasterViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    var detailViewController: DetailViewController? = nil
    var objects = [[String: AnyObject]]()
    var filteredObjects = [[String: AnyObject]]()
    var legalNotice: String?
    var titles: [String: String] = [String: String]()
    var categories: [String: String] = [String: String]()
    var companyNames: [String: String] = [String: String]()
    var selectedFilter: SelectedFilter?
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 155
        
        searchBar.isHidden = true

        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.long

        // set up the refresh control
        let now = Date()
        let updateString = "Last Updated at \(dateFormatter.string(from: now))"
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: updateString)
        refreshControl!.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        tableView?.addSubview(refreshControl!)

        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        view.addSubview(activityIndicator)
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        fetchJobData()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    @IBAction func resetTableView(_ sender: Any) {
        DispatchQueue.main.async {
            self.tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
        }
    }
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let job = filteredObjects[indexPath.row] 
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                detailViewController = controller
                detailViewController?.job = Remotive.shared.parseJob(job: job)
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredObjects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: JobTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! JobTableViewCell
        let object = Remotive.shared.parseJob(job: filteredObjects[indexPath.row])
        cell.title!.text = object.title
        cell.category!.text = object.category
        cell.companyName!.text = object.company_name
        cell.datePosted!.text = Remotive.shared.convertDate(dateString: object.publication_date)
        cell.location!.text = object.candidate_required_location
        
        titles[object.title] = object.title
        categories[object.category] = object.category
        companyNames[object.company_name] = object.company_name
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
}

extension MasterViewController {
    // MARK: - Utility methods
        
    func fetchJobData() {
        Remotive.shared.fetchJobData {[weak self] (legal, result, error) in
            DispatchQueue.main.async {
                if error != nil {
                    self!.handleError(error: error!)
                } else {
                    self!.legalNotice = legal
                    if let jobs = result {
                        self!.objects = jobs
                        self!.filteredObjects = jobs
                        self!.tableView.reloadData()
                        self!.title = "\(jobs.count) Jobs Found"
                        self!.activityIndicator.isHidden = true
                        self!.searchBar.isHidden = false
                        self!.searchBar.scopeButtonTitles = SelectedFilter.allCases.map { $0.rawValue }
                    }
                }
            }
        }
    }

    @objc
    func refresh(_ sender: AnyObject) {
        
        // update "last updated" title for refresh control
        let now = Date()
        let updateString = "Last Updated at \(dateFormatter.string(from: now))"
        refreshControl!.attributedTitle = NSAttributedString(string: updateString)
        if refreshControl!.isRefreshing {
            refreshControl!.endRefreshing()
        }
        let selectedScope = searchBar.selectedScopeButtonIndex
        let category = SelectedFilter(rawValue: searchBar.scopeButtonTitles![selectedScope])
        filterContentForSearchText(searchBar.text!, category: category)
    }

    func handleError(error: Error) {
        let errorMessage = error.localizedDescription
        let alert: UIAlertController = UIAlertController(title: NSLocalizedString("Cannot complete the process", comment: ""), message: errorMessage, preferredStyle: .actionSheet)
        let OKAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { (action) in
        }
        alert.addAction(OKAction)
        present(alert, animated: true, completion: nil)
    }
    
    func filterContentForSearchText(_ searchText: String, category: SelectedFilter? = nil) {
        filteredObjects.removeAll()
        if searchText.count == 0 {
            filteredObjects = objects
        }
        for object in objects {
            let job = Remotive.shared.parseJob(job: object)
            switch category {
            case .title:
                if job.title.lowercased().contains(searchText.lowercased()) {
                    filteredObjects.append(object)
                }
            case .date:
                let jobDate = Remotive.shared.convertDate(dateString: job.publication_date)
                if jobDate.lowercased().contains(searchText.lowercased()) {
                    filteredObjects.append(object)
                }
            case .category:
                if job.category.lowercased().contains(searchText.lowercased()) {
                    filteredObjects.append(object)
                }
            case .location:
                if job.candidate_required_location.lowercased().contains(searchText.lowercased()) {
                    filteredObjects.append(object)
                }
            case .company:
                if job.company_name.lowercased().contains(searchText.lowercased()) {
                    filteredObjects.append(object)
                }
            default:
                if job.title.lowercased().contains(searchText.lowercased()) {
                    filteredObjects.append(object)
                }
            }
        }
      tableView.reloadData()
    }

}

extension MasterViewController: UIPopoverPresentationControllerDelegate {
    
    // MARK: - UIPopoverPresentationControllerDelegate

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
    }
}

extension MasterViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        debugPrint("updateSearchResults")
        searchBar.setShowsScope(true, animated: true)
    }
}

extension MasterViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filteredObjects.removeAll()
        filteredObjects = objects
        searchBar.text = ""
        let category = SelectedFilter(rawValue: searchBar.scopeButtonTitles![selectedScope])
        filterContentForSearchText(searchBar.text!, category: category)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredObjects.removeAll()
        filteredObjects = objects
        searchBar.text = ""
        searchBar.endEditing(true)
        let selectedScope = searchBar.selectedScopeButtonIndex
        let category = SelectedFilter(rawValue: searchBar.scopeButtonTitles![selectedScope])
        filterContentForSearchText("", category: category)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text {
            let selectedScope = searchBar.selectedScopeButtonIndex
            let category = SelectedFilter(rawValue: searchBar.scopeButtonTitles![selectedScope])
            filterContentForSearchText(text, category: category)
        }
    }
}
