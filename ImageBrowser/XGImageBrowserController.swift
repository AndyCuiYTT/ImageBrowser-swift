//
//  XGImageBrowserController.swift
//  ImageBrowser
//
//  Created by CuiXg on 2021/6/2.
//

import UIKit

public protocol XGImageBrowserDelegate: class {

    func xg_imageBrowser(_ imageBrowser: XGImageBrowserController, didShowAtIndex index: Int)


    func xg_imageBrowser(_ imageBrowser: XGImageBrowserController, longPressAtIndex index: Int)

}

public class XGImageBrowserController: UIViewController {

    public weak var delegate: XGImageBrowserDelegate?

    private var images: [UIImage]?

    private var imagesUrl: [String]?

    private var totalCount: Int = 0
    private var currentIndex: Int = 0 {
        didSet {
            pageControl.currentPage = currentIndex
        }
    }

    private var collectionView: UICollectionView?

    private var pageControl = UIPageControl()

    init(images: [UIImage], currentIndex index: Int) {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
        self.totalCount = images.count
        self.images = images
        self.currentIndex = index
    }

    init(imagesUrl: [String], currentIndex index: Int) {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .currentContext
        self.totalCount = imagesUrl.count
        self.imagesUrl = imagesUrl
        self.currentIndex = index
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.cyan

        imagesUrl = ["https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1045444614,117700133&fm=26&gp=0.jpg",
        "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=981233986,2945885124&fm=26&gp=0.jpg",
        "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2806499169,1233842290&fm=15&gp=0.jpg",
        "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=4161144463,2619881707&fm=26&gp=0.jpg",
        "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3319354723,3728526269&fm=15&gp=0.jpg",
        "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2974264929,4053472867&fm=26&gp=0.jpg"]
        totalCount = imagesUrl?.count ?? 0

        xg_setSubviews()

    }

    private func xg_setSubviews() {

        let layout = UICollectionViewFlowLayout()
        // 设置每个图片大小
        layout.itemSize = self.view.bounds.size
        // 竖直方向间距
        layout.minimumLineSpacing = 0
        // 水平方向间距
        layout.minimumInteritemSpacing = 0
        // 设置水平滑动
        layout.scrollDirection = .horizontal
        // section 内间距
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        // 设置 collectionView
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor = UIColor.black
        // 不显示滑动条
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        // 再多个视图边界停止
        collection.isPagingEnabled = true
        // 注册 cell
        collection.register(XGImageBrowserCell.self, forCellWithReuseIdentifier: "XGImageBrowserCell")
        // 设置代理
        collection.delegate = self
        collection.dataSource = self
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(xg_longPressAction(_:)))
        longPress.minimumPressDuration = 0.3
        longPress.allowableMovement = 5.0
        collection.addGestureRecognizer(longPress)
        collection.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collection)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            collection.setContentOffset(CGPoint(x: CGFloat(self.currentIndex) * self.view.bounds.width, y: 0), animated: false)
        }
        self.collectionView = collection
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: [.alignAllCenterX, .alignAllCenterY], metrics: nil, views: ["collectionView" : collection]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|", options: [.alignAllCenterX, .alignAllCenterY], metrics: nil, views: ["collectionView" : collection]))

        // 分页控制器
        pageControl.numberOfPages = totalCount
        pageControl.currentPage = currentIndex
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pageControl)
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[pageControl]-|", options: .alignAllCenterX, metrics: nil, views: ["pageControl" : pageControl]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[pageControl]-bottom-|", options: .alignAllCenterX, metrics: ["bottom": 20], views: ["pageControl" : pageControl]))
    }

    @objc private func xg_longPressAction(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            delegate?.xg_imageBrowser(self, longPressAtIndex: currentIndex)
        }
    }

    public override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension XGImageBrowserController: UICollectionViewDelegate, UICollectionViewDataSource {


    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalCount
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "XGImageBrowserCell", for: indexPath) as? XGImageBrowserCell {
            cell.closeBrowserClosure = { () in
                if self.presentingViewController != nil {
                    self.dismiss(animated: true, completion: nil)
                }else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            if let imgs = imagesUrl {
                cell.xg_setValue(withImageUrl: imgs[indexPath.item])
            }else if let imgs = images {
                cell.xg_setValue(withImage: imgs[indexPath.item])
            }

            return cell
        }
        return UICollectionViewCell()
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x / self.view.bounds.width)
        delegate?.xg_imageBrowser(self, didShowAtIndex: currentIndex)
    }


}
