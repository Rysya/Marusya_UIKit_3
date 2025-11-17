struct Post {
    let title: String
    let text: String
    let imageName: String?
    
    init(title: String, text: String, imageName: String? = nil) {
        self.title = title
        self.text = text
        self.imageName = imageName
    }
}

