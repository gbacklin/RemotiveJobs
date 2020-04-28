//
//  RemotiveResponse.swift
//  RemotiveJobs
//
//  Created by Gene Backlin on 4/27/20.
//  Copyright © 2020 Gene Backlin. All rights reserved.
//

import Foundation

struct RemotiveResponse: Codable {
    var legalnotice: [String: String]
    var jobs: [[String: JobDetails]]
    var jobcount: Int
}

