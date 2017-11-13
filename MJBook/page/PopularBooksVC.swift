//
//  PopularBooksVC.swift
//  MJBook
//
//  Created by J1aDong on 2017/10/25.
//  Copyright © 2017年 J1aDong. All rights reserved.
//

import UIKit
import Alamofire
import Fuzi
import RxSwift
import MJRefresh

class PopularBooksVC: UITableViewController {

    private var books = [Book]()

    private var idx = -1
    
    private var mPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadHTML(isRefresh: true)
        })
        
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.loadHTML(isRefresh: false)
        })
        
        self.tableView.mj_header.beginRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func loadHTML(isRefresh:Bool) {
        if isRefresh {
            mPage = 0
            books.removeAll()
        }
        _ = MyHttpClient().send(NetApi.getExplore(page: mPage)).subscribe { (x) in
            let result = x.element!["result"]
            self.mPage += 1
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            self.parseHTML(result as! String)
            print("books cout:\(self.books.count)")
            self.tableView.reloadData()
        }
    }

    private func parseHTML(_ html: String) {
        do {
            let doc = try HTMLDocument(string: html)

            let elements = doc.css(".Book")

            for element in  elements{
                let book = ParseUtil.parse(book: element)
                books.append(book)
            }
        } catch let error{
            print(error)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"BookCell", for: indexPath) as! BookCell

        cell.book = books[indexPath.row]

        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idx = indexPath.row
        performSegue(withIdentifier: "BookDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let bookDetailController = segue.destination as! BookDetailVC
        bookDetailController.book = books[idx]
    }
}
