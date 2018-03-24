//
//  ViewController.swift
//  iOSRecruitmentTest
//
//  Created by Bazyli Zygan on 15.06.2016.
//  Copyright © 2016 Snowdog. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let service = RecruitmentItemService()
    private let itemMapper = RecruitmentItemMapper()
    private var recruitmentItemsEntityData: [RecruitmentItemEntity] = []
    private let recruitmentItemsFetcher = RecruitmentItemsFetcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewConfiguration()
        self.recruitmentItemsEntityData = self.recruitmentItemsFetcher.fetchRecruitmentItemsFromCore()
        if recruitmentItemsEntityData.count == 0 {
            self.fetchData()
        }
    }
    
    fileprivate func fetchData() {
        PersistenceService.deleteAll()
        self.service.fetchData(successHandler: { response in
            self.recruitmentItemsEntityData = self.itemMapper.mapToEntity(with: response)
            DispatchQueue.main.async(execute: { () -> Void in
                self.tableView.reloadData()
            })
        }){
            print("Error in VC with fetching data")
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    static let tableViewCellIdentifier = "TableViewCell"

    fileprivate func tableViewConfiguration() {
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: ViewController.tableViewCellIdentifier)
    }
    
    // MARK: - UITableView data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recruitmentItemsEntityData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        let model = self.recruitmentItemsEntityData[indexPath.row]
        cell.item = model
        return cell
    }
}

extension ViewController:  UISearchBarDelegate{
    
}
