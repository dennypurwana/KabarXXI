import UIKit
import DropDown

class NewsCategoryViewController:  UIViewController
, UITableViewDataSource, UITableViewDelegate
{

    @IBOutlet var selectDaerah: UIButton!
    
    @IBAction func selectDaerahTapped(_ sender: Any) {
        selectDaerahDropDown.show()
    }
    
    @IBOutlet var newsCategoryTableView: UITableView!
    
    let selectDaerahDropDown = DropDown()
    
    var newsArray: [News] = []
    var category:String = "tips"
    var refreshControl_: UIRefreshControl?
    var totalPage = 0
    var page = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        refreshControl_!.beginRefreshing()
        loadNews(page)
        setupSelectDaerahDropDown()
        selectDaerah.layer.cornerRadius = 6
        selectDaerah.layer.masksToBounds = true
        
        if (category != "tips"){
            self.navigationItem.title = category
           
            if(category == "Daerah"){
                print(category.lowercased())
                self.selectDaerah.isHidden = false
                
            }
            
            else {
                self.selectDaerah.isHidden = true
                let verticalConstraint = NSLayoutConstraint(item: newsCategoryTableView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
                view.addConstraints([verticalConstraint])
                
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNews(page)
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        
        loadNews(page)
        
    }
    
    
    func setupSelectDaerahDropDown() {
        selectDaerahDropDown.anchorView = selectDaerah
        selectDaerahDropDown.bottomOffset = CGPoint(x: 0, y: selectDaerah.bounds.height)
        selectDaerahDropDown.dataSource = [
            
            "Aceh",
            "Bandung",
            "Banten",
            "Batam",
            "Bekasi",
            "Jambi",
            "Kepri",
            "Lampung",
            "NTT",
            "Papua",
            "Riau",
            "Sumatera Barat",
            "Sumatera Selatan",
            "Sumatera Utara"
            
        ]
    
        selectDaerahDropDown.selectionAction = { [weak self] (index, item) in
            self?.selectDaerah.setTitle(item, for: .normal)
            self?.selectDaerahDropDown.hide()
            print(item)
            self?.category = item
            self?.loadNews((self?.page)!)
        }
        
    }
    
    func setupViews() {
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        newsCategoryTableView.addSubview(refreshControl)
        self.refreshControl_ = refreshControl
        newsCategoryTableView.addInfiniteScroll { (tipsTableView) in
            self.loadNews(self.page + 1)
        }
        
        newsCategoryTableView.setShouldShowInfiniteScrollHandler { (newsCategoryTableView) -> Bool in
            return self.page < self.totalPage
        }
        
        
        
        // self.loadNews()
    }
    
    func loadNews(_ page:Int) {
        newsProviderServices.request(.getNewsByCategory(page: page,categoryName: category)) { [weak self] result in
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
                    self?.newsCategoryTableView.reloadData()
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
                
            case .failure: break
            }
            
            self?.refreshControl_?.endRefreshing()
            self?.newsCategoryTableView.finishInfiniteScroll()
        }
        
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        self.newsCategoryTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
       
        if (self.category == "tips"){
            
        let cell = Bundle.main.loadNibNamed("NewsItemTableViewCell", owner: self, options: nil)?.first as! NewsItemTableViewCell
        
        let news_ = newsArray[indexPath.row]
        print(news_.title as Any)
            let imageUrl = Constant.ApiUrlImage+"\(news_.base64Image  ?? "")"
            cell.imageNews.kf.setImage(with: URL(string: imageUrl), placeholder: UIImage(named: "default_image"))
        cell.titleNews.text = news_.title
       cell.dateNews.text = Date.getFormattedDate(dateStringParam: news_.createdDate ?? "")
        return cell
            
        }
        else
        {
            let cell = Bundle.main.loadNibNamed("NewsHeaderTableViewCell", owner: self, options: nil)?.first as! NewsHeaderTableViewCell
            
            let news_ = newsArray[indexPath.row]
            print(news_.title as Any)
            let imageUrl = Constant.ApiUrlImage+"\(news_.base64Image  ?? "")"
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
    }
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let newsData = newsArray[indexPath.item]
        
        showDetailNewsController(with: newsData.id ?? 0,with: newsData.title ?? "", with: newsData.createdDate ?? "", with: newsData.base64Image ?? "", with: newsData.description ?? "",with:newsData.keyword ?? "",with:newsData.category?.categoryName ?? "",with:"passingData")
        
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(self.category == "tips"){
            
            return 140
            
        }else {
            
            return 250
        }
        
    }

}



// MARK: - UIViewController
extension UIViewController {
    
    func showNewsByCategoryController(with categoryName: String) {
        
        let storyboard = UIStoryboard(name: "News", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "categoryNews") as! NewsCategoryViewController
        vc.category = categoryName
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
