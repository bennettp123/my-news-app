//
//  ViewController.swift
//  my-news-app
//
//  Created by Bennett Perkins on 26/5/2022.
//

import SafariServices
import UIKit

class ViewController: UIViewController, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let url = URL(string: "https://thewest.com.au") else {
            return
        }

        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
        vc.delegate = self
    }

    @IBAction func openURL(_ sender: Any) {
        
    }
    
    func safariViewControllerDidFinish(
        _ controller: SFSafariViewController
    ) {
        controller.dismiss(animated: true, completion: nil)
    }
}

