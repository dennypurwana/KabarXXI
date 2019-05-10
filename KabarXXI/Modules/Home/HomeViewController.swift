

import UIKit
import CarbonKit
import GoogleMobileAds
import Firebase

class HomeViewController: UIViewController
, CarbonTabSwipeNavigationDelegate , GADInterstitialDelegate, UISearchBarDelegate
{
    
    
    let items = ["Terbaru", "Berita Utama", "Berita Populer", "Opini","Info & Tips"]
    var interstitial : GADInterstitial!
    var newsArray: [News] = []
    var totalPage = 0
    var page = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        setupNavBar()
        setupTabbarNews()
       
//        interstitial = createAndLoadIntertitial()
//
//        if interstitial.isReady {
//
//            interstitial.present(fromRootViewController: self)
//
//        }
//        else {
//
//            print("ads interstial not ready")
//        }
      
    }
    
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
        interstitial = createAndLoadIntertitial()
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
        interstitial = createAndLoadIntertitial()
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadIntertitial()
    }
    
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
        interstitial = createAndLoadIntertitial()
    }
   
    
    
    func createAndLoadIntertitial() -> GADInterstitial{
        
        let intertitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        intertitial.delegate = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        intertitial.load(request)
        return intertitial
        
    }
    

    
    func setupNavBar(){
        
           // searchBar.delegate = self
            let logoImage = UIImage.init(named: "logo_kabar")
            let logoImageView = UIImageView.init(image: logoImage)
            logoImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
            logoImageView.contentMode = .scaleAspectFit
            let imageItem = UIBarButtonItem.init(customView: logoImageView)
            let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            negativeSpacer.width = -25
            self.navigationItem.leftBarButtonItems = [negativeSpacer, imageItem]
            let btnSearching = UIButton(frame: CGRect(x:0,y:0,width:10,height:10))
            btnSearching.setImage(UIImage(named: "search"), for: .normal)
            btnSearching.addTarget(self,action: #selector(btnSearchingTapped), for: .touchUpInside)
            let rightButton = UIBarButtonItem(customView: btnSearching)
            self.navigationItem.setRightBarButtonItems([rightButton], animated: true)
        
    }
    
    @objc func btnSearchingTapped(_ sender: Any) {
        
        showSearchingViewController()
        print("searching event")
        
    }
    
    func setupTabbarNews(){
        
        let carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items, delegate: self)
        carbonTabSwipeNavigation.setNormalColor(.darkGray)
        carbonTabSwipeNavigation.setSelectedColor(.black)
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        
        
        if (index == 0){
            let newsLatest = UIStoryboard(name: "News", bundle: nil).instantiateViewController(withIdentifier: "newsLatest")
            return newsLatest
        }
       
        else if (index == 1 ){
          
            let newsPremier = UIStoryboard(name: "News", bundle: nil).instantiateViewController(withIdentifier: "newsPremier")
            return newsPremier
            
        }
            
        else if (index == 2 ){
            
            let newsPremier = UIStoryboard(name: "News", bundle: nil).instantiateViewController(withIdentifier: "newsMostPopular")
            return newsPremier
            
        }
            
        else if (index == 3 ){
            
            let newsMostCommented = UIStoryboard(name: "News", bundle: nil).instantiateViewController(withIdentifier: "newsMostCommented")
            return newsMostCommented
            
        }
            
        else {
            
            let newsTips = UIStoryboard(name: "News", bundle: nil).instantiateViewController(withIdentifier: "categoryNews")
            return newsTips
            
        }
        
        
    }
    
}
       
