//
//  ModeratorsListViewController.swift
//  InfiniteScrolling
//
//  Created by Lucas Nascimento on 11/01/20.
//  Copyright © 2020 Lucas Nascimento. All rights reserved.
//

import UIKit

class ModeratorsListViewController: UIViewController, AlertDisplayer {
    
    private let service: Service
    private let router: ModeratorRouter
    
    private var moderators: [Moderator]
    private var currentPage: Int
    private var isLoadInProgress: Bool
    
    private var theView: ModeratorsListView {
        return self.view as! ModeratorsListView // swiftlint:disable:this force_cast
    }
    
    init() {
        service = Service()
        router = ModeratorRouter.from(site: "stackoverflow")
        moderators = []
        currentPage = 1
        isLoadInProgress = false
        super.init(nibName: nil, bundle: nil)
        loadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = ModeratorsListView(frame: .zero)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    fileprivate func configureView() {
        view.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        theView.delegate = self
    }
    
    fileprivate func loadData() {
        guard !isLoadInProgress else {
            return
        }
        
        isLoadInProgress = true
        
        service.fetchModerators(with: router, page: currentPage) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.currentPage += 1
                    self.isLoadInProgress = false
                    self.moderators.append(contentsOf: response.moderators)
                    self.theView.viewModel = ModeratorsListViewModel(data: response, moderators: self.moderators)
                case .failure(let error):
                    self.isLoadInProgress = false
                    self.theView.stopAnimating()
                    let title = "Warning".localizedString
                    let action = UIAlertAction(title: "OK".localizedString, style: .default)
                    self.displayAlert(with: title, message: error.reason, actions: [action])
                }
            }
        }
    }
}

extension ModeratorsListViewController: ModeratorsListViewDelegate {
    
    func fetchNextPage() {
        loadData()
    }
}
