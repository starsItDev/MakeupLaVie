//
//  File.swift
//  MakeupLaVie
//
//  Created by StarsDev on 29/05/2023.
//

import Foundation

protocol CollectionViewCellDelegate2: AnyObject {
    func didSelectItemAtIndex2(index: Int ,selectedID: Int )
}
protocol CollectionViewCellDelegate: AnyObject {
    func didSelectItemAtIndex(index: Int, selectedID: Int)
}
