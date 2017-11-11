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

class PopularBooksVC: UITableViewController {

    private var books = [Book]()

    private var idx = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadHTML()
    }

    private func loadHTML() {
        Alamofire.request("https://www.gitbook.com/explore?page=4").responseString { (response) in
            guard response.result.error == nil else {
                print(response.result.error?.localizedDescription ?? "error happens")
                return
            }
            print("Response:\(String(describing: response.result.value))")
            self.parseHTML(response.result.value!)
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

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idx = indexPath.row
    }
}
