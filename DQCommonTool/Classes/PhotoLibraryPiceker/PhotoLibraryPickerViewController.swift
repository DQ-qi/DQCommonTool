//
//  PhotoLibraryPickerViewController.swift
//  DQCommonTool
//
//  Created by HXSMac on 2019/12/14.
//

import Foundation
import UIKit
import Photos

public extension UIAlertController {
    
    func addPhotoLibraryPicker(flow: UICollectionView.ScrollDirection, paging: Bool, selection: PhotoLibraryPickerViewController.Selection) {
        let selection: PhotoLibraryPickerViewController.Selection = selection
        let vc = PhotoLibraryPickerViewController(flow: flow, pageing: paging, selection: selection)
        if UIDevice.current.userInterfaceIdiom == .pad {
            vc.preferredContentSize.height = vc.preferredSize.height * 0.8
            vc.preferredContentSize.width = vc.preferredSize.width * 0.8
        } else {
            //var height = vc.preferredSize.height
            
            
            
            vc.preferredContentSize.height = vc.preferredSize.height*0.8
        }
        set(vc: vc)
    }
    
}

public class PhotoLibraryPickerViewController: UIViewController {
    
    // 单选
    public typealias SingleSelection = (PHAsset?)->()
    // 多选
    public typealias MultipleSelection = ([PHAsset])->()
    
    public enum Selection {
        case single(action: SingleSelection?)
        case multiple(action: MultipleSelection?)
    }
    
    var preferredSize: CGSize {
        return UIScreen.main.bounds.size
    }
    
    var columns: CGFloat {
        switch layout.scrollDirection {
        case .vertical:
            return UIDevice.current.userInterfaceIdiom == .pad ? 3 : 2
        case .horizontal:
            return 1
        default:
            return 1
        }
    }
    
    var itemSize: CGSize {
        switch layout.scrollDirection {
        case .vertical:
            return CGSize.init(width: view.bounds.width / columns, height: view.bounds.width / columns)
        case .horizontal:
            return CGSize.init(width: view.bounds.width, height: view.bounds.width / columns)
        default:
            return CGSize.init(width: view.bounds.width, height: view.bounds.width / columns)
        }
    }
    
    lazy var collectionView: UICollectionView = { [unowned self] in
        $0.delegate = self
        $0.dataSource = self
        $0.showsVerticalScrollIndicator = false
        $0.decelerationRate = UIScrollView.DecelerationRate.fast
        if #available(iOS 11.0, *) {
            $0.contentInsetAdjustmentBehavior = .always
        }
        $0.bounces = true
        $0.backgroundColor = .clear
        $0.clipsToBounds = false
        $0.layer.masksToBounds = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.register(ItenWithImageCell.self, forCellWithReuseIdentifier: String.init(describing: ItenWithImageCell.self))
        return $0
    }(UICollectionView.init(frame: UIScreen.main.bounds, collectionViewLayout: layout))
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        return layout
    }()
    
    var selection: Selection?
    
    var assets: [PHAsset] = [PHAsset]()
    
    var selectedAssets: [PHAsset] = []
    
    public init(flow: UICollectionView.ScrollDirection,pageing: Bool,
                selection: Selection) {
        super.init(nibName: nil, bundle: nil)
        self.selection = selection
        self.layout.scrollDirection = flow
        self.collectionView.isPagingEnabled = pageing
        switch selection {
        case .single(_):
            collectionView.allowsSelection = true
        case .multiple(_):
            collectionView.allowsMultipleSelection = true
        }
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        DQPrint("has deinitialized")
    }
    
    public override func loadView() {
        view = collectionView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        updatePhotos()
    }
    
    func updatePhotos() {
        checkStatus { [unowned self] (assets) in
            self.assets.removeAll()
            self.assets.append(contentsOf: assets)
            self.collectionView.reloadData()
        }
    }
    
    func checkStatus(completionHandler: @escaping (([PHAsset])->())) {
        DQPermissions.authorizePhotoWith { [unowned self] in
            DispatchQueue.main.async {
                self.fetchPhotos(completionHandler: completionHandler)
            }
        }
    }
    
    func fetchPhotos(completionHandler: @escaping ([PHAsset])->()) {
        Assets.fetch { (result) in
            switch result {
                case .success(response: let assets):
                    completionHandler(assets)
                case .error(error: let error):
                    let alertCtl = UIAlertController.init(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alertCtl.addAction(title: "OK", style: .default, isEnabled: true) { (action) in
                        
                    }
                    alertCtl.show()
            }
        }
    }
}

extension PhotoLibraryPickerViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = assets[indexPath.item]
        switch selection {
            
        case .single(let action)?:
            action?(asset)
            
        case .multiple(let action)?:
            selectedAssets.contains(asset)
                ? selectedAssets.remove(asset)
                : selectedAssets.append(asset)
            action?(selectedAssets)
            
        case .none: break }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let asset = assets[indexPath.item]
        switch selection {
        case .multiple(let action)?:
            selectedAssets.contains(asset)
                ? selectedAssets.remove(asset)
                : selectedAssets.append(asset)
            action?(selectedAssets)
        default: break }
    }
    
}

extension PhotoLibraryPickerViewController: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ItenWithImageCell.self), for: indexPath) as? ItenWithImageCell else { return UICollectionViewCell() }
        let asset = assets[indexPath.item]
        Assets.resolve(asset: asset, size: item.bounds.size) { new in
            item.imageView.image = new
        }
        return item
    }
    
}

extension PhotoLibraryPickerViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return itemSize
       
    }
    
}

class ItenWithImageCell: UICollectionViewCell {
    
    let identifier = String.init(describing: ItenWithImageCell.self)
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var unselectedCircle: UIView = {
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 2
        $0.layer.masksToBounds = false
        return $0
    }(UIView())
    
    lazy var selectedCircle: UIView = {
        $0.backgroundColor = UIColor(hex: 0x007AFF)
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.masksToBounds = true
        return $0
    }(UIView())
    
    lazy var selectedPoint: UIView = {
        let selectionPoint = UIView()
        selectionPoint.backgroundColor = UIColor.init(hex: 0x007AFF)
        return selectionPoint
    }()
    
    fileprivate let inset: CGFloat = 8
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        backgroundColor = .clear
        let unselected = UIView()
        unselected.addSubview(imageView)
        unselected.addSubview(unselectedCircle)
        backgroundView = unselected
        
        let selected = UIView()
        selected.addSubview(selectedCircle)
        selected.addSubview(selectedPoint)
        selectedBackgroundView = selected
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    func layout() {
        imageView.frame = contentView.frame
        updateAppearance(forCircle: unselectedCircle)
        updateAppearance(forCircle: selectedCircle)
        updateAppearance(forPoint: selectedPoint)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.frame.size = size
        layout()
        return size
    }
    
    func updateAppearance(forCircle view: UIView) {
        view.frame.size = CGSize(width: 28, height: 28)
        view.frame.origin.x = imageView.bounds.width - unselectedCircle.bounds.width - inset
        view.frame.origin.y = inset
        view.circleCorner = true
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.2
        view.layer.shadowPath = UIBezierPath(roundedRect: unselectedCircle.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: unselectedCircle.bounds.width / 2, height: unselectedCircle.bounds.width / 2)).cgPath
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func updateAppearance(forPoint view: UIView) {
        view.frame.size = CGSize(width: unselectedCircle.frame.size.width - unselectedCircle.layer.borderWidth * 2, height: unselectedCircle.frame.size.height - unselectedCircle.layer.borderWidth * 2)
        view.center = selectedCircle.center
        view.circleCorner = true
    }
    
}

extension UIView {
    
    public var circleCorner: Bool {
        get {
            return min(bounds.size.height, bounds.size.width) / 2 == cornerRadius
        }
        set {
            cornerRadius = newValue ? min(bounds.size.height, bounds.size.width) / 2 : cornerRadius
        }
    }
    
    public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = circleCorner ? min(bounds.size.height, bounds.size.width) / 2 : newValue
            //abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
    
}
