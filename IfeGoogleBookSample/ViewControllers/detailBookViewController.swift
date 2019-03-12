//
//  detailBookViewController.swift
//  IfeGoogleBookSample
//
//  Created by MAC Consultant on 3/10/19.
//  Copyright © 2019 MAC Consultant. All rights reserved.
//

import UIKit
import CoreData

class detailBookViewController: UIViewController {
    var bookDetail: BooksSearchModel.OneItem!
    
    var image: UIImage!
    var bookTitle: String!
    var bookSubTitle: String!
    var bookAuthor: String!
    var imageUrl: String!
    //var imageUrl: String!
    
    @IBOutlet weak var detailBookImage: UIImageView!
    @IBOutlet weak var detailBookTitle: UILabel!
    @IBOutlet weak var detailBookSubTitle: UILabel!
    @IBOutlet weak var detailBookAuthor: UILabel!
    
    let service = CoreDataService()
    var favorite: Favorite!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.detailBookImage.image = image
        self.detailBookTitle.text = bookTitle
        self.detailBookSubTitle.text = bookSubTitle
        self.detailBookAuthor.text = bookAuthor
        
        
        
    }
    
    func CreateFavorite(_ bktitle: String, _ subtitle: String, _ author: String, imageurl: String ) {
        // get the context
        let context = service.context
        
        // create a Book in the context, if there isn't one
        favorite = NSEntityDescription.insertNewObject(forEntityName: "Favorite",
                                                       into: context) as? Favorite
        
        favorite.title = bktitle
        favorite.subtitle = subtitle
        favorite.author = author
        favorite.image = imageurl
        // save the Book in the context
        service.saveContext()

    }

    @IBAction func addFavoriteAction(_ sender: Any) {
        
        let title = bookTitle ?? "No title"
        let subtitle = bookSubTitle ?? "No Subtitle"
        let author = bookAuthor ?? "No Author"
        let imageurl = imageUrl ?? "No Image"
        
        CreateFavorite(title, subtitle, author, imageurl: imageurl)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func removeFavoriteAction(_ sender: Any) {
        let book = service.findAll(bookTitle)
        for i in book {
            if i.title == bookTitle {
                service.deleteBook(i)
            }
        }
        
        self.navigationController?.popViewController(animated: true)
        
    }
}
