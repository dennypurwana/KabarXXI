import UIKit
import AVKit

class VideoViewController: UIViewController , UICollectionViewDataSource{
   
    @IBOutlet var videoCollView: UICollectionView!
    
    @IBOutlet var videoCollectionView_: UICollectionView!
    var refreshControl : UIRefreshControl!
    var videoArray : [Video] = []
    var player = AVPlayer()
    var playerViewController = AVPlayerViewController()
   
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationItem.title = "Video"
        videoCollView.delegate = self
        videoCollView.dataSource = self
        videoCollView.register(UINib.init(nibName: "VideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "videoCell")
        // setupViews()
        // refreshControl.beginRefreshing()
        loadVideo()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadVideo()
    }
    
    func loadVideo() {
        
        
        videoProviderServices.request(.getVideo()) { [weak self] result in
            guard case self = self else { return }
            
            // 3
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let responses = try decoder.decode(VideoResponse.self, from:
                        response.data)
                    print(responses)
                    self?.videoArray = responses.data
                    self?.videoCollView.reloadData()
                    print("refreshhh video")
                } catch let parsingError {
                    print("Error", parsingError)
                }
                
            case .failure: break
            }
            
            self?.refreshControl?.endRefreshing()
            self?.videoCollView.finishInfiniteScroll()
        }
        
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        loadVideo()    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as! VideoCollectionViewCell
        cell.configure(with: videoArray[indexPath.row])
        
        cell.contentView.layer.cornerRadius = 5.0
        cell.contentView.layer.borderWidth = 2.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath (roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        return cell
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
         let video = videoArray[indexPath.item]
         playVideo(fileName: video.base64Video ?? "")
        //showLatestViewController()
        
    }
    
    
    func playVideo(fileName:String ){
        
        print (fileName)
        let url = Constant.ApiUrlVideo+"\(fileName)"
        let videoPathUrl = URL (fileURLWithPath: url)
        player = AVPlayer(url: videoPathUrl)
        playerViewController.player = player
        
        self.present(playerViewController,animated: true,completion: {
            self.playerViewController.player?.play()
        })
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width - 20
        let height = width - 100
        return CGSize(width: width, height: height)
        
    }

    
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let noOfCellsInRow = 1
//
//        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
//
//        let totalSpace = flowLayout.sectionInset.left
//            + flowLayout.sectionInset.right
//            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
//
//        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
//
//        return CGSize(width: size, height: size)
//    }
//
}





