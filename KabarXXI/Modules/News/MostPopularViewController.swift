//
//  MostPopularViewController.swift
//  KabarXXI_
//
//  Created by Emerio-Mac2 on 18/04/19.
//  Copyright © 2019 Emerio-Mac2. All rights reserved.
//

import UIKit

class MostPopularViewController: UITableViewController {

    @IBOutlet var newsPopularTableView: UITableView!
   
    var newsArray: [News] = []
    
    var refreshControl_: UIRefreshControl?

    var totalPage = 0
    
    var page = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        refreshControl_!.beginRefreshing()
        loadNews(page)
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNews(page)
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        
        loadNews(page)
        
    }
    
    
    func setupViews() {
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        newsPopularTableView.addSubview(refreshControl)
        self.refreshControl_ = refreshControl
        
        newsPopularTableView.addInfiniteScroll { (newsPopularTableView) in
            self.loadNews(self.page + 1)
        }
        
        newsPopularTableView.setShouldShowInfiniteScrollHandler { (newsPopularTableView) -> Bool in
            return self.page < self.totalPage
        }
        
        // self.loadNews()
    }
    
    func loadNews(_ page:Int) {
        newsProviderServices.request(.getPopularNews(page)) { [weak self] result in
            guard case self = self else { return }
            
            // 3
            switch result {
            case .success(let response):
                do {
                    
                    let decoder = JSONDecoder()
                    let responses = try decoder.decode(NewsResponse.self, from:
                        response.data)
                    
                    if page == 0 {
                        self?.newsArray = responses.data ?? []
                    }
                    else {
                        self?.newsArray.append(contentsOf: responses.data ?? [])
                    }
                    
                    self?.totalPage = self?.newsArray.count ?? 0/10
                    self?.page = page
                    self?.newsPopularTableView.reloadData()
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
                
            case .failure: break
            }
            
            self?.refreshControl_?.endRefreshing()
            self?.newsPopularTableView.finishInfiniteScroll()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        self.newsPopularTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
    
        let cell = Bundle.main.loadNibNamed("NewsItemTableViewCell", owner: self, options: nil)?.first as! NewsItemTableViewCell
        
        let news_ = newsArray[indexPath.row]
        let imageUrl = Constant.ApiUrlImage+"\(news_.base64Image ?? "")"
        cell.imageNews.kf.setImage(with: URL(string: imageUrl), placeholder: UIImage(named: "default_image"))
        cell.titleNews.text = news_.title
        cell.dateNews.text = Date.getFormattedDate(dateStringParam: news_.createdDate ?? "") 
        cell.totalViews.text = "\(news_.views ?? 0) dilihat"
        cell.save = {
            
            if let data = UserDefaults.standard.value(forKey:"news") as? Data {
                
                self.newsArray = try! PropertyListDecoder().decode(Array<News>.self, from: data)
                
                let bookmarkExist = self.newsArray.contains { data in
                    if (data.id == news_.id) {
                        return true
                    }
                    else {
                        
                        return false
                    }
                }
                
                if(bookmarkExist){
                    
                    Toast.show(message: "bookmark berhasil di simpan.", controller: self)
                    print("bookmark already saved")
                    
                }
                else {
                    
                    self.newsArray.append(news_)
                    print(self.newsArray.count)
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(self.newsArray), forKey:"news")
                    Toast.show(message: "bookmark berhasil di simpan.", controller: self)
                }
                
            }
                
            else {
                
                UserDefaults.standard.set(try? PropertyListEncoder().encode([news_]), forKey:"news")
                Toast.show(message: "bookmark berhasil di simpan.", controller: self)
                
            }
            
        }
        
        
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let newsData = newsArray[indexPath.item]
        
        showDetailNewsController(with: newsData.id ?? 0,with: newsData.title ?? "", with: newsData.createdDate ?? "", with: newsData.base64Image ?? "", with: newsData.description ?? "",with:newsData.keyword ?? "",with:newsData.category?.categoryName ?? "",with:"passingData" )
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 140
        
    }
    

}
