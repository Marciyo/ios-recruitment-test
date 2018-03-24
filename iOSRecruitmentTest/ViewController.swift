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
    
    fileprivate let refreshControl = UIRefreshControl()

    let service = RecruitmentItemService()
    private let itemMapper = RecruitmentItemMapper()
    private var recruitmentItemsEntityData: [RecruitmentItemEntity] = []
    private let recruitmentItemsFetcher = RecruitmentItemsFetcher()
    
    private let imageCacheAssistant = ImageCacheAssistant()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewConfiguration()
        self.recruitmentItemsEntityData = self.recruitmentItemsFetcher.fetchRecruitmentItemsFromCore()
        if recruitmentItemsEntityData.count == 0 {
            self.fetchData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.imageCacheAssistant.clearCache()
    }
    
    @objc fileprivate func fetchData() {
        PersistenceService.deleteAll()
        self.service.fetchData(successHandler: { response in
            self.recruitmentItemsEntityData = self.itemMapper.mapToEntity(with: response)
            DispatchQueue.main.async(execute: { () -> Void in
                self.imageCacheAssistant.clearCache()
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            })
        }){
            print("Error in VC with fetching data")
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    static let tableViewCellIdentifier = "TableViewCell"

    fileprivate func tableViewConfiguration() {
        self.refreshControl.addTarget(self, action: #selector(self.fetchData), for: UIControlEvents.valueChanged)
        self.tableView.refreshControl = refreshControl
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
        
        if let image = self.imageCacheAssistant.getImage(for: model.iconUrl ?? "") {
            cell.iconView.image = image
        } else {
            ImageDownloader.downloadedFrom(link: model.iconUrl ?? "", completion: { [weak self] image in
                DispatchQueue.main.async(execute: { () -> Void in
                    self?.imageCacheAssistant.setImage(image, for: model.iconUrl ?? "")
                    if let cell = self?.tableView.cellForRow(at: indexPath) as? TableViewCell {
                        cell.iconView.image = image
                    }
                })
            })
        }
        return cell
    }
}

extension ViewController:  UISearchBarDelegate{
    
}
