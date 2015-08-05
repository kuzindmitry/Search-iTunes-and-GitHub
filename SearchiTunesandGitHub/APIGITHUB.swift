//
//  APIGITHUB.swift
//  SearchiTunesandGitHub
//
//  Created by Dmitry Kuzin on 05.08.15.
//  Copyright (c) 2015 Dmitry Kuzin. All rights reserved.
//


import UIKit

protocol APIGITHUBProtocol {
    func didRecieveAPIResultsGITHUB(resultsGITHUB: NSDictionary)
}

class APIGITHUB: NSObject {
    
    var delegate: APIGITHUBProtocol?
    var data: NSMutableData = NSMutableData()
    
    func searchGithubFor(searchTerm: String) {
        
        var itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        var escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var urlPath = "https://api.github.com/search/users?q=\(escapedSearchTerm!)"
        var url: NSURL = NSURL(string: urlPath)!
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
        
        println("Поиск в GitHub по ссылке: \(url)")
        
        connection.start()
    }
    
    func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
        println("Связь потеряна.\(error.localizedDescription)")
    }
    
    func connection(connection: NSURLConnection, didRecieveResponse response: NSURLResponse)  {
        println("Ответ получен")
    }
    
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        self.data = NSMutableData()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        self.data.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        var dataAsString: NSString = NSString(data: self.data, encoding: NSUTF8StringEncoding)!
        
        var err: NSError
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
        
        delegate?.didRecieveAPIResultsGITHUB(jsonResult)
        
    }
}