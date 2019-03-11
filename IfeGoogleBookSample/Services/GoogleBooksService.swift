//
//  GoogleBooksService.swift
//  IfeGoogleBookSample
//
//  Created by MAC Consultant on 3/9/19.
//  Copyright © 2019 MAC Consultant. All rights reserved.
//

import Foundation
import UIKit

class GoogleBooksService {
    // search for book function https://www.googleapis.com/books/v1/volumes?q={search term}&key={YOUR_API_KEY}
    func searchBooks (_ searchString : String, completion: @escaping(BooksSearchModel.Result)-> ()) {
        let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q="+searchString+"+inauthor:keyes&key=AIzaSyANfhDF12NS9coGn5oLpSc3KV2P83YfSAo")
        
        var request = URLRequest(url: url!,
                                 cachePolicy: .returnCacheDataElseLoad,
                                 timeoutInterval: 3.0)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request)
        { (data, response, error) in
            if let dat = data {
                // parse the data
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(BooksSearchModel.Result.self, from: dat)
                    //print("\(result)")
                    completion(result)
                }
                catch {
                    // error, something
                    print(error)
                }
            }
        }
        task.resume()
    }
    // download the book image from the api
    func downloadBookImages(for book: BooksSearchModel.OneItem,
                         completion: @escaping (BooksSearchModel.ImageStruct)->()) {
        
        let dataTaskComp: (Data?, URLResponse?, Error?)->() =
        { (data, _, _) in
            let image = BooksSearchModel.ImageStruct.init(imageThumbnail: data)
            completion(image)
        }
        
        let imageString = book.imageLink?.thumbnail
        
        if let url = URL(string: imageString!) {
            let dataTask = URLSession.shared.dataTask(with: url, completionHandler: dataTaskComp)
            
            dataTask.resume()

        }
    }
    
    func downloadFavoriteImage(for bookUrl: String, completion: @escaping (BooksSearchModel.ImageStruct)->()) {
        let dataTaskComp: (Data?, URLResponse?, Error?)->() =
        { (data, _, _) in
            let image = BooksSearchModel.ImageStruct.init(imageThumbnail: data)
            completion(image)
        }
        
        let imageString = bookUrl
        
        if let url = URL(string: imageString) {
            let dataTask = URLSession.shared.dataTask(with: url, completionHandler: dataTaskComp)
            
            dataTask.resume()
        }
    }
}
