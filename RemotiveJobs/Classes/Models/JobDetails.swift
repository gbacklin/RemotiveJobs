//
//  JobDetails.swift
//  RemotiveJobs
//
//  Created by Gene Backlin on 4/27/20.
//  Copyright © 2020 Gene Backlin. All rights reserved.
//
/*
 {
   "0-legal-notice": "Remotive API Legal Notice",
   "job-count": 1, // Number or jobs matching the query == length of 'jobs' list
   "jobs": [ // The list of all jobs retrieved. Then for each job, you get:
     {
       "id": 123, // Unique Remotive ID
       "url": "https://remotive.io/remote-jobs/product/lead-developer-123", // Job listing detail url
       "title": "Lead Developer", // Job title
       "company_name": "Remotive", // Name of the company which is hiring
       "category": "Software Development", // See https://remotive.io/api/remote-jobs/categories for existing categories
       "tags": ["python", "back end"], // list of tags. See https://remotive.io/api/remote-jobs/tags for existing tags
       "job_type": "full_time",  // "full_time" or "contract" here
       "publication_date": "2020-02-15T10:23:26", // Publication date and time on https://remotive.io
       "candidate_required_location": "Worldwide", // Geographical restriction for the remote candidate, if any.
       "salary": "$40,000 - $50,000", // salary description, usually a yearly salary range, in USD.
       "description": "The full HTML job description here", // HTML full description of the job listing
     },
   ]
 }
 */
import Foundation

struct JobDetails {
    var id: Int
    var url: String
    var title: String
    var company_name: String
    var category: String
    var tags: [String]
    var job_type: String
    var publication_date: String
    var candidate_required_location: String
    var salary: String
    var description: String
}

enum SelectedFilter {
    case title
    case date
    case category
    case location
    case company
}

extension SelectedFilter: CaseIterable { }

extension SelectedFilter: RawRepresentable {
  typealias RawValue = String
  
  init?(rawValue: RawValue) {
    switch rawValue {
    case "Title": self = .title
    case "Date": self = .date
    case "Category": self = .category
    case "Location": self = .location
    case "Company": self = .company
    default: return nil
    }
  }
  
  var rawValue: RawValue {
    switch self {
    case .title: return "Title"
    case .date: return "Date"
    case .category: return "Category"
    case .location: return "Location"
    case .company: return "Company"
    }
  }
}

