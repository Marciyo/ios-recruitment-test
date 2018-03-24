//
//  RecruitmentItemModel.swift
//  iOSRecruitmentTest
//
//  Created by Marcel Mierzejewski on 3/24/18.
//  Copyright © 2018 Snowdog. All rights reserved.
//

import UIKit

struct RecruitmentItemModel: Decodable {
    let id: Int
    let name: String
    let description: String
    let icon: String
    let timestamp: Double
    let url: String
}
