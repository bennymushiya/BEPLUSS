//
//  OnboardingController.swift
//  Weightloss
//
//  Created by benny mushiya on 26/04/2021.
//

import UIKit


class OnboardingController: UIViewController {
    
    //MARK: - PROPTERTIES
    
    private let backgroundImage: UIImageView = {
        let iv = UIImageView(frame: .zero)
        iv.backgroundColor = .black
        iv.contentMode = .scaleToFill
        iv.setHeight(500)
        
        return iv
    }()
    
    private var titleLabel: AuthLabels = {
        let label = AuthLabels(title: "")
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.textAlignment = .left
        
        return label
    }()
    
    private var descriptionLabel: AuthLabels = {
        let label = AuthLabels(title: "")
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 15)

        return label
    }()
    
    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = 3
        control.currentPage = 0
        control.pageIndicatorTintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        control.currentPageIndicatorTintColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        
        return control
    }()
    
    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    
    private var items = [
        
        OnboardingModel(title: "JOIN A COMMUNUNITY", description: "Join a community of like-minded individuals, to accomplish your fitness/physical goals to become a better version of yourself.", backgroundImage: UIImage(named: "onboarding 1")),
        
        OnboardingModel(title: "INTERACT", description: "Share your thoughts and connect with your peers through a cross platform feed, that enables you to share your journey of progression.", backgroundImage: UIImage(named: "onboarding2")),
        
        OnboardingModel(title: "BECOME A CORE MEMBER OF THE COMMUNITY", description: "Relate to other users posts that walked the same journey. and follow monthly challeneges to hasten your set goals.", backgroundImage: UIImage(named: "oboarding3"))
    
    ]
    
    private var currentPage = 0
    
    private let signUpButton: AuthButton = {
        let button = AuthButton(title: "Sign Up", type: .system)
        button.isEnabled = true
        button.alpha = 0
        button.backgroundColor = .clear
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        button.layer.borderWidth = 5.0
        
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)

        return button
    }()
    
    private let logInButton: AuthButton = {
        let button = AuthButton(title: "Log In", type: .system)
        button.isEnabled = true
        button.alpha = 0
        button.backgroundColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)

        return button
    }()
    
    //MARK: - LIFECYLE

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        tapGestureRecogniser()
        setUpPageControl()
        configureDarkView()
        assignArrayToProperties(index: currentPage)
        updateBackgroundImage(index: currentPage)
        
    }
    
    //MARK: - HELPERS

    
    func configureUI() {
        
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        view.addSubview(backgroundImage)
        backgroundImage.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingRight: 0)
        
        let labelStack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 10
        
        view.addSubview(labelStack)
        labelStack.anchor(top: backgroundImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 10)
        
        view.addSubview(pageControl)
        pageControl.centerX(inView: view)
        pageControl.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 30)
        
        let buttonStack = UIStackView(arrangedSubviews: [signUpButton, logInButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 20
        buttonStack.distribution = .fillEqually
        
        view.addSubview(buttonStack)
        buttonStack.centerX(inView: view)
        buttonStack.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 20, paddingBottom: 70, paddingRight: 20)
    }
    
    // gives the background of the view a touch effect, so if they touch it we can add funcyionality.
    func tapGestureRecogniser() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapAnimation))
        
        view.addGestureRecognizer(tapGesture)
        
    }
    
    //MARK: - ACTION

    // we assign the number items inside the items array to our page control numbers.
    func setUpPageControl() {
        
        pageControl.numberOfPages = self.items.count
    }
    
    
    // returns a true or false value, if current page is equal to the amount of items inside the array then its true.
    func overLastItem() -> Bool {
        
       return currentPage == self.items.count
        
    }
    
    func assignArrayToProperties(index: Int) {
        
        titleLabel.text = items[index].title
        descriptionLabel.text = items[index].description
        backgroundImage.image = items[index].backgroundImage
        pageControl.currentPage = index
        
        self.titleLabel.alpha = 1
        self.descriptionLabel.alpha = 1
        self.titleLabel.transform = .identity
        self.descriptionLabel.transform = .identity
        
    }
    
    
    func updateBackgroundImage(index: Int) {
        
        // assigns the images of the array to a property
        let image = self.items[index].backgroundImage
        
        // animates the background image of the screen and produces a new one.
        UIView.transition(with: backgroundImage, duration: 1.0, options: .transitionCurlDown, animations: {self.backgroundImage.image = image}, completion: nil)
        
    }
    
    
    // makes the background image slightly darker so the writing can be seen properly
    func configureDarkView() {
        
        topView.backgroundColor = UIColor.init(white: 0.1, alpha: 0.5)
    }
    
    
    func showAnimatedButtons() {
        
        UIView.animate(withDuration: 0.9) {
            
            self.logInButton.alpha = 1
            self.signUpButton.alpha = 1
            self.pageControl.alpha = 0
        }
    }
    
    //MARK: - SELECTORS

    // animates the writings off the screen
    @objc func handleTapAnimation() {
        
        
        // configures an animation, and controls the speed and angle of the animation.
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            self.titleLabel.alpha = 0.8
            
            // moves the label 30 points to the left
            self.titleLabel.transform = CGAffineTransform(translationX: -30, y: 0)
            
        }) { _ in
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                
                self.titleLabel.alpha = 0
                
                // moves the label off screen
                self.titleLabel.transform = CGAffineTransform(translationX: 0, y: -550)
                
            }, completion: nil)
    
        }
        
        // second animation = second label
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            self.descriptionLabel.alpha = 0.8
            self.descriptionLabel.transform = CGAffineTransform(translationX: -30, y: 0)
            
        }) { _ in
            
            if self.currentPage < self.items.count - 1 {
                
            self.updateBackgroundImage(index: self.currentPage + 1)
                
            }
            UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                
                self.descriptionLabel.alpha = 0
                self.descriptionLabel.transform = CGAffineTransform(translationX: 0, y: -550)
                
            }) { _ in
                
                if self.currentPage + 1 < self.items.count + 1 {
                    
                    // increments the pageControl index with 1, bring it to the next page
                    self.currentPage += 1
                }
                
                // current page which starts off at 0 equals the items array which also starts off at 0 then show the buttons.
                if self.overLastItem() {
                                     
                    self.showAnimatedButtons()
                    
                }else {
        
                    // calls the function set up screen, with a parameter of currentPage.
                    self.assignArrayToProperties(index: self.currentPage)
                    
                }
        
            }

        }
    }
    
    
    @objc func handleSignUp() {
        
        let controller = RegistrationController()
         navigationController?.pushViewController(controller, animated: true)
    }
    
    
    
    @objc func handleLogIn() {
        
       let controller = LogInController()
        navigationController?.pushViewController(controller, animated: true)
       
    }
    
    
    
    
    
    
    
}
