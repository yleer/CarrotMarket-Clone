//
//  Constants.swift
//  RealSungsu
//
//  Created by Yundong Lee on 2021/06/29.
//

import Foundation
import UIKit

struct Constants {
    static let maxSize : Int = 4 * 1024 * 1024
    static let FireStoreUsedItemCollectionName = "realestate data"
    static let FireStoreChatRoomCollectionName = "rooms"
    
    struct ListViewController {
        static let showDetailSegue = "show detail"
        static let uploadSegue = "upload segue"
        static let spinnerSize = CGSize(width: 100, height: 100)
        static let cellHeight : CGFloat = 150
    }
    
    struct DetailViewController {
        static let detailVCtoChatVCsegue = "chat segue"
        static let collectionViewCellName = "DetailImageCell"
        static let collectionViewCellIdentifier = "image collection cell"
        
        static let tableViewContentCellIdentfier = "content cell"
        static let tableViewEmailCellIdeintifer = "id cell"
        
        static let tableViewInfoCellHeight : CGFloat = 80
        static let tableViewContentCellHieght : CGFloat = 500
        
        static let maxLoadImageSize : Int = 4 * 1024 * 1024
        
    }
    
    struct UploadTableViewController {
        
        static let Cellidenteifer = ["house image cell","titleCell", "location cell","price cell","content cell"]
        static let addImageCollectionViewCellId = "collectionView add Button"
        static let uploadedImagesCollectionViewCellId = "collection view image cell"
        static let collectionCellSize = CGSize(width: 60, height: 60)
        static let locationSearchSegue = "choose location segue"
        static let segueToSuccessScreen = "success saving"
        
        static let uploadImageCellHeight: CGFloat = 100
        static let contentCellHeight: CGFloat = 500
        static let otherCellHieght: CGFloat = 70
    }
    
    struct LocationSearchVC{
        static let kakoAuth = "KakaoAK 8e455de386571ac030cfe8651e82b8cd"
        static let kakoEndPoint = "https://dapi.kakao.com/v2/local/search/address.json"
        static let jusoConfirmKet = "devU01TX0FVVEgyMDIxMDcwMzE1MjYxNzExMTM1MzQ="
        static let jusoEndPoint = "https://www.juso.go.kr/addrlink/addrLinkApi.do"
    }
    
    struct ChatListTableViewController {
        static let chatListCellId = "chatListCell"
        static let selectChatRoomSegue = "select a chat"
    }
    
    struct ChatViewController {
        static let messeageCellId = "message cell"
        static let meColor = "BrandPurple"
        static let youColor =  "BrandBlue"
    }
    
    struct MapViewController {
        static let segueToDetail = "map to detail segue"
    }
    
}
