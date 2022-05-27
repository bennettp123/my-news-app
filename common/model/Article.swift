//
//  Article.swift
//  my-news-app
//
//  Created by Bennett Perkins on 27/5/2022.
//

import Foundation

struct Article: Identifiable, Codable {
    var id: String
    var title: String
    var intro: String
    var source: URL
    var previewImage: URL
}
