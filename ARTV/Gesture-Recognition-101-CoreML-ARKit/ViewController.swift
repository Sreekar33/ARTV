
//
//  ViewController.swift
//  Gesture-Recognition-101-CoreML-ARKit
//
//  Created by Hanley Weng on 10/22/17.
//  Copyright © 2017 Emerging Interactions. All rights reserved.
//

//
//  ViewController.swift
//  newHandGesture
//
//  Created by sri on 10/05/21.
//

import UIKit
import SceneKit
import ARKit
import Vision


class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var debugTextView: UITextView!
    @IBOutlet weak var sideView:UIView!
    @IBOutlet weak var textOverlay: UITextField!
    
    let dispatchQueueML = DispatchQueue(label: "com.hw.dispatchqueueml") // A Serial Queue
    var visionRequests = [VNRequest]()
    private let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: 640, height: 480))
    private let uiView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
    
    var scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
    var stackView = UIStackView()
    private let uiView1 = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
    var scrollView1 = UIScrollView(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
    var stackView1 = UIStackView()
    var timer = Timer()
    var constraintBottom : NSLayoutConstraint?
    var currentButton:Int = -1
    var currentGesture:Int = -1
    var currentView:Int = -1
    var timerActive:Int=0;
    var fadingLabel: UILabel!
    @IBAction func onClick(_ sender: UIButton, forEvent event: UIEvent)
    {
       print("Button Clicked" )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFadingView()
        //stackView = UIStackView(arrangedSubviews: createButtonArray(named: "1","2","1","2","1","2","1","2","1","2","1","2"))
        //scrollView.addSubview(stackView)
        
        //addcontent()
        // Fading Label
        print("View DID LOAD")
        // Do any additional setup after loading the view, typically from a nib.
    }
    func addFadingView(){
        
        fadingLabel = UILabel()
        fadingLabel.text = "Text"
        view.addSubview(fadingLabel)
        fadingLabel.isHidden = true
        fadingLabel.translatesAutoresizingMaskIntoConstraints = false
        fadingLabel.transform = CGAffineTransform(rotationAngle: (90 * CGFloat(2 * Double.pi)) / 360.0)
        
        fadingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        fadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -170).isActive = true
        //fadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor,multiplier: -2).isActive = true
        
    }
    func fadeMessage(message: String, color: UIColor, finalAlpha: CGFloat) {
        fadingLabel.text          = message
        fadingLabel.alpha         = 0.75
        fadingLabel.isHidden      = false
        fadingLabel.textAlignment = .center
        fadingLabel.backgroundColor     = color
        fadingLabel.layer.cornerRadius  = 5
        fadingLabel.layer.masksToBounds = true
        fadingLabel.font = UIFont(name: "MarkerFelt-Wide", size: 16.0)
        fadingLabel.textColor = UIColor.white
        fadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fadingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        UIView.animate(withDuration: 3.0, animations: { () -> Void in
            self.fadingLabel.alpha = finalAlpha
        })
    }
    func setupScrollView(){
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        uiView.addSubview(scrollView)
        uiView.backgroundColor = UIColor.clear
        scrollView.centerXAnchor.constraint(equalTo: uiView.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: uiView.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: uiView.heightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: uiView.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: uiView.bottomAnchor).isActive = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.centerXAnchor.constraint(equalTo: uiView.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: uiView.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: uiView.heightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: uiView.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: uiView.bottomAnchor).isActive = true
        //scrollView.backgroundColor = UIColor.blue
        scrollView.backgroundColor = UIColor.clear
        scrollView.decelerationRate = UIScrollView.DecelerationRate.fast
        //scrollView.decelerationRate = UIScrollView.DecelerationRate.normal
        
    }
    func addcontent(){
        stackView = UIStackView(arrangedSubviews: createButtonArray(named: "1","2","3","4","5","1","2","3","4","5","1","2"))
        scrollView.addSubview(stackView)
        
        //Leading, Trailing, Top & Bottom
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.backgroundColor = UIColor.clear
        
    }
    func setupScrollView1(){
        scrollView1.translatesAutoresizingMaskIntoConstraints = false
        uiView1.addSubview(scrollView1)
        uiView1.backgroundColor = UIColor.clear
        scrollView1.centerXAnchor.constraint(equalTo: uiView1.centerXAnchor).isActive = true
        scrollView1.widthAnchor.constraint(equalTo: uiView1.widthAnchor).isActive = true
        scrollView1.heightAnchor.constraint(equalTo: uiView1.heightAnchor).isActive = true
        scrollView1.topAnchor.constraint(equalTo: uiView1.topAnchor).isActive = true
        scrollView1.bottomAnchor.constraint(equalTo: uiView1.bottomAnchor).isActive = true
        scrollView1.translatesAutoresizingMaskIntoConstraints = false
        scrollView1.centerXAnchor.constraint(equalTo: uiView1.centerXAnchor).isActive = true
        scrollView1.widthAnchor.constraint(equalTo: uiView1.widthAnchor).isActive = true
        scrollView1.heightAnchor.constraint(equalTo: uiView1.heightAnchor).isActive = true
        scrollView1.topAnchor.constraint(equalTo: uiView1.topAnchor).isActive = true
        scrollView1.bottomAnchor.constraint(equalTo: uiView1.bottomAnchor).isActive = true
        scrollView1.backgroundColor = UIColor.clear
        scrollView1.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    func addcontent1(){
        stackView1 = UIStackView(arrangedSubviews: subMenuButtonArray(named: "1","2","3","4","5","1","2","3","4","5","1","2"))
        scrollView1.addSubview(stackView1)
        
        //Leading, Trailing, Top & Bottom
        stackView1.leadingAnchor.constraint(equalTo: scrollView1.leadingAnchor).isActive = true
        stackView1.trailingAnchor.constraint(equalTo: scrollView1.trailingAnchor).isActive = true
        stackView1.topAnchor.constraint(equalTo: scrollView1.topAnchor).isActive = true
        stackView1.bottomAnchor.constraint(equalTo: scrollView1.bottomAnchor).isActive = true
        stackView1.translatesAutoresizingMaskIntoConstraints = false
        stackView1.axis = .horizontal
        stackView1.alignment = .fill
        stackView1.backgroundColor = UIColor.clear
        
    }
    func createButtonArray(named: String...) -> [UIButton]
    {
        
        return named.map{name in
            let button  = UIButton()
            //button.frame = CGRect(x: 0, y: 0, width: 50, height: 100)// (100, 100, 100, 50)
            let btnImageblur = UIImage(named: name+".jpg")
            
            let btnImage = UIImage(named: name+".jpg")
            button.setImage(btnImageblur , for: .normal)
            button.setImage(btnImage , for: .highlighted)
            //button.imageView?.contentMode = .scaleAspectFit
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitleColor(UIColor.clear, for: .normal)
            button.imageEdgeInsets =  UIEdgeInsets(top:5, left: 5, bottom: 5, right:5)
            button.addTarget(self, action: #selector(btnClicked(_:)), for: .touchUpInside)
            
            //button.addTarget(self, action: #selector(btnClicked(sender:)), for: .touchUpInside)
            return button
        }
    }
    func subMenuButtonArray(named: String...) -> [UIButton]
    {
        
        return named.map{name in
            let button  = UIButton()
            //let btnImageblur = UIImage(named: "H"+name)
            let btnImage = UIImage(named: "images/L"+name+".jpg")
            //btnImage?.stretchableImage(withLeftCapWidth: 4, topCapHeight:3)
            //button.imageView?.contentMode = .scaleAspectFit
            //button.setImage(btnImage , for: .normal)
            button.setImage(btnImage, for: UIControl.State.normal)
            //button.imageEdgeInsets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitleColor(UIColor.clear, for: .normal)
            button.imageEdgeInsets =  UIEdgeInsets(top:5, left: 5, bottom: 5, right:5)
            button.addTarget(self, action: #selector(subMenubtnClicked(_:)), for: .touchUpInside)
            button.tag = Int(name) ?? 0
            return button
        }
    }
    
}
// MARK: - Lifecycle
extension ViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        //setupViews()
        setupAR()
        setupML()
        loopCoreMLUpdate()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}

// MARK: - Setup
extension ViewController {
    private func setupAR() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        print("Done setting up gestures")
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }

    private func setupML() {
        
        guard let selectedModel = try? VNCoreMLModel(for: example_5s0_hand_model().model /*example_5s0_hand_model().model*/) else {
            fatalError("Could not load model.")
        }

        let classificationRequest = VNCoreMLRequest(model: selectedModel,
                                                    completionHandler: classificationCompleteHandler)
        visionRequests = [classificationRequest]
    }
    
}

// MARK: - Private
extension ViewController {
    func startTimer(){
        self.timerActive=1
        //print("timer Activated")
        if(self.currentView==0){
            timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(btnClicked(_:)), userInfo: "timer", repeats: true)
        }
        else if(self.currentView==1){
            if(self.currentButton != -1){
                timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(subMenuItemSelected), userInfo: "timer", repeats: true)

            }
        }
    }
    
    func resetTimer(){
        self.timerActive=0;
        //print("timer Deactivated")
        timer.invalidate()
        //startTimer()
    }
    
    @objc func btnClicked(_ sender: AnyObject?) {
      print("Button clicked here")
      addSubmenu()
      
    }
    @objc func subMenubtnClicked(_ sender: AnyObject?){
        print("Button clicked")
        let names:[String] = ["Murder Mystery","Our Planet","Tidying Up","Dead to Me","Raising Dion"]
        print(names[(sender?.tag ?? 1)-1])
        fadeMessage(message: "Opening "+names[(sender?.tag ?? 1)-1]+" Movie in Netflix" , color: .blue, finalAlpha: 0.0)
        
    }
    @objc func subMenuItemSelected(){
        let names:[String] = ["Murder Mystery","Our Planet","Tidying Up","Dead to Me","Raising Dion"]
        print("Gesture subMenu Clicked")
        print(self.currentButton)
        fadeMessage(message: "Opening "+names[self.currentButton%5]+" Movie in Netflix" , color: .black, finalAlpha: 0.0)
    }
    @objc func tapped(recognizer: UIGestureRecognizer) {
        guard let currentFrame = self.sceneView.session.currentFrame,
                let url = URL(string: "https://developer.apple.com/documentation/uikit/uiimage/creating_custom_symbol_images_for_your_app") else {
            return
        }

        webView.loadRequest(URLRequest(url: url))
        
        let browserPlane = SCNPlane(width: 0.5, height: 0.3)
        setupScrollView()
        addcontent()
        print("tapped")
        view.addSubview(uiView)
        uiView.isOpaque = false
        uiView.alpha=0.9
        browserPlane.firstMaterial?.diffuse.contents = uiView
        browserPlane.firstMaterial?.isDoubleSided = true
        
        let browserPlaneNode = SCNNode(geometry: browserPlane)

        var translation = matrix_identity_float4x4
        translation.columns.3.z = -1.0
        
        browserPlaneNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
        browserPlaneNode.eulerAngles = SCNVector3Zero
        self.currentView = 0
        self.currentButton = -1
        self.sceneView.scene.rootNode.addChildNode(browserPlaneNode)
    }
    
    func addSubmenu() {
        guard let currentFrame = self.sceneView.session.currentFrame,
                let url = URL(string: "https://developer.apple.com/documentation/uikit/uiimage/creating_custom_symbol_images_for_your_app") else {
            return
        }

        let browserPlane = SCNPlane(width: 0.5, height: 0.3)
        setupScrollView1()
        addcontent1()
        print("tapped")
        view.addSubview(uiView1)
        uiView1.isOpaque = false
        uiView1.alpha=1.0
        browserPlane.firstMaterial?.diffuse.contents = uiView1
        browserPlane.firstMaterial?.isDoubleSided = true

        let browserPlaneNode = SCNNode(geometry: browserPlane)

        var translation = matrix_identity_float4x4
        translation.columns.3.z = -1.0

        browserPlaneNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
        browserPlaneNode.position = SCNVector3Make(0, 0, -0.5)
        browserPlaneNode.eulerAngles = SCNVector3Zero
        self.currentView=1
        self.currentButton = -1
        self.sceneView.scene.rootNode.addChildNode(browserPlaneNode)
    }
    private func loopCoreMLUpdate() {
        dispatchQueueML.async {
            self.updateCoreML()
            self.loopCoreMLUpdate()
        }
    }
}

// MARK: - Private
extension ViewController {
    private func updateCoreML() {
        let pixbuff : CVPixelBuffer? = (sceneView.session.currentFrame?.capturedImage)
        if pixbuff == nil { return }
        let ciImage = CIImage(cvPixelBuffer: pixbuff!)

        let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])

        do {
            try imageRequestHandler.perform(self.visionRequests)
        } catch {
            print(error)
        }
    }
}
// MARK: - Private
extension ViewController {
    private func classificationCompleteHandler(request: VNRequest, error: Error?) {
        if error != nil {
            print("Error: " + (error?.localizedDescription)!)
            return
        }
        guard let observations = request.results else {
            print("No results")
            return
        }

        let classifications = observations[0...2]
            .compactMap({ $0 as? VNClassificationObservation })
            .map({ "\($0.identifier) \(String(format:" : %.2f", $0.confidence))" })
            .joined(separator: "\n")
        var symbol = "❎"
        DispatchQueue.main.async {
            let topPrediction = classifications.components(separatedBy: "\n")[0]
            let topPredictionName = topPrediction.components(separatedBy: ":")[0].trimmingCharacters(in: .whitespaces)
            let topPredictionScore:Float? = Float(topPrediction.components(separatedBy: ":")[1].trimmingCharacters(in: .whitespaces))
            
            if (topPredictionScore != nil && topPredictionScore! > 0.95 ) {
                //print(topPredictionName)
                //print(topPredictionScore)
                
                if topPredictionName == "fist-UB-RHand" && self.currentGesture != 0 {
                    self.resetTimer()
                    self.currentGesture = 0
                    if(self.currentView==0){
                        let nearestIndex = Int(CGFloat(self.scrollView.contentOffset.x) / self.scrollView.bounds.size.width + 1)
                        let clampedIndex = max( min( nearestIndex, 11 ), 0 )
                        print(clampedIndex)
                        var xOffset = (CGFloat(clampedIndex) * self.scrollView.bounds.size.width)
                        xOffset = xOffset == 0.0 ? 1.0 : xOffset

                        //Tell the scroll view to land on our page
                        if(self.scrollView.contentOffset.x<1100){
                            //self.scrollView.setContentOffset(CGPoint(x:xOffset,y:0.0), animated: true)
                            self.scrollView.setContentOffset(CGPoint(x:self.scrollView.contentOffset.x+100,y:0.0), animated: true)
                        }
                    }
                    else if(self.currentView==1){
                        
                        /*var scrollWidth: CGFloat = self.scrollView1.contentOffset.x +  self.scrollView1.contentSize.width/6
                        if(0.0>scrollWidth){
                            scrollWidth = 0.0
                        }*/
                        let nearestIndex = Int(CGFloat(self.scrollView1.contentOffset.x) / self.scrollView1.bounds.size.width + 1)
                        let clampedIndex = max( min( nearestIndex, 11 - 1 ), 0 )
                        var xOffset = (CGFloat(clampedIndex) * self.scrollView1.bounds.size.width)
                        xOffset = xOffset == 0.0 ? 1.0 : xOffset

                        //Tell the scroll view to land on our page
                        if(self.scrollView1.contentOffset.x<1100){
                            self.scrollView1.setContentOffset(CGPoint(x:self.scrollView1.contentOffset.x+100,y:0.0), animated: true)
                            
                        }
                    }
                        //targetContentOffset.pointee.x = xOffset
                    
                    //self.webView.scrollView.setContentOffset(CGPoint(x: 0.0, y: scrollHeight), animated: true)
                    
                    //self.scrollView.setContentOffset(CGPoint(x: scrollWidth, y: 0.0), animated: true)
                    
                }
                if topPredictionName == "FIVE-UB-RHand" && self.currentGesture != 1 {
                    self.resetTimer()
                    self.currentGesture=1
                    symbol = "🖐"
                    if(self.currentView==0){
                        let currentIndex = floor(self.scrollView.contentOffset.x / self.scrollView.bounds.size.width - 1 )
                        //let offset = CGPoint(x: self.scrollView.bounds.size.width * currentIndex, y: 0)
                        let offset = CGPoint(x: self.scrollView.contentOffset.x-100, y: 0)
                        if(self.scrollView.contentOffset.x>400){
                            self.scrollView.setContentOffset(offset, animated: true)
                            
                        }
                        
                    }
                    else if(self.currentView==1){
                        let currentIndex = floor(self.scrollView1.contentOffset.x / self.scrollView1.bounds.size.width - 1)
                            //let offset = CGPoint(x: self.scrollView1.bounds.size.width * currentIndex, y: 0)
                            let offset = CGPoint(x: self.scrollView1.contentOffset.x-100, y: 0)
                            if(self.scrollView1.contentOffset.x>400){
                                self.scrollView1.setContentOffset(offset, animated: true)
                                
                            }
                            
                    }
                }
                else {
                    self.currentGesture=2
                    if(self.timerActive==0 && self.currentView != -1){self.startTimer()}
                }
                
            }
            if(self.timerActive==0 && self.currentView != -1){self.startTimer()}
            //NSInteger pagenumber = scrollView.contentOffset.x / scrollView.bounds.size.width;
            
            let pageNumber = self.scrollView.contentOffset.x/self.scrollView.bounds.size.width;
            if pageNumber.isNaN == false && pageNumber.isInfinite==false {
                if(self.currentView == 0){
                    let _:CGFloat = self.scrollView.bounds.size.width;
                    var index:Int = Int(ceil((self.scrollView.contentOffset.x)/120))// + (0.5 * width)) / width);
                    if(index<0){
                        index=0;
                    }
                    if(index>11){
                        index=11
                    }
                    if index != self.currentButton {
                        var btn = self.stackView.arrangedSubviews[index] as? UIButton
                        btn?.isHighlighted = true
                        btn?.imageEdgeInsets =  UIEdgeInsets(top:5, left: 5, bottom: 5, right: 5)
                        btn?.layer.borderWidth = 2.0;
                        btn?.layer.borderColor = UIColor.white.cgColor
                        if (self.currentButton != -1){
                            btn = self.stackView.arrangedSubviews[self.currentButton] as? UIButton
                            btn?.isHighlighted = false
                            btn?.imageEdgeInsets =  UIEdgeInsets(top: 15, left: 5, bottom: 15, right: 5)
                            btn?.layer.borderWidth = 0.0
                            
                        }
                        self.currentButton = index
                    }
                }
                else if(self.currentView==1){
                    let _:CGFloat = self.scrollView1.bounds.size.width;
                    var index:Int = Int(ceil((self.scrollView1.contentOffset.x)/120))
                    if(index<0){
                        index=0;
                    }
                    if(index>11){
                        index=11
                    }
                    if index != self.currentButton {
                        var btn = self.stackView1.arrangedSubviews[index] as? UIButton
                        btn?.isHighlighted = true
                        btn?.imageEdgeInsets =  UIEdgeInsets(top:5, left: 5, bottom: 5, right: 5)
                        btn?.layer.borderWidth = 2.0;
                        btn?.layer.borderColor = UIColor.white.cgColor
                        if (self.currentButton != -1){
                            btn = self.stackView1.arrangedSubviews[self.currentButton] as? UIButton
                            btn?.isHighlighted = false
                            btn?.imageEdgeInsets =  UIEdgeInsets(top: 15, left: 5, bottom: 15, right: 5)
                            btn?.layer.borderWidth = 0.0
                            
                        }
                        self.currentButton = index
                    }
                }
            }
            
        }
        
    }
    
}
