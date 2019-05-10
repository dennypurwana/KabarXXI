import UIKit

class NewsSearchViewController: UIViewController,
UITableViewDataSource, UITableViewDelegate
{

    @IBOutlet var newsSearchTableView: UITableView!
    var newsArray: [News] = []
    var refreshControl_: UIRefreshControl?
    var totalPage = 0
    var page = 0
    let sampleTextField =  UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
    var searchValue:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupViews()
    }
    
    
    func setupViews() {
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        newsSearchTableView.addSubview(refreshControl)
        self.refreshControl_ = refreshControl
        newsSearchTableView.addInfiniteScroll { (newsTableView) in
            self.loadNews(self.page + 1)
        }
        
        newsSearchTableView.setShouldShowInfiniteScrollHandler { (newsSearchTableView) -> Bool in
            return self.page < self.totalPage
        }
        
    }
    
    func setupNavBar(){
        
        
        sampleTextField.placeholder = "Cari Berita"
        sampleTextField.font = UIFont.systemFont(ofSize: 15)
        sampleTextField.borderStyle = UITextField.BorderStyle.roundedRect
        sampleTextField.autocorrectionType = UITextAutocorrectionType.no
        sampleTextField.keyboardType = UIKeyboardType.default
        sampleTextField.returnKeyType = UIReturnKeyType.done
        sampleTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        sampleTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
        self.navigationItem.titleView = sampleTextField;

        let btnSearching = UIButton(frame: CGRect(x:0,y:0,width:10,height:10))
        btnSearching.setImage(UIImage(named: "search"), for: .normal)
        btnSearching.addTarget(self,action: #selector(btnSearchingTapped), for: .touchUpInside)
        let rightButton = UIBarButtonItem(customView: btnSearching)
        self.navigationItem.setRightBarButtonItems([rightButton], animated: true)
        
    }
    
    @objc func btnSearchingTapped(_ sender: Any) {
    
        self.searchValue = self.sampleTextField.text!
        loadNews(0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNews(page)
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        
        loadNews(page)
        
    }
   
    
    func loadNews(_ page:Int) {
       
        newsProviderServices.request(.searchNews(page: page,searchValue: searchValue,categoryName: "all")) { [weak self] result in
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
                    self?.newsSearchTableView.reloadData()
                    
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
                
            case .failure: break
            }
            
            self?.refreshControl_?.endRefreshing()
            self?.newsSearchTableView.finishInfiniteScroll()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        self.newsSearchTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
             let cell = Bundle.main.loadNibNamed("NewsItemTableViewCell", owner: self, options: nil)?.first as! NewsItemTableViewCell
            
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let newsData = newsArray[indexPath.item]
        
        showDetailNewsController(with: newsData.id ?? 0,with: newsData.title ?? "", with: newsData.createdDate ?? "", with: newsData.base64Image ?? "", with: newsData.description ?? "",with:newsData.keyword ?? "",with:newsData.category?.categoryName ?? "")
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return 140
    }
    
}





// MARK: - UIViewController
extension UIViewController {
    
    func showSearchingViewController() {
        
        let storyboard = UIStoryboard(name: "News", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "searchNews") as! NewsSearchViewController
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
