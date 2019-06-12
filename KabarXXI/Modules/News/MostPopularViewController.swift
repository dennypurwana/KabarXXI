//
//  MostPopularViewController.swift
//  KabarXXI_
//
//  Created by Emerio-Mac2 on 18/04/19.
//  Copyright © 2019 Emerio-Mac2. All rights reserved.
//
import UIKit
import RxSwift
import Kingfisher
import UIScrollView_InfiniteScroll
import CoreSpotlight
import MobileCoreServices
import Firebase
import GoogleMobileAds

class MostPopularViewController: UITableViewController  , GADBannerViewDelegate{

    @IBOutlet var newsPopularTableView: UITableView!
    var adsToLoad = [GADBannerView]()
    var loadStateForAds = [GADBannerView: Bool]()
    let adUnitID = "ca-app-pub-3940256099942544/2934735716"
    let adInterval = UIDevice.current.userInterfaceIdiom == .pad ? 16 : 8
    let adViewHeight = CGFloat(100)
    // let adUnitID = "ca-app-pub-8483206325913349/4378542873"
    var indicator = UIActivityIndicatorView()
    var tableViewItems : [Any] = []
    var newsArray: [News] = []
    var refreshControl_: UIRefreshControl?
    let disposeBag = DisposeBag()
    var totalPage = 0
    var page = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
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
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x:0, y:0, width:40, height:40))
        indicator.style = UIActivityIndicatorView.Style.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    func registerCell(){
        
        tableView.register(UINib(nibName: "NewsItemTableViewCell", bundle: nil),forCellReuseIdentifier:  "NewsItemTableViewCell")
        
        tableView.register(UINib(nibName: "NewsHeaderTableViewCell", bundle: nil),forCellReuseIdentifier:  "NewsHeaderTableViewCell")
        
        tableView.register(UINib(nibName: "BannerAd", bundle: nil),
                           forCellReuseIdentifier: "BannerViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 135
    }
    
    
    
    func adViewDidReceiveAd(_ adView: GADBannerView) {
        print("received ads")
        loadStateForAds[adView] = true
        preloadNextAd()
    }
    
    func adView(_ adView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("Failed to receive ad: \(error.localizedDescription)")
        preloadNextAd()
    }
    
    
    func addBannerAds() {
        print("add banner")
        var index = adInterval
        tableView.layoutIfNeeded()
        while index < tableViewItems.count {
            let adSize = GADAdSizeFromCGSize(
                CGSize(width: tableView.contentSize.width, height: adViewHeight))
            let adView = GADBannerView(adSize: adSize)
            adView.adUnitID = adUnitID
            adView.rootViewController = self
            adView.delegate = self
            tableViewItems.insert(adView, at: index)
            adsToLoad.append(adView)
            loadStateForAds[adView] = false
            index += adInterval
        }
    }
    
    func preloadNextAd() {
        print("preload ads")
        if !adsToLoad.isEmpty {
            let ad = adsToLoad.removeFirst()
            let adRequest = GADRequest()
            adRequest.testDevices = [ kGADSimulatorID ]
            print("testing ads")
            ad.load(adRequest)
        }
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
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.darkGray
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
                        
                        self?.tableViewItems = responses.data ?? []
                        
                    }
                    else {
                        
                        self?.tableViewItems.append(contentsOf: responses.data ?? [])
                        
                    }
                    
                    self?.totalPage = self?.tableViewItems.count ?? 0/10
                    self?.page = page
                    self?.newsPopularTableView.reloadData()
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
                
            case .failure: break
            }
            
            self?.refreshControl_?.endRefreshing()
            self?.newsPopularTableView.finishInfiniteScroll()
            self?.addBannerAds()
            self?.preloadNextAd()
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewItems.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let BannerView = tableViewItems[indexPath.row] as? GADBannerView {
            let reusableAdCell = tableView.dequeueReusableCell(withIdentifier: "BannerViewCell", for: indexPath)
            
            
            for subview in reusableAdCell.contentView.subviews {
                subview.removeFromSuperview()
            }
            
            reusableAdCell.contentView.addSubview(BannerView)
            BannerView.center = reusableAdCell.contentView.center
            return reusableAdCell
            
        }
        else {
        
        let news_ = tableViewItems[indexPath.row] as? News
        self.newsPopularTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
    
        let cell = Bundle.main.loadNibNamed("NewsItemTableViewCell", owner: self, options: nil)?.first as! NewsItemTableViewCell
            let imageUrl = Constant.ApiUrlImage+"\(news_?.base64Image?.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)  ?? "")"
        cell.imageNews.kf.setImage(with: URL(string: imageUrl), placeholder: UIImage(named: "default_image"))
            cell.titleNews.text = news_?.title
            cell.dateNews.text = Date.getFormattedDate(dateStringParam: news_?.createdDate ?? "")
            cell.totalViews.text = "\(news_?.views ?? 0) dilihat"
        cell.save = {
            
            if let data = UserDefaults.standard.value(forKey:"news") as? Data {
                
                self.newsArray = try! PropertyListDecoder().decode(Array<News>.self, from: data)
                
                let bookmarkExist = self.newsArray.contains { data in
                    if (data.id == news_?.id) {
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
                    
                    self.newsArray.append(news_!)
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
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let newsData = newsArray[indexPath.item]
        
        showDetailNewsController(with: newsData.id ?? 0,with: newsData.title ?? "", with: newsData.createdDate ?? "", with: newsData.base64Image ?? "", with: newsData.description ?? "",with:newsData.keyword ?? "",with:newsData.category?.categoryName ?? "",with:"passingData" )
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let tableItem = tableViewItems[indexPath.row] as? GADBannerView {
            let isAdLoaded = loadStateForAds[tableItem]
            return isAdLoaded == true ? adViewHeight : 0
        } else {
        return 140
        }
        
    }
    

}
