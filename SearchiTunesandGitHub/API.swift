//
//  API.swift
//  SearchiTunesandGitHub
//
//  Created by Dmitry Kuzin on 05.08.15.
//  Copyright (c) 2015 Dmitry Kuzin. All rights reserved.
//

import UIKit

protocol APIProtocol {
    func didRecieveAPIResults(results: NSDictionary)
}

class API: NSObject {
    
    var delegate: APIProtocol?
    var data: NSMutableData = NSMutableData()
    
    func searchItunesFor(searchTerm: String) {
        //В iTunes API пробел обозначается "+", соответственно необходимо заменить пробелы на необходимый знак
        var itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        // формирование ссылки с введенным запросом
        var escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var urlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm!)&media=software"
        var url: NSURL = NSURL(string: urlPath)!
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
        
        println("Поиск в Itunes по ссылке: \(url)")
        
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
        // перевод в тип NSString
        var dataAsString: NSString = NSString(data: self.data, encoding: NSUTF8StringEncoding)!
        
        // получение необходимых данных из JSON файла
        var err: NSError
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
        
        //Передаем полученные данные
        delegate?.didRecieveAPIResults(jsonResult)
        
    }
}