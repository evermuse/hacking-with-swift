//
//  ViewController.swift
//  Easy Browser
//
//  Created by Bryan Alexander on 11/12/16.
//  Copyright © 2016 Sarva. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["apple.com", "hackingwithswift.com"]
    
    override func loadView() {
        
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let url = URL(string: "https:" + websites[0])!
        webView.load(URLRequest(url:url))
        webView.allowsBackForwardNavigationGestures = true
        
        // key-value observer to show progress of webpage load
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
            
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        // adds progress view button inside special UIBarButtonITem
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        toolbarItems = [progressButton, spacer, refresh] // all view controllers come with a toolbarItems array that automatically gets read in when the view controller is active
        navigationController?.isToolbarHidden = false
        
    }
    
    func openTapped() {
        
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        
        // original code
        // ac.addAction(UIAlertAction(title: "apple.com", style: .default, handler: openPage))
        // ac.addAction(UIAlertAction(title: "hackingwithswift.com", style: .default, handler: openPage))
        
        // refactored loop code
        
        for website in websites {
            
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
            
        }
    
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac,animated: true)
        
    }
    
    func openPage(action: UIAlertAction!) {
        
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url:url))
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        title = webView.title
        
    }
    
    // function to tell when an observed value has changed
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress" {
            
            progressView.progress = Float(webView.estimatedProgress)
            
        }
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url = navigationAction.request.url // makes code clearer
        
        if let host = url!.host {  // unwraps the website domain carefully because not all URLs have hosts
            
            for website in websites {  // we loop through all sites in our safe list placing the name of the site in website var
                
                if host.range(of: website) != nil { // string method to see whether each safe website exists somewhere in host
                                                    // if website was not nil we call the decisionHandler with + response to allow loading and return if found
                    decisionHandler(.allow)
                    return
                    
                }
            }
        }
        
        decisionHandler(.cancel)                    // if nothing found we call decisionHandler with - response and cancel
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

