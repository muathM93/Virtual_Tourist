//
//  ImageCollecationView.swift
//  Virtual Tourist 1.3
//
//  Created by Muath Mohammed on 17/04/1441 AH.
//  Copyright © 1441 MuathMohammed. All rights reserved.
//

import Foundation
import UIKit

class ImageCollecationView: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    func setupimage(url:String) {
           
           DispatchQueue.main.async {
               do{
                   let appurl = URL(string: url)!
                   let data=try Data(contentsOf: appurl )
                   DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)

                  }
               }
               catch{
                   
              print("problem eith cell setupimage method ")
               }
           }
       }
    
    
}
