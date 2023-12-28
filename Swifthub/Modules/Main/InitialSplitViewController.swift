//
//  InitialSplitViewController.swift
//  Swifthub
//
//  Created by apple on 2023/12/28.
//

import UIKit
import PromiseKit
import Then
import SnapKit

class InitialSplitViewController: UIViewController {
    
    private lazy var _redImage = UIImageView(frame: CGRect.zero).then {
        $0.image = R.image.launch_image()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubview(self._redImage)
        self._redImage.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 100, height: 100))
            make.center.equalToSuperview()
        }
        
    }
    


}
