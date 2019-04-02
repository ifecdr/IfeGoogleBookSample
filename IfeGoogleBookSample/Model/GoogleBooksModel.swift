//
//  GoogleBookModel.swift
//  IfeGoogleBookSample
//
//  Created by MAC Consultant on 3/8/19.
//  Copyright © 2019 MAC Consultant. All rights reserved.
//

import Foundation

class BooksSearchModel {
    
    
    struct ImageStruct {
        var imageThumbnail: Data?
    }
    
    struct Result: Decodable {
        var kind: String?
        var totalItems: Int?
        var items: [Items?]
        // an array of another struct that contains all the items
        
        enum CodingKeys: String, CodingKey {
            case kind = "kind"
            case totalItems = "totalItems"  //Custom keys
            case items = "items" //Custom keys
        }
    }
    
    struct Items: Decodable {
        var volumeinfo: OneItem?
        
        enum CodingKeys: String, CodingKey {
            case volumeinfo = "volumeInfo"
        }
    }
    
    struct OneItem: Decodable {
        var title: String?
        var subTitle: String?
        var author: [String]?
        var publisher: String?
        var imageLink: ImageLink?
        //var imageThumbnail: Data?
        
        enum CodingKeys: String, CodingKey {
            case title = "title"
            case subTitle = "subtitle"
            case author = "authors"
            case publisher = "publisher"
            case imageLink = "imageLinks"
        }
    }
    
    struct Author: Decodable{
        var author: String?
//        enum CodingKeys: String, CodingKey {
//            case author = "author"
//        }
    }
    
    struct ImageLink: Decodable {
        //var thumbnailData: ImageStruct
        var thumbnail: String?
        
        enum CodingKeys: String, CodingKey{
            //case smallThumbnail = "smallThumbnail"
            case thumbnail = "thumbnail"
        }
    }
    
    let searchResult = Result.self
}
