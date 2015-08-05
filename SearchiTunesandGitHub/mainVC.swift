//
//  ViewController.swift
//  SearchiTunesandGitHub
//
//  Created by Dmitry Kuzin on 05.08.15.
//  Copyright (c) 2015 Dmitry Kuzin. All rights reserved.
//

import UIKit

class mainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, APIProtocol, APIGITHUBProtocol {
//задаются переменные
    @IBOutlet weak var mytableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var segmentedSearch: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
//определяется название для ячеек таблицы
    var CellIdentifier: String = "Result"
//подключаем API
    var api: API = API()
    var apiGITHUB: APIGITHUB = APIGITHUB()
//создаем массивы для хранения данных
    var tableData: NSArray = NSArray()
    var tableDataGit: NSArray = NSArray()

//функция после нажатия кнопки "Найти"
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//проверка на выбранный поиск iTunes или GitHub
        if segmentedSearch.selectedSegmentIndex == 0 {
            api.delegate = self
//включаем индикаторы активности
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
//передаем данные в API для обработки введенных данных
            api.searchItunesFor(searchBar.text!);
        }
        if segmentedSearch.selectedSegmentIndex == 1 {
            apiGITHUB.delegate = self
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
            apiGITHUB.searchGithubFor(searchBar.text);
        }
//скрываем клавиатуру после оправки запроса
        self.view.endEditing(true)

    }
//устанавливаем высоту ячеек
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
    var returnper: NSArray = NSArray()
    //задаем количество ячеек, в зависимости от полученных данных. Также разделяются на iTunes и GitHub
    if segmentedSearch.selectedSegmentIndex == 0 {
    returnper = tableData
    } else {
    returnper = tableDataGit
    }
    return returnper.count
}

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ResultCell = mytableView.dequeueReusableCellWithIdentifier("Result") as! ResultCell
        
        //проверяем четные и нечетные данные для корректного выведения
        var restit = indexPath.row % 2
        if restit == 0 {
        if segmentedSearch.selectedSegmentIndex == 0 {
            
            var rowData: NSDictionary = self.tableData[indexPath.row] as! NSDictionary
            cell.changeforSecond()
            //устанавливаем название найденного результата
            let cellText: String? = rowData["trackName"] as? String
            cell.titleleft.text = cellText
            // устанавливаем изображение
            var urlString: NSString = rowData["artworkUrl60"] as! NSString
            if let url = NSURL(string: urlString as String) {
                if let data = NSData(contentsOfURL: url){
                    cell.imgleft.contentMode = UIViewContentMode.ScaleAspectFit
                    cell.imgleft.image = UIImage(data: data)
                }
            }
            // устанавливаем цену
            var formattedPrice: NSString = rowData["formattedPrice"] as! NSString
            // устанавливаем разработчика
            var developer: NSString = rowData["artistName"] as! NSString
            
            cell.priceleft.text = formattedPrice as String
            cell.developerleft.text = developer as String
        
        } else {
            
            var rowData: NSDictionary = self.tableDataGit[indexPath.row] as! NSDictionary
            cell.changeforSecond()
            //устанавливаем название найденного результата
            let cellText: String? = rowData["login"] as? String
            cell.titleleft.text = cellText
            // устанавливаем изображение
            var urlString: NSString = rowData["avatar_url"] as! NSString
            if let url = NSURL(string: urlString as String) {
                if let data = NSData(contentsOfURL: url){
                    cell.imgleft.contentMode = UIViewContentMode.ScaleAspectFit
                    cell.imgleft.image = UIImage(data: data)
                }
            }
            // устанавливаем цену
            //var formattedPrice: NSString = rowData["formattedPrice"] as! NSString
            // устанавливаем разработчика
            var developer: NSString = rowData["url"] as! NSString
            
            cell.priceleft.text = ""
            cell.developerleft.text = developer as String
        
        
        
        }
        }
        else {
            if segmentedSearch.selectedSegmentIndex == 0 {
                
                var rowData: NSDictionary = self.tableData[indexPath.row] as! NSDictionary
                cell.changeForFirst()
                //устанавливаем название найденного результата
                let cellText: String? = rowData["trackName"] as? String
                cell.titleright.text = cellText
                // устанавливаем изображение
                var urlString: NSString = rowData["artworkUrl60"] as! NSString
                if let url = NSURL(string: urlString as String) {
                    if let data = NSData(contentsOfURL: url){
                        cell.imgright.contentMode = UIViewContentMode.ScaleAspectFit
                        cell.imgright.image = UIImage(data: data)
                    }
                }
                // устанавливаем цену
                var formattedPrice: NSString = rowData["formattedPrice"] as! NSString
                // устанавливаем разработчика
                var developer: NSString = rowData["artistName"] as! NSString
                
                cell.priceright.text = formattedPrice as String
                cell.developerright.text = developer as String
            
            } else {
                var rowData: NSDictionary = self.tableDataGit[indexPath.row] as! NSDictionary
                cell.changeForFirst()
                //устанавливаем название найденного результата
                let cellText: String? = rowData["login"] as? String
                cell.titleright.text = cellText
                // устанавливаем изображение
                var urlString: NSString = rowData["avatar_url"] as! NSString
                if let url = NSURL(string: urlString as String) {
                    if let data = NSData(contentsOfURL: url){
                        cell.imgright.contentMode = UIViewContentMode.ScaleAspectFit
                        cell.imgright.image = UIImage(data: data)
                    }
                }
                // устанавливаем цену
                //var formattedPrice: NSString = rowData["formattedPrice"] as! NSString
                // устанавливаем разработчика
                var developer: NSString = rowData["url"] as! NSString
                
                cell.priceright.text = ""
                cell.developerright.text = developer as String
                
            
            }
            
            
        
        }
        
    return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//при запуске программы скрыаем индикатор активности
  activityIndicator.hidden = true
    }

//функция протокола
    func didRecieveAPIResults(results: NSDictionary) {
//проверка запросов для данных из iTunes
        if results.count>0 {
//ввод полученных данных в таблицу
            self.tableData = results["results"] as! NSArray
            self.mytableView.reloadData()
//скрываем индикаторы активности
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            activityIndicator.stopAnimating()
            activityIndicator.hidden = true
        }
        //проверяем есть ли результаты по запросу, если нет то выводим сообщение
        if results.count == 0  {
        let alertMessage = UIAlertController(title: "Ничего не найдено", message: "Попробуйте изменить запрос", preferredStyle: .Alert)
        
        alertMessage.addAction(UIAlertAction(title: "ОК", style: .Default, handler: nil))
        self.presentViewController(alertMessage, animated: true, completion: nil)
        }
    }
    

    func didRecieveAPIResultsGITHUB(resultsGITHUB: NSDictionary) {
        if resultsGITHUB.count>0 {
            self.tableDataGit = resultsGITHUB["items"] as! NSArray
            self.mytableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            activityIndicator.stopAnimating()
            activityIndicator.hidden = true
        }
        if resultsGITHUB.count == 0  {
            let alertMessage = UIAlertController(title: "Ничего не найдено", message: "Попробуйте изменить запрос", preferredStyle: .Alert)
            
            alertMessage.addAction(UIAlertAction(title: "ОК", style: .Default, handler: nil))
            self.presentViewController(alertMessage, animated: true, completion: nil)
        }

    }
}

