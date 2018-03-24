//
//  RecruitmentItemService.swift
//  iOSRecruitmentTest
//
//  Created by Marcel Mierzejewski on 3/24/18.
//  Copyright © 2018 Snowdog. All rights reserved.
//

import Foundation

struct RecruitmentItemService {
    private var request: RecruitmentItemRequest
    
    init(request: RecruitmentItemRequest = RecruitmentItemRequest()) {
        self.request = request
    }
    
    func fetchData(successHandler: (([RecruitmentItemModel]) -> ())?, errorHandler: (() -> ())?) {
        API.fetchData(request: self.request, success: { (model: [RecruitmentItemModel]) in
            successHandler?(model)
        }) { _ in
            errorHandler?()
        }
    }
}
