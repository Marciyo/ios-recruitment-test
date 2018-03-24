//
//  RecruitmentItemsFetcher.swift
//  iOSRecruitmentTest
//
//  Created by Marcel Mierzejewski on 3/24/18.
//  Copyright © 2018 Snowdog. All rights reserved.
//

import Foundation
import CoreData

struct RecruitmentItemsFetcher {
    func fetchRecruitmentItemsFromCore() -> [RecruitmentItemEntity] {
        let fetchRequest: NSFetchRequest<RecruitmentItemEntity> = RecruitmentItemEntity.fetchRequest()
        
        do {
            let items = try PersistenceService.context.fetch(fetchRequest)
            return items
        } catch let err{
            print("Error in RecruitmentItemsFetcher: \(err.localizedDescription)")
        }
        return []
    }
}
