//
//  ViewController.swift
//  Instagrid V3
//
//  Created by ISABELLE Terwagne on 03/02/2019.
//  Copyright © 2019 ISABELLE Terwagne. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIApplicationDelegate {
    
    // add tapGesture and swipeGesture on the grid
    @IBOutlet weak var selectedView: SelectedView!
    
    @IBOutlet var swipeUp: UISwipeGestureRecognizer!
    
    @IBOutlet var swipeLeft: UISwipeGestureRecognizer!
    
    @IBOutlet weak var leftTop: UIImageView!
    
    @IBOutlet weak var rightTop: UIImageView!
    
    @IBOutlet weak var leftBottom: UIImageView!
    
    @IBOutlet weak var rightBottom: UIImageView!
    
    // methode for swipeGesture
    @IBAction func swipeOrientation(_ sender: UISwipeGestureRecognizer) {
        if (UIDevice.current.orientation.isLandscape  && sender.direction == .left) || (UIDevice.current.orientation.isPortrait && sender.direction == .up) {
            shareScreenShot()
        }
    }
//   methode for tapGesture
    fileprivate func setupTapGestureRecogniser() {
        leftTop.isUserInteractionEnabled = true
        leftTop.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(insertPhoto)))
        
        rightTop.isUserInteractionEnabled = true
        rightTop.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(insertPhoto)))
        
        leftBottom.isUserInteractionEnabled = true
        leftBottom.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(insertPhoto)))
        
        rightBottom.isUserInteractionEnabled = true
        rightBottom.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(insertPhoto)))
    }
    
    //  proprietes
    let pickerController = UIImagePickerController()
    var selectedImage: UIImageView?
    var screenshot: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedView.backgroundColor = #colorLiteral(red: 0.06274509804, green: 0.4, blue: 0.5960784314, alpha: 1)
        selectedView.style = .secondView
        setupTapGestureRecogniser()
        selectedView.isUserInteractionEnabled = true
        
    }
    //    change Text label for orientation
    @IBOutlet weak var swipeLabel: UILabel!
    override func viewWillLayoutSubviews() {
        let orientation = UIDevice.current.orientation
        switch orientation {
        case .landscapeLeft:
            swipeLabel.text = "Swipe left to share"
        case .portrait:
            swipeLabel.text = "Swipe up to share"
        default :
            break
        }
    }
    // methodes to access to photo libray
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage: UIImage = (info[.originalImage] as! UIImage)
        self.selectedImage?.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func insertPhoto(_ sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        if sender.state != .ended { return }
        selectedImage = sender.view as? UIImageView
        selectedImage!.contentMode = .scaleToFill
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // present the selected Grid
    
    @IBOutlet weak var view1: UIButton!
    
    @IBOutlet weak var view2: UIButton!
    
    @IBOutlet weak var view3: UIButton!
    
    @IBAction func choiceView1(_ sender: UIButton) {
        view1.isSelected = true
        view2.isSelected = false
        view3.isSelected = false
        view1.image(for: .selected)
        selectedView.style = .firstView
    }
    
    @IBAction func choiceView2(_ sender: UIButton) {
        view1.isSelected = false
        view2.isSelected = true
        view3.isSelected = false
        view2.image(for: .selected)
        selectedView.style = .secondView
    }
    
    @IBAction func choiceView3(_ sender: UIButton){
        view1.isSelected = false
        view2.isSelected = false
        view3.isSelected = true
        view3.image(for: .selected)
        selectedView.style = .thirdView
    }
    
    //  methode for share the photo montage
    func shareScreenShot(){
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let ac = UIActivityViewController(activityItems: [screenshot!], applicationActivities: nil)
        present(ac, animated: true, completion: nil)
        if UIDevice.current.orientation.isPortrait {
            self.moveViewVertically()
            ac.completionWithItemsHandler = { (UIActivityType: UIActivity.ActivityType?, completed: Bool, returnItems: [Any]?, error: Error?) in
                if !completed {
                    self.moveViewToCenter()
                }
                if completed {
                    self.moveViewToCenter()
                }
            }
        }else if UIDevice.current.orientation.isLandscape {
            self.moveViewHorizontally()
            
            ac.completionWithItemsHandler = { (UIActivityType: UIActivity.ActivityType?, completed: Bool, returnItems: [Any]?, error: Error?) in
                if !completed {
                    self.moveViewToCenter()
                }
                if completed {
                    self.moveViewToCenter()
                }
            }
        }
    }
    
    // methode to move the grid when sharing - animated View
    func moveViewVertically () {
        let screenHeight = UIScreen.main.bounds.height
        UIView.animate(withDuration: 1, animations: {
            self.selectedView.transform = CGAffineTransform(translationX: 0, y: -screenHeight)
        }, completion: nil)
    }
    
    func moveViewHorizontally() {
        let screenLeft = UIScreen.main.bounds.width
        UIView.animate(withDuration: 1, animations: {
            self.selectedView.transform = CGAffineTransform(translationX: -screenLeft, y: 0)
        }, completion: nil)
    }
    
    func moveViewToCenter () {
        UIView.animate(withDuration: 0.5, animations: {
            self.selectedView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    // Bonus : Change the color of the backgroung
    @IBOutlet weak var buttonChangeColor: UIButton!
    @IBAction func bacgroundColor(_ sender: UIButton) {
        sender.tag += 1
        if sender.tag > 3 { sender.tag = 0}
        switch sender.tag {
        case 1:
            selectedView.backgroundColor? = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        case 2:
            selectedView.backgroundColor? = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        case 3:
            selectedView.backgroundColor? = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        default:
            selectedView.backgroundColor = #colorLiteral(red: 0.06274509804, green: 0.4, blue: 0.5960784314, alpha: 1)
        }
    }
}
