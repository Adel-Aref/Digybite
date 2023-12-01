//  BaseViewModel.swift
//  DigybiteTask
//
//  Created by Adel Aref on 30/11/2023.
//
import Foundation
import RxSwift

protocol BaseViewModel {
    var isLoading: PublishSubject<Bool> { get }
    var isError: PublishSubject<ErrorMessage> { get }
    var disposeBag: DisposeBag { get }
}
extension BaseViewModel {
    func configureDisposeBag() {
        isError.disposed(by: disposeBag)
        isLoading.disposed(by: disposeBag)
    }
}
protocol BaseViewController {
    var disposeBag: DisposeBag { get }
}
