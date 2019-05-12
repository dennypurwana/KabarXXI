
import UIKit
import RxSwift
import Kingfisher
import UIScrollView_InfiniteScroll
import RealmSwift
import CoreSpotlight
import MobileCoreServices
import Firebase
import GoogleMobileAds

class NewsLatestViewController: UITableViewController , GADUnifiedNativeAdLoaderDelegate {

    @IBOutlet var newsTableView: UITableView!
    var interstitial: GADInterstitial!
    
    
    let adUnitID = "ca-app-pub-3940256099942544/3986624511"
    var indicator = UIActivityIndicatorView()
    let numAdsToLoad = 5
    var nativeAds = [GADUnifiedNativeAd]()
    var adLoader: GADAdLoader!
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
        setupAds()
        refreshControl_!.beginRefreshing()
        loadNews(page)
       

    }
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x:0, y:0, width:40, height:40))
        indicator.style = UIActivityIndicatorView.Style.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNews(page)
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
       
        loadNews(page)
        
    }
    
    func registerCell(){
        
        tableView.register(UINib(nibName: "NewsItemTableViewCell", bundle: nil),forCellReuseIdentifier:  "NewsItemTableViewCell")
        
        tableView.register(UINib(nibName: "NewsHeaderTableViewCell", bundle: nil),forCellReuseIdentifier:  "NewsHeaderTableViewCell")
        
        tableView.register(UINib(nibName: "UnifiedNativeAdCell", bundle: nil),
            forCellReuseIdentifier: "UnifiedNativeAdCell")
    }
    
    func setupAds(){
        
        let options = GADMultipleAdsAdLoaderOptions()
        options.numberOfAds = numAdsToLoad
        adLoader = GADAdLoader(adUnitID: adUnitID,
                               rootViewController: self,
                               adTypes: [.unifiedNative],
                               options: [options])
        adLoader.delegate = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        adLoader.load(request)
        
    }
    
    func setupViews() {
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        newsTableView.addSubview(refreshControl)
        self.refreshControl_ = refreshControl
        newsTableView.addInfiniteScroll { (newsTableView) in
            self.loadNews(self.page + 1)
        }
        
        newsTableView.setShouldShowInfiniteScrollHandler { (newsTableView) -> Bool in
            return self.page < self.totalPage
        }
        
    }
    
    func loadNews(_ page:Int) {
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.darkGray
        newsProviderServices.request(.getLatestNews(page)) { [weak self] result in
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
                    self?.newsTableView.reloadData()
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
                
            case .failure: break
            }
            
            self?.refreshControl_?.endRefreshing()
            self?.newsTableView.finishInfiniteScroll()
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return tableViewItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
    if let nativeAd = tableViewItems[indexPath.row] as? GADUnifiedNativeAd {
       
        nativeAd.rootViewController = self
        
        let nativeAdCell = tableView.dequeueReusableCell(
            withIdentifier: "UnifiedNativeAdCell", for: indexPath)
        
        let adView : GADUnifiedNativeAdView = nativeAdCell.contentView.subviews
            .first as! GADUnifiedNativeAdView
    
        adView.nativeAd = nativeAd
        
        (adView.headlineView as! UILabel).text = nativeAd.headline
        (adView.priceView as! UILabel).text = nativeAd.price
        if let starRating = nativeAd.starRating {
            (adView.starRatingView as! UILabel).text =
                starRating.description + "\u{2605}"
        } else {
            (adView.starRatingView as! UILabel).text = nil
        }
        (adView.bodyView as! UILabel).text = nativeAd.body
        (adView.advertiserView as! UILabel).text = nativeAd.advertiser
        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
        (adView.callToActionView as! UIButton).setTitle(
        nativeAd.callToAction, for: UIControl.State.normal)
        
        return nativeAdCell
        
        }
    else
    
    {
        let news_ = tableViewItems[indexPath.row] as? News
        
        if  indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsHeaderTableViewCell",for: indexPath) as! NewsHeaderTableViewCell
          
            let imageUrl = Constant.ApiUrlImage+"\(news_?.base64Image  ?? "")"
            cell.imageNews.kf.setImage(with: URL(string: imageUrl), placeholder: UIImage(named: "default_image"))
            cell.titleNews.text = news_?.title ?? ""
            cell.dateNews.text = Date.getFormattedDate(dateStringParam: news_?.createdDate ?? "") 
           cell.totalViews.text = "\(news_?.views ?? 0 ) dilihat"
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
            
        else {
           
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsItemTableViewCell",for: indexPath) as! NewsItemTableViewCell
          
            let imageUrl = Constant.ApiUrlImage+"\(news_?.base64Image  ?? "")"
            cell.imageNews.kf.setImage(with: URL(string: imageUrl), placeholder: UIImage(named: "default_image"))
            cell.titleNews.text = news_?.title ?? ""
            cell.dateNews.text = Date.getFormattedDate(dateStringParam: news_?.createdDate ?? "")
            cell.totalViews.text = "\(news_?.views ?? 0 ) dilihat"
            
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
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let newsData = tableViewItems[indexPath.item] as? News
        
        showDetailNewsController(with: newsData?.id ?? 0,with: newsData?.title ?? "", with: newsData?.createdDate ?? "", with: newsData?.base64Image ?? "", with: newsData?.description ?? "",with: newsData?.keyword ?? "",with:newsData?.category?.categoryName ?? "")
    
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if  indexPath.row == 0 {
            return 250
            
        }
        else  {
            return 120
        }
    }
    

    func addNativeAds() {
        if nativeAds.count <= 0 {
            return
        }
        
        let adInterval = 4
        var index = 1
        for nativeAd in nativeAds {
            if index < tableViewItems.count {
                tableViewItems.insert(nativeAd, at: index)
                index += adInterval
            } else {
                break
            }
        }
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        print("Received native ad: \(nativeAd)")
        nativeAds.append(nativeAd)
    }
    
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        print("dapat ads nya")
        addNativeAds()
    }

}


extension UIViewController {
    
    func showLatestViewController() {
        
        let storyboard = UIStoryboard(name: "News", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "newsLatest") as! NewsLatestViewController
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
    

