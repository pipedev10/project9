//
//  DetailViewController.swift
//  project-7
//
//  Created by Pipe Carrasco on 24-08-21.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailItem = detailItem else {
            return
        }
        
        let html = """
            <html>
            <head>
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <style> body
               {
                 font-size: 150%;
               }
               .text{
                  background-color: green;
               }
            </style>
            </head>
            <body>
            <p class="text">
                \(detailItem.body)
            </p>
            </body>
            </html>
        """
        webView.loadHTMLString(html, baseURL: nil)
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
