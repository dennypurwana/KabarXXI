import UIKit
import RxSwift
import Kingfisher
import UIScrollView_InfiniteScroll
import CoreSpotlight
import MobileCoreServices

class CategoryViewController: UIViewController , UICollectionViewDataSource {
  
    @IBOutlet var collectionViewCategory: UICollectionView!
   
    var refreshControl : UIRefreshControl!
    var categoryArray : [Category] = []
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Category"
        collectionViewCategory.delegate = self 
        collectionViewCategory.dataSource = self
        loadCategories()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCategories()
        self.navigationItem.title = "Category"
    }
    
    func loadCategories() {
        
        
        newsProviderServices.request(.getCategory()) { [weak self] result in
            guard case self = self else { return }
            
            // 3
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let responses = try decoder.decode(CategoryResponse.self, from:
                        response.data)
                  
                    self?.categoryArray = responses.data ?? []
                    self?.collectionViewCategory.reloadData()
                   
                } catch let parsingError {
                    print("Error", parsingError)
                }
                
            case .failure: break
            }
            
            self?.refreshControl?.endRefreshing()
            self?.collectionViewCategory.finishInfiniteScroll()
        }
        
    }
   
    @objc func refresh(_ sender: UIRefreshControl) {
        loadCategories()    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
        
        let category_ = categoryArray[indexPath.row]
        let imageUrl = Constant.ApiUrlImage+"\(category_.base64Image?.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil) ?? "")"
        print(imageUrl)
        cell.categoryImage.kf.setImage(with: URL(string: imageUrl), placeholder: UIImage(named: "default_image"))
        cell.categoryLabel.text = category_.categoryName ?? ""

        return cell
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryData = categoryArray[indexPath.item]
        showNewsByCategoryController(with: categoryData.categoryName ?? "" )
        
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = 3
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        
        return CGSize(width: size, height: size)
    }
    
}


