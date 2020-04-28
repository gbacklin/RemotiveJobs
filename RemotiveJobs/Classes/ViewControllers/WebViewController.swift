//
//  WebViewController.swift
//  RemotiveJobs
//
//  Created by Gene Backlin on 4/27/20.
//  Copyright © 2020 Gene Backlin. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    @IBOutlet weak var forwardBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var backBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var wkWebView: WKWebView!
    var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let myURL = URL(string: url!)
        let myRequest = URLRequest(url: myURL!)
        wkWebView.load(myRequest)

        //wkWebView.load(URLRequest(url: URL(string: url!)!))
        wkWebView.navigationDelegate = self
        wkWebView.allowsBackForwardNavigationGestures = true
    }
    
    @IBAction func goForward(_ sender: Any) {
    }
    @IBAction func goBack(_ sender: Any) {
    }
}

// MARK: - WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        debugPrint("didStartProvisionalNavigation")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        debugPrint("didFinish")
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        guard (error as NSError).code != URLError.cancelled.rawValue else { return }

        let msg = "\(error.localizedDescription) - Code: \((error as NSError).code)"
        debugPrint("didFailProvisionalNavigation: \(msg)")
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        debugPrint("decidePolicyFor navigationAction")
        decisionHandler(.allow)
    }
}
