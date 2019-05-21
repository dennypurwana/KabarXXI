import UIKit

class BookmarkNewsViewController: UITableViewController
{
    
    
    
    @IBOutlet var bookmarkTableView: UITableView!
    
     var refreshControl_: UIRefreshControl?
    
    var newsArray: [News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Bookmark"
        loadAllBookmark()
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadAllBookmark()
        
    }
    
    func loadAllBookmark() {
        
        if let data = UserDefaults.standard.value(forKey:"news") as? Data {
            
            self.newsArray = try! PropertyListDecoder().decode(Array<News>.self, from: data)
        
        }
        
    }
    
    
    
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        self.bookmarkTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine

    let cell = Bundle.main.loadNibNamed("NewsItemTableViewCell", owner: self, options: nil)?.first as! NewsItemTableViewCell
    
    let news_ = newsArray[indexPath.row]
    let imageUrl = Constant.ApiUrlImage+"\(news_.base64Image  ?? "")"
    cell.imageNews.kf.setImage(with: URL(string: imageUrl), placeholder: UIImage(named: "default_image"))
    cell.titleNews.text = news_.title ?? ""
    cell.dateNews.text = Date.getFormattedDate(dateStringParam: news_.createdDate ?? "")
    cell.totalViews.text = "\(news_.views ?? 0 ) dilihat"

        return cell
    }
    
  override  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let newsData = newsArray[indexPath.item]
        showDetailNewsController(with: newsData.id ?? 0,with: newsData.title ?? "", with: newsData.createdDate ?? "", with: newsData.base64Image ?? "", with: newsData.description ?? "",with: newsData.keyword ?? "",with:newsData.category?.categoryName ?? "",with:"passingData")
        
    }
    
}

// MARK: - UIViewController
extension UIViewController {
    
    func showBookmarkViewController() {
        
        let storyboard = UIStoryboard(name: "News", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "bookmark") as! BookmarkNewsViewController
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

