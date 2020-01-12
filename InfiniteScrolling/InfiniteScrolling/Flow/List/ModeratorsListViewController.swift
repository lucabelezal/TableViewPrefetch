//
//  ModeratorsListViewController.swift
//  InfiniteScrolling
//
//  Created by Lucas Nascimento on 11/01/20.
//  Copyright © 2020 Lucas Nascimento. All rights reserved.
//

import UIKit

class ModeratorsListViewController: UIViewController, AlertDisplayer {
    
    var theView: ModeratorsListView {
        return self.view as! ModeratorsListView // swiftlint:disable:this force_cast
    }
    
    private var moderators: [Moderator] = []
    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false

    private let service: Service = Service()
    private let router: ModeratorRouter = ModeratorRouter.from(site: "stackoverflow")


    init() {
        super.init(nibName: nil, bundle: nil)
        fetchModerators()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = ModeratorsListView(frame: .zero)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        
        theView.delegate = self
    }

    // MARK: - Private Metthods

    func fetchModerators() {
      guard !isFetchInProgress else {
        return
      }

      isFetchInProgress = true

      service.fetchModerators(with: router, page: currentPage) { result in
        switch result {
        case .failure(let error):
          DispatchQueue.main.async {
            self.isFetchInProgress = false
            self.theView.indicatorView.stopAnimating()
            let title = "Warning".localizedString
            let action = UIAlertAction(title: "OK".localizedString, style: .default)
            self.displayAlert(with: title, message: error.reason, actions: [action])
            
          }
        case .success(let response):
          DispatchQueue.main.async {
            self.currentPage += 1
            self.isFetchInProgress = false
            self.moderators.append(contentsOf: response.moderators)
            self.theView.viewModel = ModeratorsListViewModel(data: response, moderators: self.moderators)
          }
        }
      }
    }
    
    private func calculateIndexPathsToReload(from newModerators: [Moderator]) -> [IndexPath] {
      let startIndex = moderators.count - newModerators.count
      let endIndex = startIndex + newModerators.count
      return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    private func loadData() {
        
  
    }

    private func updateView() {

    }
}

extension ModeratorsListViewController: ModeratorsListViewDelegate {
 
    func fetchNextPageOfModerators() {
        fetchModerators()
    }
}
