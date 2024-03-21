//
//  ProfileView.swift
//  FinTech
//
//  Created by Şükrü Şimşek on 21.03.2024.
//

import UIKit
protocol ProfileViewInterface: AnyObject {
    
}
final class ProfileView: UIViewController {
    private let viewModel = ProfileViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
        
        
    }
}

extension ProfileView: ProfileViewInterface {
    
    
}
