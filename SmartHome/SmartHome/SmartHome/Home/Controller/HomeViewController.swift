//
//  HomeViewController.swift
//  SmartHome
//
//  Created by 浩哲 夏 on 2018/1/2.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
import LocalAuthentication
fileprivate let margin: CGFloat = 10
fileprivate let cols = 2
fileprivate let controlCell = "controlCell"

class HomeViewController: UIViewController {
    
    enum CONTROL:Int {
        case TEMP = 0
        case LUZ = 1
        case WATER = 2
        case PUERTA = 3
    }
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var cardView: SwipeableCards!
    fileprivate var time: Timer?
    fileprivate var errorCount: Int = 0
    
    
    let controlImages = [#imageLiteral(resourceName: "Temp"),#imageLiteral(resourceName: "Luz"),#imageLiteral(resourceName: "water"),#imageLiteral(resourceName: "Door")]
    let controlTitle = ["Temperatura Y Light","Luz","Water","Puerta"]
    
    
    lazy var collection: UICollectionView = {
        let itemWidth = (self.controlView.frame.width / CGFloat(cols)) - (margin * CGFloat(cols))
        /*
         FlowLayout
         */
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width:itemWidth, height: self.controlView.frame.height - margin)
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.scrollDirection = .horizontal
        
        /*
         CollectionView
         */
        let collectionView: UICollectionView = UICollectionView(frame: self.controlView.bounds, collectionViewLayout: flowLayout)
        collectionView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        collectionView.backgroundColor = normalBgColor
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: "ControlCell", bundle: nil), forCellWithReuseIdentifier:controlCell )
        return collectionView
    }()
    
    fileprivate var previousCell: ControlCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = normalBgColor
        iconImage.layer.cornerRadius = iconImage.frame.width / 2
        iconImage.layer.masksToBounds = true
        cardView.delegate = self
        cardView.dataSource = self
        cardView.offset = (5,5)
        controlView.addSubview(collection)
        funcId()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


// MARK: - CardView For Camare
extension HomeViewController:SwipeableCardsDelegate,SwipeableCardsDataSource{
    func numberOfTotalCards(in cards: SwipeableCards) -> Int {
        return 3
    }
    
    func view(for cards: SwipeableCards, index: Int, reusingView: UIView?) -> UIView {
        if index == 0 {
            let imageview = UIImageView(frame: self.cardView.bounds)
            imageview.image = #imageLiteral(resourceName: "salon")
            return imageview
        }else if index == 1{
            let imageview = UIImageView(frame: self.cardView.bounds)
            imageview.image = #imageLiteral(resourceName: "home")
            return imageview
        }else{
            let imageview = UIImageView(frame: self.cardView.bounds)
            imageview.image = #imageLiteral(resourceName: "planta1")
            return imageview
        }
    }
    
}


extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controlTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: controlCell, for: indexPath) as! ControlCell
        
        cell.controlImage.image = controlImages[indexPath.row]
        cell.controlTitle.text = controlTitle[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let previous = previousCell {
            previous.baseView.backgroundColor = normalBgColor
        }
        let cell = collectionView.cellForItem(at: indexPath) as! ControlCell
        cell.baseView.backgroundColor = selectBgColor
        previousCell = cell
        
        if cell.controlTitle.text == controlTitle[CONTROL.TEMP.rawValue] {
            let tempVC = TempYLightController()
            self.navigationController?.pushViewController(tempVC, animated: true)
        }
        if cell.controlTitle.text == controlTitle[CONTROL.LUZ.rawValue]{
            self.navigationController?.pushViewController(LuzViewController(), animated: true)
        }
        if cell.controlTitle.text == controlTitle[CONTROL.WATER.rawValue]{
            self.navigationController?.pushViewController(WaterViewController(), animated: true)
        }
        if cell.controlTitle.text == controlTitle[CONTROL.PUERTA.rawValue]{
            self.navigationController?.pushViewController(DoorViewController(), animated: true)
        }
        
    }
}

extension HomeViewController{
    fileprivate func funcId(){
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Please Verificar Su Huella", reply: { (success, nserror) in
                if success{
                    print("success")
                }else{
                    if let error = nserror as NSError?{
                        let message = self.errorMessageForLAErrorCode(errorCode:error.code)
                        print(message)
                        if self.errorCount > 3{
                            assertionFailure("Your Are SB")
                        }
                        self.funcId()
                        self.errorCount += 1
                    }
                }
            })
        }
        
    }
    
   fileprivate func errorMessageForLAErrorCode(errorCode: Int) -> String {
        var message = ""
        
        switch errorCode {
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.touchIDLockout.rawValue:
            message = "Too many failed attempts."
            assertionFailure("Your Are SB")
            
        case LAError.touchIDNotAvailable.rawValue:
            message = "TouchID is not available on the device"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = "Did not find error code on LAError object"
        }
        return message
    }
    
}
