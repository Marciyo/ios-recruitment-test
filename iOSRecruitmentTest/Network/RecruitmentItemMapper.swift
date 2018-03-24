//
//  RecruitmentItemMapper.swift
//  iOSRecruitmentTest
//
//  Created by Marcel Mierzejewski on 3/24/18.
//  Copyright © 2018 Snowdog. All rights reserved.
//

import Foundation
import CoreData

struct RecruitmentItemMapper {
    
    static let entityName = "RecruitmentItemEntity"
    private enum RecruitmentItemKeys {
        static let name = "name"
        static let iconUrl = "iconUrl"
        static let description = "descriptionText"
        static let url = "url"
        static let timestamp = "timestamp"
        static let id = "id"
    }
    
    func mapToEntity(with recruitmentItemModels: [RecruitmentItemModel]) -> [RecruitmentItemEntity] {
        
        var entities: [RecruitmentItemEntity] = []
        
        for recruitmentItemModel in recruitmentItemModels{
            let entity = NSEntityDescription.insertNewObject(forEntityName: RecruitmentItemMapper.entityName, into: PersistenceService.context) as! RecruitmentItemEntity
            entity.setValue(recruitmentItemModel.name, forKey: RecruitmentItemKeys.name)
            entity.setValue(recruitmentItemModel.icon, forKey: RecruitmentItemKeys.iconUrl)
            entity.setValue(recruitmentItemModel.description, forKey: RecruitmentItemKeys.description)
            entity.setValue(recruitmentItemModel.url, forKey: RecruitmentItemKeys.url)
            entity.setValue(recruitmentItemModel.timestamp, forKey: RecruitmentItemKeys.timestamp)
            entity.setValue(recruitmentItemModel.id, forKey: RecruitmentItemKeys.id)
            entities.append(entity)
        }
        PersistenceService.saveContext()
        return entities
    }
}
