//
//  AboutUsWebViewController.swift
//  Prioritize
//
//  Created by Nikhil D'Souza on 2/25/15.
//  Copyright (c) 2015 Nikhil D'Souza. All rights reserved.
//

import UIKit
import WebKit

class AboutUsWebViewController: UIViewController, UIWebViewDelegate {

    //var webView: WKWebView
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var progressView: UIProgressView!
    private var hasFinishLoading = false
    var shareTitle : String?
    var url: NSURL = NSURL(string: "http://nikhiljay.com")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
        webView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shareButtonPressed(sender: AnyObject) {
        let shareString = self.shareTitle ?? ""
        let shareURL = self.url
        let activityViewController = UIActivityViewController(activityItems: ["Look at Nikhil D'Souza's website at:", shareURL], applicationActivities: nil)
        activityViewController.setValue(shareString, forKey: "subject")
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        hasFinishLoading = false
        updateProgress()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        shareTitle = webView.stringByEvaluatingJavaScriptFromString("document.title");
        delay(1) { [weak self] in
            if let _self = self {
                _self.hasFinishLoading = true
            }
        }
    }
    
    func updateProgress() {
        if progressView.progress >= 1 {
            progressView.hidden = true
        } else {
            
            if hasFinishLoading {
                progressView.progress += 0.002
            } else {
                if progressView.progress <= 0.3 {
                    progressView.progress += 0.004
                } else if progressView.progress <= 0.6 {
                    progressView.progress += 0.002
                } else if progressView.progress <= 0.9 {
                    progressView.progress += 0.001
                } else if progressView.progress <= 0.94 {
                    progressView.progress += 0.0001
                } else {
                    progressView.progress = 0.9401
                }
            }
            
            delay(0.008) { [weak self] in
                if let _self = self {
                    _self.updateProgress()
                }
            }
        }
    }
    
    deinit {
        webView.stopLoading()
        webView.delegate = nil
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
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
