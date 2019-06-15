//
//  NewsDetailViewController.swift
//  KabarXXI_
//
//  Created by Emerio-Mac2 on 20/04/19.
//  Copyright © 2019 Emerio-Mac2. All rights reserved.
//

import UIKit


class NewsDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate   {
    
    
    var newsArray: [News] = []
    var keyword: String?
    var titleNews_: String?
    var newsDescriptions_: String?
    var imageNews_ : String = ""
    var createdDate_ : String = ""
    var category_ : String = ""
    var type_ : String = ""
    var idNews_:Int = 0
    var releaseDate: Date = Date(timeIntervalSince1970: 0)
    
    
    @IBOutlet var commentButton: UITableView!
    
    @IBOutlet var relatedNewsTableView: UITableView!
    
    @IBOutlet var imageNews: UIImageView!
    
    @IBOutlet var titleNews: UILabel!
    
    @IBOutlet var createdDate: UILabel!
    
    @IBOutlet var descNews: UILabel!
    
    @IBOutlet var category: UILabel!
    
    @IBAction func commentButtonTapped(_ sender: Any) {
        
        self.showCommentViewController(with: idNews_)
        
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = "Detail Berita"
        self.navigationController?.navigationBar.topItem?.title = "";
        let btnShare = UIButton(frame: CGRect(x:0,y:0,width:10,height:10))
        btnShare.setImage(UIImage(named: "share")?.imageWithColor(color1: UIColor.white), for: .normal)
        btnShare.addTarget(self,action: #selector(btnShareTapped), for: .touchUpInside)
        let shareButton = UIBarButtonItem(customView: btnShare)
        self.navigationItem.setRightBarButtonItems([shareButton], animated: true)
        
        if(type_ == "notifications"){
            getDetailNews(idNews_)
        }
        else
        {
           setupViews()
            
        }
       
        updateViews(idNews_)
        loadNews(keyword ?? "")
        
    }
    
   

@objc func btnShareTapped(_ sender: Any) {
    
    let shareUrl = [Constant.ShareNewsURL+"\(idNews_)"+"/"+"\(titleNews_!.replacingOccurrences(of: " ", with: "-", options: .literal, range: nil) )"]
    
    let activityVC = UIActivityViewController(activityItems: shareUrl, applicationActivities: nil)
    activityVC.popoverPresentationController?.sourceView = self.view
    self.present(activityVC, animated: true, completion: nil)
    
}
    
    
    func setupViews(){
       
        titleNews.text = titleNews_
        descNews.htmlToString(html: newsDescriptions_ ?? "")
        createdDate.text = Date.getFormattedDate(dateStringParam: createdDate_)
        category.text = category_
        let imageUrl = Constant.ApiUrlImage+"\(imageNews_.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil) )"
        imageNews.kf.setImage(with: URL(string: imageUrl), placeholder: UIImage(named: "default_image"))
        
    }
    
    override func backButtonTapped(_ sender: Any) {
        
        if navigationController?.viewControllers.first == self {
            dismiss(animated: true, completion: nil)
        }
        else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationItem.title = "Detail Berita"
    
    }
    
    
    func updateViews(_ id: Int) {
        print(id)
        newsProviderServices.request(.updateViews(id)) { [weak self] result in
            guard case self = self else { return }
            switch result {
            case .success(let response):
                
                    print("update response\(response)")
            
            case .failure: break
            }
        
        }
        
    }
    
    func loadNews(_ keyword: String) {
        print(keyword)
        newsProviderServices.request(.getRelatedNews(keyword: keyword)) { [weak self] result in
            guard case self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    
                    let decoder = JSONDecoder()
                    let responses = try decoder.decode(NewsResponse.self, from:
                        response.data)
                    print(responses)
                    self?.newsArray = responses.data ?? []
                    self?.relatedNewsTableView.reloadData()
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
                
            case .failure: break
            }
            
            self?.relatedNewsTableView.finishInfiniteScroll()
        }
        
    }
    
    func getDetailNews(_ id: Int) {
        
        newsProviderServices.request(.getDetailNews(id)) { (result) in
            
            switch result {
            case .success(let response):
                do {
                    
                    
                    let decoder = JSONDecoder()
                    let responseNews = try decoder.decode(NewsDetailResponse.self, from:
                        response.data) //Decode JSON Response Data
                    
                    print(responseNews)
                    self.titleNews_ = responseNews.data?.title
                    self.newsDescriptions_ = responseNews.data?.description
                    self.createdDate_ = (responseNews.data?.createdDate) ?? ""
                    self.category_ = responseNews.data?.category?.categoryName ?? ""
                    self.imageNews_ = responseNews.data?.base64Image ?? ""
                    self.setupViews()
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
            case .failure(let error):
                print("error : \(error)")
                
            }
        }
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        self.relatedNewsTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        let cell = Bundle.main.loadNibNamed("NewsRelatedItemViewCell", owner: self, options: nil)?.first as! NewsRelatedItemViewCell
        
        let news_ = newsArray[indexPath.row]
        cell.titleNews.text = news_.title
        cell.dateNews.text = Date.getFormattedDate(dateStringParam:news_.createdDate ?? "")
        
        return cell
    }
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let newsData = newsArray[indexPath.item]
        
        showDetailNewsController(with: newsData.id ?? 0,with: newsData.title ?? "", with: newsData.createdDate ?? "", with: newsData.base64Image!, with: newsData.description ?? "",with: newsData.keyword ?? "",with:newsData.category?.categoryName ?? "",with:"passingData")
        
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
            return 100
    
    }
    
    
    
}



// MARK: - UIViewController
extension UIViewController {
    
    func showDetailNewsController(with idNews: Int,with title: String, with createdDate: String, with imageNews: String, with description: String,with keyword: String,with categoryName: String, with type : String) {
        
        let storyboard = UIStoryboard(name: "News", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "newsDetail") as! NewsDetailViewController
        vc.idNews_ = idNews
        vc.newsDescriptions_ = description
        vc.imageNews_ = imageNews
        vc.titleNews_ = title
        vc.createdDate_ = createdDate
        vc.keyword = keyword
        vc.category_ = categoryName
        vc.type_ = type
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func showDetailNewsController(with idNews: Int, with type : String) {

        let storyboard = UIStoryboard(name: "News", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "newsDetail") as! NewsDetailViewController
        
        vc.idNews_ = idNews
        vc.type_ = type
    
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}

