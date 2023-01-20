//
//  KeywordSearchBarViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/20.
//

import RxSwift
import RxCocoa

struct KeywordSearchBarViewModel {
    let queryText = PublishRelay<String?>()
    let shouldLoadResult: Observable<String>
    let searchButtonTapped = PublishRelay<Void>()
    
    init() {
        self.shouldLoadResult = searchButtonTapped
            .withLatestFrom(queryText) { $1 ?? "" }
            .filter{ !$0.isEmpty }
            .distinctUntilChanged()
    }
}
