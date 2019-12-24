//
//  MainFunctionViewController.swift
//  Virtual Tourist 1.3
//
//  Created by Muath Mohammed on 24/04/1441 AH.
//  Copyright © 1441 MuathMohammed. All rights reserved.
//

import UIKit

class MainFunctionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func showAlert(firstTitle :String,body :String,secondTitle :String)
    {
           //"Values must not be empty"
           let alert = UIAlertController(title: firstTitle, message: body , preferredStyle:UIAlertController.Style.alert)
           alert.addAction(UIAlertAction(title: secondTitle, style: UIAlertAction.Style.default, handler: nil))
           self.present(alert, animated: true, completion: nil)

    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
