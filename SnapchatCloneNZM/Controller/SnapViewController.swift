//
//  SnapViewController.swift
//  SnapchatCloneNZM
//
//  Created by Nazim Asadov on 06.02.22.
//

import UIKit
import ImageSlideshow
import SDWebImage

class SnapViewController: UIViewController {

    
    @IBOutlet weak var timeLabel: UILabel!
    var selectedSnap: SnapModel?
    var inputArray = [SDWebImageSource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       if let snap = selectedSnap {
           timeLabel.text = "Time left: \(snap.timeDifference) hours"
           for imageUrl in snap.imageUrlArray {
               inputArray.append(SDWebImageSource(urlString: imageUrl)!)
           }
           
           let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.9))

           imageSlideShow.backgroundColor = UIColor.white
           
           let pageIndcator = UIPageControl()
           pageIndcator.currentPageIndicatorTintColor = UIColor.lightGray
           pageIndcator.pageIndicatorTintColor = UIColor.black
           imageSlideShow.pageIndicator = pageIndcator
           
           imageSlideShow.contentScaleMode = .scaleAspectFit
           imageSlideShow.setImageInputs(inputArray)
           self.view.addSubview(imageSlideShow)
           self.view.bringSubviewToFront(timeLabel)
       }
    }
}
