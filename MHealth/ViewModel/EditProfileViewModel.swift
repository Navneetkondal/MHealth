////
//	EditViewModel.swift
//	MHealth
//
//	Created By Navneet on 25/12/24
//


import SwiftUI
import Foundation
import Combine
import PhotosUI
import UIKit

class EditProfileViewModel: ObservableObject {
    
    @Published var isDobEmpty = true
    @Published var isHeightEmpty = true
    @Published var isWeightEmpty = true
    @Published var isGenderEmpty = true
    @Published  var selectedItem: PhotosPickerItem?
    @Published var image: Image?
    @Published var height: String = ""
    @Published var weight: String = ""
    @Published var dobStr: String = ""
    @Published var isPhotosPermission:Bool = false
    @Published var isCameraPermission:Bool = false
    
    var genders: [UserGender] = [.Male, .Female, .Other]
    
    init() {
        getCameraPermission()
        getPhotoLibraryPermission()
    }
    
    func setHeightAndWeight(_ user: MHealthUser){
        image = user.getUserImage()
        height = "\(user.getHeightString())"
        weight = user.getWeightString()
        dobStr = user.getUserDateOfBirth()?.getDateStringFromUTC(.EEEddMMMyyyy) ?? ""
        updateFlags(user)
    }
    
    func updateFlags(_ user: MHealthUser){
        isWeightEmpty = weight == ""
        isHeightEmpty =  height == ""
        isGenderEmpty = (UserGender(rawValue: user.gender) ?? .None) == .None
        isDobEmpty = user.dob == nil  || user.dob == -1
    }
    
    func getCameraPermission()  {
        Task{@MainActor in
            let status =  AVCaptureDevice.authorizationStatus(for: .video)
            switch(status){
                case .authorized:
                    isCameraPermission = true
                case .notDetermined:
                    await AVCaptureDevice.requestAccess(for: .video)
                    isCameraPermission = true
                case .denied:
                    isCameraPermission = false
                case .restricted:
                    isCameraPermission = false
                @unknown default:
                    isCameraPermission = false
            }
        }
    }
    
    func getPhotoLibraryPermission(for accessLevel: PHAccessLevel = .readWrite) {
        Task{@MainActor in
            let status = PHPhotoLibrary.authorizationStatus(for: accessLevel)
            switch status {
                case .authorized, .limited:
                    isPhotosPermission = true
                    break
                case   .denied, .restricted :
                    isPhotosPermission = false
                    break
                case .notDetermined:
                    PHPhotoLibrary.requestAuthorization(for: accessLevel) { [weak self] status in
                        Task{@MainActor in
                            switch status {
                                case .authorized, .limited:
                                    self?.isPhotosPermission = true
                                    break
                                case .notDetermined,  .restricted, .denied:
                                    self?.isPhotosPermission = false
                                    break
                                @unknown default:
                                    self?.isPhotosPermission = false
                            }
                        }
                    }
                default:
                    break
            }
        }
    }
    
    @MainActor
    func saveProfile(_ user: MHealthUser){
        if let img = image, let imgData =  img.getUIImage()?.jpegData(compressionQuality: 0.2) {
            user.img = imgData
        }
        DBUtils.updateUserProfile(user)
    }
}



