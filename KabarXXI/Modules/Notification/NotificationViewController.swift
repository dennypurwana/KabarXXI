//
//  NotificationViewController.swift
//  KabarXXI_
//
//  Created by Emerio-Mac2 on 03/05/19.
//  Copyright © 2019 Emerio-Mac2. All rights reserved.
//

import UIKit

class NotificationViewController: UITableViewController {

    @IBOutlet var notificationTableView: UITableView!
    
    var notificationArray: [Notifications] = []
    
    var refreshControl_: UIRefreshControl?
    
    var totalPage = 0
    
    var page = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        refreshControl_!.beginRefreshing()
        self.navigationItem.title = "Notifications"
        loadNotifications()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNotifications()
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        
       loadNotifications()
        
    }
    
    
    func setupViews() {
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        notificationTableView.addSubview(refreshControl)
        self.refreshControl_ = refreshControl
        
    }
    
    func loadNotifications() {
        newsProviderServices.request(.getNotifications()) { [weak self] result in
            guard case self = self else { return }
            
            // 3
            switch result {
            case .success(let response):
                do {
                    
                    let decoder = JSONDecoder()
                    let responses = try decoder.decode(NotificationsResponse.self, from:
                        response.data)
                    self?.notificationArray = responses.data
                    self?.notificationTableView.reloadData()
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
                
            case .failure: break
            }
            
            self?.refreshControl_?.endRefreshing()
            self?.notificationTableView.finishInfiniteScroll()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        self.notificationTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        
        let cell = Bundle.main.loadNibNamed("NewsItemTableViewCell", owner: self, options: nil)?.first as! NewsItemTableViewCell
        
        let notifData = notificationArray[indexPath.row]
        let imageUrl = Constant.ApiUrlImage+"\(notifData.news.base64Image  ?? "")"
        cell.imageNews.kf.setImage(with: URL(string: imageUrl), placeholder: UIImage(named: "default_image"))
        cell.titleNews.text = notifData.news.title
        cell.dateNews.text = Date.getFormattedDate(dateStringParam: notifData.news.createdDate ?? "")
        cell.totalViews.text = "\(notifData.news.views ?? 0) dilihat"
        
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
        
}

}



// MARK: - UIViewController
extension UIViewController {
    
    func showNotificationsViewController() {
        
        let storyboard = UIStoryboard(name: "News", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "notification") as! NotificationViewController
        navigationController?.pushViewController(vc, animated: true)
        
    }
}



