//
//  DetailsBooks.swift
//  DemoApp
//
//  Created by Nimble Chapps on 01/01/16.
//  Copyright © 2016 Nimble Chapps. All rights reserved.
//

import UIKit

class DetailsBooks: UITableViewController {
    
    var dictAll:NSDictionary?
    
    var arrayBooks = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellnew")
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        if let dic = dictAll,
            dic.allKeys.count > 0 {
            arrayBooks = dic.object(forKey: "BibleBookChapterVerse") as! NSMutableArray
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayBooks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellnew", for: indexPath as IndexPath)
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        let objDic =  arrayBooks.object(at: indexPath.row) as AnyObject
        let text = objDic.object(forKey:"Text") as AnyObject
        let finalText = text.object(forKey: "text") as? String
        cell.textLabel?.text = finalText ?? "Not getting data"
        
        return cell
    }
    
    


}
