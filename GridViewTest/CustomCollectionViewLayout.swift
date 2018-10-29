//
//  CustomCollectionViewLayout.swift
//  CustomCollectionLayout
//
//  Created by JOSE MARTINEZ on 15/12/2014.
//  Copyright (c) 2014 brightec. All rights reserved.
//

import UIKit

class CustomCollectionViewLayout: UICollectionViewLayout {

    public var numberOfColumns = 18
    var shouldPinFirstColumn = true
    var shouldPinFirstRow = true

    var itemAttributes = [[UICollectionViewLayoutAttributes]]()
    var itemsSize = [CGSize]()
    var contentSize: CGSize = .zero

    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }

        if collectionView.numberOfSections == 0 {
            return
        }

        if itemAttributes.count != collectionView.numberOfSections {
            generateItemAttributes(collectionView: collectionView)
            return
        }

        for section in 0..<collectionView.numberOfSections {
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                if section != 0 && item != 0 {
                    continue
                }

                let attributes = layoutAttributesForItem(at: IndexPath(item: item, section: section))!
                if section == 0 {
                    var frame = attributes.frame
                    frame.origin.y = collectionView.contentOffset.y
                    attributes.frame = frame
                }

                if item == 0 {
                    var frame = attributes.frame
                    frame.origin.x = collectionView.contentOffset.x
                    attributes.frame = frame
                }
            }
        }

    }

    override var collectionViewContentSize: CGSize {
        return contentSize
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
      let itemAttribute = itemAttributes[indexPath.section][indexPath.row]
      
        return itemAttributes[indexPath.section][indexPath.row]
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        for section in itemAttributes {
            let filteredArray = section.filter { obj -> Bool in
                return rect.intersects(obj.frame)
            }

            attributes.append(contentsOf: filteredArray)
        }
        return attributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

}

// MARK: - Helpers
extension CustomCollectionViewLayout {

    func generateItemAttributes(collectionView: UICollectionView) {
        if itemsSize.count != numberOfColumns {
            calculateItemSizes()
        }

        var column = 0
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        var contentWidth: CGFloat = 0

        itemAttributes = []

        for section in 0..<collectionView.numberOfSections {
            var sectionAttributes: [UICollectionViewLayoutAttributes] = []

            for index in 0..<numberOfColumns {
                let itemSize = itemsSize[index]
                let indexPath = IndexPath(item: index, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//              if section == 0 || index == 0 {
//                xOffset = 0
//                yOffset = 0
//              }
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height).integral

                if section == 0 && index == 0 {
                    // First cell should be on top
                    attributes.zIndex = 1024
                } else if section == 0 || index == 0 {
                    // First row/column should be above other cells
                    attributes.zIndex = 1023
                }

                if section == 0 {
                    var frame = attributes.frame
                    frame.origin.y = collectionView.contentOffset.y
                    attributes.frame = frame
                }
                if index == 0 {
                    var frame = attributes.frame
                    frame.origin.x = collectionView.contentOffset.x
                    attributes.frame = frame
                }
              
//              if section == 1 {
//                var frame = attributes.frame
//                frame.origin.y = frame.origin.y + 5
//                attributes.frame = frame
//              }
//
//              if index == 1 {
//                var frame = attributes.frame
//                frame.origin.x = frame.origin.x + 5
//                frame.size.width = frame.size.width + 5
//                attributes.frame = frame
//              }
                sectionAttributes.append(attributes)
              if index == 0 {
                xOffset += 5
              }
              if section == 0 {
                yOffset = 5
              }
                xOffset += itemSize.width
                column += 1

                if column == numberOfColumns {
                    if xOffset > contentWidth {
                        contentWidth = xOffset
                    }

                    column = 0
                    xOffset = 0
                    yOffset += itemSize.height
                  
                }
            }

            itemAttributes.append(sectionAttributes)
        }

        if let attributes = itemAttributes.last?.last {
            contentSize = CGSize(width: contentWidth+5, height: attributes.frame.maxY+5)
        }
    }

    func  calculateItemSizes() {
        itemsSize = []

        for index in 0..<numberOfColumns {
            itemsSize.append(sizeForItemWithColumnIndex(index))
        }
    }

    func sizeForItemWithColumnIndex(_ columnIndex: Int) -> CGSize {
        var text: NSString
      print("column \(columnIndex)")
        switch columnIndex {
        case 0:
            text = "MMM-99"

        default:
            text = "Content"
        }
      if columnIndex == 0 {
        return CGSize(width: 100, height: 75)
      }
      let size: CGSize = text.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0)])
        let width: CGFloat = size.width + 16
        return CGSize(width: 75, height: 75)
    }

}
