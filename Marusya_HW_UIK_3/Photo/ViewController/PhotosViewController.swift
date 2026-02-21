import UIKit

class PhotosViewController: UIViewController {
    
    private let photoArh = PhotosArh()
    
    private var selectedImageView: UIImageView?
    private var backgroundView: UIView?
    private var currentIndex: Int = 0
    private var images: [UIImage] = []
    var zoomingImageView = UIImageView(frame: .zero)
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.frame = CGRect(x: view.frame.width - 44, y: 44, width: 44, height: 44)
        button.addTarget(self, action: #selector(closeFullscreen), for: .touchUpInside)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(PhotosCollectionViewCell.self,
                                forCellWithReuseIdentifier: PhotosCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Photo Gallery"
        view.addSubviews([collectionView])
    }
    
    func didTapCollectionPhoto(in cell: PhotosCollectionViewCell) {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.numberOfTouchesRequired = 1
        cell.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func closeFullscreen() {
        dismissFullscreen()
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            showNextImage()
        } else if gesture.direction == .right {
            showPreviousImage()
        }
    }
    
    func showNextImage() {
        guard currentIndex < images.count - 1 else { return }
        currentIndex += 1
        animateImageChange()
    }

    func showPreviousImage() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        animateImageChange()
    }

    func animateImageChange() {
        zoomingImageView.image = images[currentIndex]
    }
    
    private func dismissFullscreen() {
        
        guard let zoomOutImageView = selectedImageView,
              let backgroundView = backgroundView,
              let originalImageView = collectionView.visibleCells.compactMap({
                  $0 as? PhotosCollectionViewCell
              }).first(where: {
                  $0.imageView.image == zoomOutImageView.image
              })?.imageView
        else { return }
        
        let finalFrame = originalImageView.convert(originalImageView.bounds, to: nil)
        
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseInOut) {
            zoomOutImageView.frame = finalFrame
            backgroundView.alpha = 0
            
        } completion: { _ in
            zoomOutImageView.removeFromSuperview()
            backgroundView.removeFromSuperview()
            self.closeButton.removeFromSuperview()
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return photoArh.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.reuseIdentifier, for: indexPath) as? PhotosCollectionViewCell else {
            return UICollectionViewCell()
        }
        let imageName = photoArh.photos[indexPath.item]
        images = photoArh.photos.compactMap { UIImage(named: $0) }
        cell.configure(with: imageName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace: CGFloat = 8 * 4
        let availableWidth = collectionView.bounds.width - paddingSpace
        let widthPerItem = availableWidth / 3
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotosCollectionViewCell,
              let imageElement = cell.imageView.image,
              let imageSize = imageElement.size as CGSize?,
              let window = view.window
        else { return }
        
        selectedImageView = cell.imageView
        
        // Получаем frame в координатах окна
        let startingFrame = cell.imageView.convert(cell.imageView.bounds, to: nil)
        
        // Создаем overlay
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0
        self.backgroundView = backgroundView
        
        // Создаем анимируемую копию
        zoomingImageView = UIImageView(frame: startingFrame)
        zoomingImageView.image = imageElement
        zoomingImageView.contentMode = .scaleAspectFit
        zoomingImageView.clipsToBounds = true
        
        window.addSubview(backgroundView)
        window.addSubview(zoomingImageView)
        
        // Закрытие fullscreen по свайпу вверх-вниз
        let directions: [UISwipeGestureRecognizer.Direction] = [.up, .down]
        for direction in directions {
            let swipe = UISwipeGestureRecognizer(target: self,
                                                 action: #selector(closeFullscreen))
            swipe.direction = direction
            backgroundView.addGestureRecognizer(swipe)
            zoomingImageView.isUserInteractionEnabled = true
            zoomingImageView.addGestureRecognizer(swipe)
        }
        // Листание по свайпам влево-вправо
        let swipeLeft = UISwipeGestureRecognizer(target: self,
                                                 action: #selector(handleSwipe))
        swipeLeft.direction = .left
        let swipeRight = UISwipeGestureRecognizer(target: self,
                                                  action: #selector(handleSwipe))
        swipeRight.direction = .right
        zoomingImageView.addGestureRecognizer(swipeLeft)
        zoomingImageView.addGestureRecognizer(swipeRight)
        zoomingImageView.isUserInteractionEnabled = true
        
        // Вычисляем финальный frame
        let screenWidth = window.frame.width
        let screenHeight = window.frame.height

        let widthRatio = screenWidth / imageSize.width
        let heightRatio = screenHeight / imageSize.height

        let scale = min(widthRatio, heightRatio)

        let finalWidth = imageSize.width * scale
        let finalHeight = imageSize.height * scale

        let x = (screenWidth - finalWidth) / 2
        let y = (screenHeight - finalHeight) / 2

        let finalFrame = CGRect(x: x, y: y, width: finalWidth, height: finalHeight)
        
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       options: .curveEaseInOut) {
            self.zoomingImageView.frame = finalFrame
            backgroundView.alpha = 0.8
            window.addSubview(self.closeButton)
        } completion: { _ in
            self.zoomingImageView.isUserInteractionEnabled = true
            self.selectedImageView = self.zoomingImageView
        }
    }
}
