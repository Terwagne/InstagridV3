//
//  SelectedView.swift
//  Instagrid V3
//
//  Created by ISABELLE Terwagne on 03/02/2019.
//  Copyright © 2019 ISABELLE Terwagne. All rights reserved.
//

import UIKit

class SelectedView: UIView {
    
    // MARK   emum  to manage the grid
    enum Style {
        case firstView, secondView, thirdView
    }
    var style:Style = .secondView {
        didSet {
            setStyle(style)
        }
    }
    
    // MARK Methode
    private func setStyle(_ style: Style){
        switch style {
        case .firstView:
            leftTop.isHidden = false
            rightTop.isHidden = true
            leftBottom.isHidden = false
            rightBottom.isHidden = false
            
        case .secondView:
            leftTop.isHidden = false
            rightTop.isHidden = false
            leftBottom.isHidden = false
            rightBottom.isHidden = false
            
        case .thirdView:
            leftTop.isHidden = false
            rightTop.isHidden = false
            leftBottom.isHidden = false
            rightBottom.isHidden = true
        }
    }
    
    
    @IBOutlet var leftTop : UIImageView!
    @IBOutlet var rightTop: UIImageView!
    @IBOutlet var leftBottom: UIImageView!
    @IBOutlet var rightBottom: UIImageView!
}
