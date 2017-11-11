//
// Created by J1aDong on 2017/10/25.
// Copyright (c) 2017 J1aDong. All rights reserved.
//

import Foundation

class Book {

    var title: String
    var summary: String
    var starCount: String
    var id: String
    var author: String
    var epubUrl: String

    init(aTitle: String, aSummary: String, aStarCount: String, anId: String, anAuthor: String, anEpubUrl: String) {
        self.title = aTitle
        self.summary = aSummary
        self.starCount = aStarCount
        self.id = anId
        self.author = anAuthor
        self.epubUrl = anEpubUrl
    }
}
