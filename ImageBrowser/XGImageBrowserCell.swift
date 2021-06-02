//
//  XFSImageBrowserCell.swift
//  ImageBrowser
//
//  Created by CuiXg on 2021/6/2.
//

import UIKit
import Kingfisher

class XGImageBrowserCell: UICollectionViewCell {

    private let imageView = UIImageView()
    private let scrollView = UIScrollView()

    var closeBrowserClosure: (() -> Void)?
    var lookUpImageClosure: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        // 设置位置大小
        scrollView.frame = self.bounds
        // 最小缩放比例
        scrollView.minimumZoomScale = 0.5
        // 最大缩放比例
        scrollView.maximumZoomScale = 5
        // 设置代理
        scrollView.delegate = self
        // 不显示滑条
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        self.contentView.addSubview(scrollView)

        // 设置图片显示
        imageView.frame = self.bounds
        // 自适应显示
        imageView.contentMode = .scaleAspectFit
        // 打开响应者链
        imageView.isUserInteractionEnabled = true
        scrollView.addSubview(imageView)

        // 设置手势
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(xg_closeBrowser(_:)))
        singleTap.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(singleTap)

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(xg_lookUpImage(_:)))
        doubleTap.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTap)
        singleTap.require(toFail: doubleTap)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 点击关闭图片浏览器
    @objc private func xg_closeBrowser(_ sender: UITapGestureRecognizer) {
        closeBrowserClosure?()
    }

    /// 双击放大查看图片
    @objc private func xg_lookUpImage(_ sender: UITapGestureRecognizer) {
        lookUpImageClosure?()
        var zoomScale = scrollView.zoomScale
        zoomScale = zoomScale <= 1.0 ? 2.0 : 1.0
        scrollView.zoomScale = zoomScale
//        scrollView.zoom(to: <#T##CGRect#>, animated: <#T##Bool#>)
    }

    func xg_setValue(withImageUrl url: String) {
        scrollView.zoomScale = 1
        imageView.kf.setImage(with: URL(string: url), placeholder: UIImage())
    }

    func xg_setValue(withImage image: UIImage) {
        scrollView.zoomScale = 1
        imageView.image = image
    }

}

extension XGImageBrowserCell: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        lookUpImageClosure?()
    }
}
