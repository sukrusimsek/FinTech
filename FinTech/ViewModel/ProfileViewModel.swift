//
//  ProfileViewModel.swift
//  FinTech
//
//  Created by Şükrü Şimşek on 21.03.2024.
//

import Foundation

protocol ProfileViewModelInterface {
    var view: ProfileViewInterface? { get set }
    func viewDidLoad()
}

final class ProfileViewModel {
    weak var view: ProfileViewInterface?
    
}
extension ProfileViewModel: ProfileViewModelInterface {
    func viewDidLoad() {
        
    }
}
