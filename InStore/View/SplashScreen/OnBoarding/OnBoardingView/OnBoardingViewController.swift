//
//  OnBoardingViewController.swift
//  InStore
//
//  Created by Mohamed Ahmed on 25/05/2022.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit

class OnBoardingViewController: UIViewController {
    
    //MARK: - IBOutlet

    @IBOutlet weak var onBoardCollectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var getStartedBtn: UIButton!
    
    
    //MARK: - Properties

    var slides: [OnboardingSlide] = []
    var currentPage = 0 {
        didSet{
            pageControl.currentPage = currentPage
            if currentPage == slides.count-1 {
                getStartedBtn.setTitle("Get Started", for: .normal)
            }
            else{
                getStartedBtn.setTitle("Next", for: .normal)
            }
        }
        
    }
    
    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initSlides()
        configureCollectionViews()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - Methodes
    
    private func configureCollectionViews(){
        registerCellsForCollectionView()
        setupCollectionViewDataSource()
    }
    private func setupCollectionViewDataSource(){
        
        onBoardCollectionView.dataSource = self
        onBoardCollectionView.delegate   = self
    }
    
    private func registerCellsForCollectionView(){
        let slideNib = UINib(nibName: String(describing: OnBoardingCollectionViewCell.self), bundle: nil)
        onBoardCollectionView.register(slideNib, forCellWithReuseIdentifier: String(describing: OnBoardingCollectionViewCell.self) )
    }
    
    private func initSlides(){
        slides = [OnboardingSlide(title: "Welcome!", description: "It’s a pleasure to meet you. We are excited that you’re here so let’s get started!", image: #imageLiteral(resourceName: "onBoarding1")),
                  OnboardingSlide(title: "Irrelevant \nresults again?", description: "No need to rummage through irrelevant items anymore, we got you covered. inStore sends you relevant items based off of your habits and interests.", image: #imageLiteral(resourceName: "onboarding2")),
                  OnboardingSlide(title: "Your interests\nworking with you.", description: "Tell us what you like. No, really, it helps a bunch when we serve you some great products. You just keep doing your thing.", image: #imageLiteral(resourceName: "onboarding3")),]
    }
    
    //MARK: - IBActions

    @IBAction func onSkipBtnClick(_ sender: UIButton) {
        print("perform navigation")
       let viewController = UIStoryboard(name: "HomeScreen", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBar") as! UITabBarController
        viewController.modalPresentationStyle = .fullScreen
        MyUserDefaults.add(val: false, key: .loggedIn)
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func onGetStartedClick(_ sender: UIButton) {
        
        if currentPage == slides.count - 1 {
            print("perform navigation")
            let viewController = UIStoryboard(name: "SplashScreen", bundle: nil).instantiateViewController(withIdentifier: String(describing: GetStartedViewController.self))
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
            
            
        }else{
            
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            onBoardCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
    }
    
}


//MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension OnBoardingViewController : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: OnBoardingCollectionViewCell.self), for: indexPath) as! OnBoardingCollectionViewCell
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: onBoardCollectionView.frame.width, height: onBoardCollectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x/width)
    }
    
    
    
}
