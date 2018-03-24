//
//  ViewController.swift
//  iOSRecruitmentTest
//
//  Created by Bazyli Zygan on 15.06.2016.
//  Copyright © 2016 Snowdog. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ShowsAlert {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let refreshControl = UIRefreshControl()

    let service = RecruitmentItemService()
    private let itemMapper = RecruitmentItemMapper()
    private var recruitmentItemsEntityData: [RecruitmentItemEntity] = []
    private var filteredRecruitmentItemsEntityData: [RecruitmentItemEntity] = []
    private let recruitmentItemsFetcher = RecruitmentItemsFetcher()
    
    private let imageCacheAssistant = ImageCacheAssistant()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewConfiguration()
        self.recruitmentItemsEntityData = self.recruitmentItemsFetcher.fetchRecruitmentItemsFromCore().sorted(by: { $0.id < $1.id })

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
            DispatchQueue.main.async(execute: { [weak self] () -> Void in
                self?.imageCacheAssistant.clearCache()
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
                if let text = self?.searchBar.text {
                    self?.filterContentForSearchText(text)
                }
            })
        }){
            DispatchQueue.main.async(execute: { [weak self] () -> Void in
                self?.refreshControl.endRefreshing()
                })
            self.showAlert(message: "Couldn't fetch data from the server")
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
        if searchBarIsEmpty() {
            return self.recruitmentItemsEntityData.count
        }
        return self.filteredRecruitmentItemsEntityData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        
        let model: RecruitmentItemEntity
        if self.searchBarIsEmpty() {
            model = self.recruitmentItemsEntityData[indexPath.row]
        } else {
            model = self.filteredRecruitmentItemsEntityData[indexPath.row]
        }
        
        
        
        cell.item = model
        if let image = self.imageCacheAssistant.getImage(for: model.iconUrl ?? "") {
            cell.iconView.image = image
        } else {
            ImageDownloader.downloadedFrom(link: model.iconUrl ?? "", completion: { [weak self] image in
                DispatchQueue.main.async(execute: { [weak self] () -> Void in
                    self?.imageCacheAssistant.setImage(image: image, forKey: model.iconUrl ?? "")
                    if let cell = self?.tableView.cellForRow(at: indexPath) as? TableViewCell {
                        cell.iconView.image = image
                    }
                })
            })
        }
        return cell
    }
}

extension ViewController:  UISearchBarDelegate {
    private func searchBarIsEmpty() -> Bool {
        return self.searchBar.text?.isEmpty ?? true
    }
    
    private func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        self.filteredRecruitmentItemsEntityData = self.recruitmentItemsEntityData.filter({( item : RecruitmentItemEntity) -> Bool in
            if let name = item.name{
                return name.lowercased().contains(searchText.lowercased())
            }else {
                return false
            }
        })
        UIView.transition(with: self.tableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { self.tableView.reloadData() })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterContentForSearchText(searchText)
    }
}
