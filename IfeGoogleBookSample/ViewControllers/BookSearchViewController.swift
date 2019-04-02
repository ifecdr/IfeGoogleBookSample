//
//  ViewController.swift
//  IfeGoogleBookSample
//
//  Created by MAC Consultant on 3/8/19.
//  Copyright © 2019 MAC Consultant. All rights reserved.
//

import UIKit

class BookSearchViewController: UIViewController {
    var searchResult = [BooksSearchModel.Items]()
    var eachResult = [BooksSearchModel.OneItem]()
    //
    var authors = [BooksSearchModel.Author]()
    var imageData = [BooksSearchModel.ImageStruct]()
    var imageDict = [Data]()
    
    
    @IBOutlet weak var searchBarControl: UISearchBar!
    @IBOutlet weak var tableViewControl: UITableView!
    
    let searching = GoogleBooksService()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableViewControl.delegate = self
        tableViewControl.dataSource = self
        
        searchBarControl.delegate = self

        let nib = UINib(nibName: "BookTableViewCell", bundle: nil)
        tableViewControl.register(nib, forCellReuseIdentifier: "BookCell")
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "details" {
            var authorString: String = ""
            let vc = segue.destination as! detailBookViewController
            // get the index of the selected row
            let index = tableViewControl.indexPathForSelectedRow?.row
            if let img = UIImage(data: imageData[index!].imageThumbnail!) ?? UIImage(named: "plankton"){
                vc.image = img
            } else {
                vc.image = UIImage(named: "plankton")
            }
            //vc.image = UIImage(data: imageData[index!].imageThumbnail!)
            vc.bookTitle = eachResult[index!].title
            vc.bookSubTitle = eachResult[index!].subTitle
            
            for i in eachResult[index!].author! {
                authorString += i
                authorString += ", "
            }
            vc.bookAuthor = authorString
            if eachResult[index!].imageLink?.thumbnail != nil {
                vc.imageUrl = eachResult[index!].imageLink?.thumbnail
            } else {
                vc.imageUrl = "No Image Url"
            }
        }
    }
}

extension BookSearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as? BookTableViewCell  else {
//            fatalError("The dequeued cell is not an instance of BookCell.")
//        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookTableViewCell
        var authorString: String = ""
        let book = self.eachResult[indexPath.row]
        print(book.title!)
        //cell.textLabel?.text = book.title
        cell.titleLabel.text = book.title
        cell.subtitleLabel.text = book.subTitle ?? "No SubTitle"
        
        
        if imageData[indexPath.row].imageThumbnail != nil {
            let image = UIImage(data: imageData[indexPath.row].imageThumbnail!)
            cell.imageViewer.image = image
        } else {
            cell.imageViewer.image = UIImage(named: "plankton")
        }
        if let _ = book.author {
            for i in book.author! {
                authorString += i
                authorString += ", "
            }
        
            cell.authorLabel.text = authorString
        }
        return cell
    }
    
}

extension BookSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "details", sender: self)
    }
    
}
extension BookSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.eachResult.removeAll()
        self.imageData.removeAll()
        self.searchResult.removeAll()
        
        let completion: (BooksSearchModel.Result)-> () = { (result) in
            self.searchResult = result.items as! [BooksSearchModel.Items]
            for i in self.searchResult {
//                if i.volumeinfo?.imageLink?.thumbnail != nil {
//                    self.eachResult.append(i.volumeinfo!)
//
//                }
                self.eachResult.append(i.volumeinfo!)
            }
            
            print(Thread.isMainThread)
            // download the image from here
//            let pictureCompletion: (BooksSearchModel.ImageStruct)-> () = { (img) in
//                if img.imageThumbnail != nil {
//                    self.imageData.append(img)
//                    //self.imageDict
//                }
//                print("image downloaded")
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
//                    self.tableViewControl.reloadData()
//                })
//            }

            for i in self.searchResult{

                if i.volumeinfo?.imageLink?.thumbnail != nil {
                    let url = URL(string: (i.volumeinfo?.imageLink?.thumbnail!)!)
                    guard let data = try? Data(contentsOf: url!) else {
                        return
                    }
                    self.imageData.append()
                    //self.searching.downloadBookImages(for: i.volumeinfo!, completion: pictureCompletion)
                }
            }
        }
        guard let searchString = searchBarControl.text else {
            return
        }
        //searchString
        let v =  searchString.replacingOccurrences(of: " ", with: "+")
        if v != "" {
            searching.searchBooks(v, completion: completion)
        } else {
            self.eachResult.removeAll()
            self.imageData.removeAll()
            self.searchResult.removeAll()
            tableViewControl.reloadData()
        }
        
        
        
    }
 
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.eachResult.removeAll()
        self.imageData.removeAll()
        searchBarControl.text?.removeAll()
        self.tableViewControl.reloadData()
    }
}


