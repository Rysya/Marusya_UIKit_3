import UIKit

struct Post {
    let title: String
    let text: String
    let img: UIImage?
    let imageName: String?
    
    init(title: String, text: String, img: UIImage? = nil, imageName: String? = nil) {
        self.title = title
        self.text = text
        self.img = img
        self.imageName = imageName
    }
}

