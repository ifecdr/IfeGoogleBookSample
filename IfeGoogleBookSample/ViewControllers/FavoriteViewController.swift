//
//  FavoriteViewController.swift
//  IfeGoogleBookSample
//
//  Created by MAC Consultant on 3/10/19.
//  Copyright © 2019 MAC Consultant. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {
    @IBOutlet weak var favoriteCollection: UICollectionView!
    
    var favorite = [Favorite]()
    var imageData = [Data?]()
    let service = CoreDataService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        favoriteCollection.delegate = self
        favoriteCollection.dataSource = self
        loadFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func loadFavorites() {
        
        favorite = service.getAllBooks()
        let pictureCompletion: (BooksSearchModel.ImageStruct)-> () = { (img) in
            self.imageData.append(img.imageThumbnail!)
            print("Image decoded")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                self.favoriteCollection.reloadData()
            })
        }
        let getImage = GoogleBooksService()
        for i in favorite {
            getImage.downloadFavoriteImage(for: i.image!, completion: pictureCompletion)
        }
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "col" {
            let vc = segue.destination as! detailBookViewController
            // get index of the collection
            if let cell = sender as? BooksCollectionViewCell {
                if let indexPath = favoriteCollection.indexPath(for: cell) {
                    vc.image = UIImage(data: imageData[indexPath.row]!)
                    vc.bookTitle = favorite[indexPath.row].title
                    vc.bookSubTitle = favorite[indexPath.row].subtitle
                    vc.bookAuthor = favorite[indexPath.row].author
                    vc.imageUrl = favorite[indexPath.row].image
                }
            }
        }
    }
    
}
extension FavoriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "col", sender: favoriteCollection.cellForItem(at: indexPath))
    }

}

extension FavoriteViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fav", for: indexPath) as! BooksCollectionViewCell
        
        let fav = favorite[indexPath.row]
        cell.bookTitle.text = fav.title
        
        if let imageDat = imageData[indexPath.row] {
            let image = UIImage(data: imageDat)
            cell.imageViewer.image = image
        }
        else {
            cell.imageViewer.image = nil
        }
        
        return cell
    }
}
