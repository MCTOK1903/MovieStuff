//
//  SearchBarDelegate.swift
//  MovieStuff
//
//  Created by Muhammed Celal Tok on 11.08.2022.
//

import UIKit

protocol SearchBarDelegateOutput: AnyObject {
    func searchTapped(_ searchKey: String)
}


class SearchBarDelegate: NSObject {
    weak var output: SearchBarDelegateOutput?
    
    init(output: SearchBarDelegateOutput) {
        self.output = output
    }
}

extension SearchBarDelegate: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchKey = searchBar.text else { return }
        
        output?.searchTapped(searchKey)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancelTapped")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
}
