//
// Created by J1aDong on 2017/10/25.
// Copyright (c) 2017 J1aDong. All rights reserved.
//

import Foundation
import Fuzi

struct ParseUtil {
    static func parse(book element: XMLElement) -> Book {
        let linkElement = element.css("a, link")
        let bookAdd = (linkElement.first?.attributes["href"]) ?? ""

        let bookArr = bookAdd.components(separatedBy: "/")


        let author = bookArr[bookArr.endIndex - 2 ]
        let downloadUrl = author + "/" + bookArr.last!

        let bookTitle = element.css("a, href")[0].stringValue
        let bookStar = element.css("a, href")[2].stringValue
        let starCount = bookStar.trimmingCharacters(in: .whitespacesAndNewlines)
        let summaryString = element.css(".description").first?.stringValue ?? ""
        let bookSummary = summaryString.trimmingCharacters(in: .whitespacesAndNewlines)


        let book = Book(aTitle: bookTitle, aSummary: bookSummary, aStarCount: starCount, anId: bookAdd, anAuthor: author, anEpubUrl: downloadUrl)
        return book
    }
}
