//
//  Remotive.swift
//  RemotiveJobs
//
//  Created by Gene Backlin on 4/27/20.
//  Copyright © 2020 Gene Backlin. All rights reserved.
//

import UIKit

let FetchCompletedNotification: Notification.Name = Notification.Name(rawValue: "FetchCompletedNotification")

class Remotive: NSObject {
    static var shared = Remotive()

    func fetchJobData(completion: @escaping (_ legal: String?, _ jobs: [[String: AnyObject]]?, _ error: NSError?) -> Void) {
        // Fetch data...
        Network.shared.get(url: QUERY) { [weak self] (results, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion(nil, nil, error)
                }
            } else {
                if let response: [String: AnyObject] = results as? [String : AnyObject] {
                    DispatchQueue.main.async {
                        let messageView = UITextView()
                        let jobs: [[String: AnyObject]] = response["jobs"] as! [[String : AnyObject]]
                        let job:[String: AnyObject] = jobs[0]
                        let legalNotice: String = response["0-legal-notice"] as! String
                        let description: String = job["description"] as! String
                        messageView.attributedText = self!.htmlToTextView(html: description)
                        completion(legalNotice, jobs, nil)
                    }
                } else {
                    let error: NSError = self!.createError(domain: NSURLErrorDomain, code: -1955, text: "The results from the query were nil") as NSError
                    DispatchQueue.main.async {
                        completion(nil, nil, error)
                    }
                }
            }
        }
    }
    
    // MARK: - Utility methods
    
    func convertDate(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date: NSDate = dateFormatter.date(from: dateString)! as NSDate
        dateFormatter.dateFormat = "MM/dd/yyyy"

        return dateFormatter.string(from: date as Date)
    }

    func htmlToTextView(html: String) -> NSAttributedString? {
        let htmlData = NSString(string: html).data(using: String.Encoding.utf8.rawValue)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        let attributedString = try! NSAttributedString(data: htmlData!,
        options: options,
        documentAttributes: nil)
        return attributedString
    }
    
    func createError(domain: String, code: Int, text: String) -> Error {
        let userInfo: [String : String] = [NSLocalizedDescriptionKey: text]
        return NSError(domain: domain, code: code, userInfo: userInfo)
    }

    func parseJob(job: [String: AnyObject]) -> JobDetails {
        return JobDetails(id: job["id"] as! Int, url: job["url"] as! String, title: job["title"] as! String, company_name: job["company_name"] as! String, category: job["category"] as! String, tags: job["tags"] as! [String], job_type: job["job_type"] as! String, publication_date: job["publication_date"] as! String, candidate_required_location: job["candidate_required_location"] as! String, salary: job["salary"] as! String, description: job["description"] as! String)
    }
}
