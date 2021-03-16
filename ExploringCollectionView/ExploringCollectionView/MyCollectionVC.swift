//
//  MyCollectionVC.swift
//  ExploringCollectionView
//
//  Created by Екатерина Боровкова on 16.03.2021.
//

import UIKit

private let reuseIdentifier = "ItemCell"
struct  StructItem {
  let image: String
  let text: String
}

class MyCollectionVC: UICollectionViewController {
  
    var arrayItems = [StructItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayItems.append(StructItem(image: "temp.darkYellow", text: "Dark yellow color"))
        arrayItems.append(StructItem(image: "temp.orange", text: "Orange color"))
        arrayItems.append(StructItem(image: "temp.red", text: "Red color"))
    
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayItems.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ItemCell {
        cell.imageView.image = UIImage(named: arrayItems[indexPath.row].image)
        cell.labelText.text = arrayItems[indexPath.row].text
        return cell
       }
       return UICollectionViewCell()
    }
}
