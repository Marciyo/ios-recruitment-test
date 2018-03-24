//
//  RecruitmentItemRequest.swift
//  iOSRecruitmentTest
//
//  Created by Marcel Mierzejewski on 3/24/18.
//  Copyright © 2018 Snowdog. All rights reserved.
//

import Foundation

struct RecruitmentItemRequest: HttpRequest {
    var method: HttpMethod = .get
    var path: String = "items"
    var parameters: [String : String] = [:]
}
