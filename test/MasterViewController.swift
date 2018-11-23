//
//  ViewController.swift
//  test
//
//  Created by Muhammad Hunble Dhillon on 11/16/18.
//  Copyright © 2018 Arrivy. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {

    @IBOutlet weak var childView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let panGesture = UIPanGestureRecognizer(target: self, action:  #selector(self.handleDrag(recognizer:)))
        
        childView.addGestureRecognizer(panGesture)

        
    }
    @objc func handleDrag(recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        
        childView.center = CGPoint(x: childView.center.x + translation.x, y: childView.center.y + translation.y)

        recognizer.setTranslation(CGPoint.zero, in: self.view)

        if(recognizer.state == UIGestureRecognizer.State.ended){
            
            
            childView.center = self.view.center
            
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }

}

