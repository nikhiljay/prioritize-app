//
//  AboutUsWebViewController.swift
//  Prioritize
//
//  Created by Nikhil D'Souza on 2/25/15.
//  Copyright (c) 2015 Nikhil D'Souza. All rights reserved.
//

import UIKit
import WebKit

class AboutUsWebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {

    //var webView: WKWebView
    @IBOutlet weak var barView: UIView!
//    @IBOutlet weak var backButton: UIBarButtonItem!
//    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    //@IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webView: UIWebView!
    
    var url: NSURL!
    
    required init(coder aDecoder: NSCoder) {
        //self.webView = WKWebView(frame: CGRect(x: 0, y: 20, width: 320, height: 568))
        super.init(coder: aDecoder)
        
        //self.webView.navigationDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        barView.frame = CGRect(x:0, y: 0, width: view.frame.width, height: 30)
        
        //view.insertSubview(webView, belowSubview: progressView)
        
//        webView.setTranslatesAutoresizingMaskIntoConstraints(false)
//        let height = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: -44)
//        let width = NSLayoutConstraint(item: webView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
//        view.addConstraints([height, width])
        
        webView.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        //webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        
        let webViewURL = NSURL(string:"http://www.nikhiljay.com")
        url = webViewURL
        let request = NSURLRequest(URL:webViewURL!)
        webView.loadRequest(request)
        
//        backButton.enabled = false
//        forwardButton.enabled = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        barView.frame = CGRect(x:0, y: 0, width: size.width, height: 30)
    }
    
    @IBAction func back(sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    @IBAction func forward(sender: UIBarButtonItem) {
        webView.goForward()
    }
    
    @IBAction func reload(sender: UIBarButtonItem) {
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
    }
    
//    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<()>) {
//        if (keyPath == "loading") {
////            backButton.enabled = webView.canGoBack
////            forwardButton.enabled = webView.canGoForward
//        }
//        if (keyPath == "estimatedProgress") {
//            progressView.hidden = webView.loading == true
//            progressView.setProgress(Float(webView.loading), animated: true)
//        }
//    }
    
    func webView(webView: WKWebView!, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError!) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
//    func webView(webView: WKWebView!, didFinishNavigation navigation: WKNavigation!) {
//        progressView.setProgress(0.0, animated: false)
//    }

}
