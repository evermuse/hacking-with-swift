//
//  DetailViewController.swift
//  Whitehouse Petitions
//
//  Created by Bryan Alexander on 11/14/16.
//  Copyright © 2016 Sarva. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var webView: WKWebView!
    var detailItem: [String: String]!
    
    override func loadView() {
        
        webView = WKWebView()
        view = webView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guard detailItem != nil else { return }
        
        if let body = detailItem["body"] {  // custom HTML to display the data
            
            var html = "<html>"
            html += "<head>"
            html += "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">"
            html += "<style> body { font-size: 150%; } </style>"
            html += "</head>"
            html += "<body>"
            html += body
            html += "</body>"
            html += "</html>"
            webView.loadHTMLString(html, baseURL: nil)
            
        }
        
    }

}
