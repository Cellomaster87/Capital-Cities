//
//  DetailViewController.swift
//  Capital Cities
//
//  Created by Michele Galvagno on 11/04/2019.
//  Copyright © 2019 Michele Galvagno. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate {
    // MARK: - Properties
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websiteToLoad: String?
    
    var websites = ["wikipedia.org"]
    
    // MARK: - Views Management
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [progressButton]
        navigationController?.isToolbarHidden = false
        
        // KVO Setup
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        // Navigation management
        let url = URL(string: "https://" + websiteToLoad!)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    /*
    // Decide whether the navigation is allowed or not.
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    
                    return
                }
            }
        }
        
        let alertController = UIAlertController(title: "WARNING!", message: "This website is blocked!", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
        decisionHandler(.cancel)
    }
    */
}
