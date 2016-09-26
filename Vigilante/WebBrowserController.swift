//
//  WebBrowserController.swift
//  CityEye
//
//  Created by Gerardo Israel Monteverde on 9/26/16.
//  Copyright © 2016 Gerardo Israel Monteverde. All rights reserved.
//

import UIKit

class WebBrowserController: UIViewController, UIWebViewDelegate  {
    
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet var progressView: UIProgressView!
    var hasFinishedLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        
        let url = NSURL(string: "https://www.bottlerocketstudios.com/")
        let request = NSURLRequest(URL: url!)
        self.webView.loadRequest(request)
        
    }
    
    @IBAction func goBack(sender: AnyObject) {
        self.webView.goBack()
        updateProgress()
    }
    
    @IBAction func reload(sender: AnyObject) {
        self.webView.reload()
        updateProgress()
    }
    
    
    @IBAction func goNext(sender: AnyObject) {
        self.webView.goForward()
        updateProgress()
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        _ = false
        updateProgress()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))),
                       dispatch_get_main_queue()) {
                        [weak self] in
                        if let _self = self {
                            _self.hasFinishedLoading = true
                        }
        }
    }
    
    deinit {
        webView.stopLoading()
        webView.delegate = nil
    }
    
    func updateProgress(){
        if progressView.progress >= 1 {
            progressView.hidden = true
        } else {
            if hasFinishedLoading {
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
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.008 * Double(NSEC_PER_SEC))),
                           dispatch_get_main_queue()) {
                            [weak self] in
                            if let _self = self {
                                _self.updateProgress()
                            }
            }
        }
    }
    
    
}
