//
//  Extensions.swift
//  Listio
//
//  Created by Felipe Dias Pereira on 2016-06-03.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import UIKit

// MARK: JWT Secret key
let jwtSecretKey:String = "felipe.com.br.plantinfo.5939854fe"

// MARK: URL Base
let urlBase:String = "http://localhost:3000"

// MARK: EndPoints
let endPointAllProducts:String = "/api/plants/identification"

let monthsName: [Int:String] = [1:"JAN",2:"FEV",3:"MAR",4:"ABR",5:"MAIO",6:"JUN",7:"JUL",8:"AGO",9:"SET",10:"OUT",11:"NOV",12:"DEZ"]

struct PredictInfo {
    var nid:String!
    var probability:String!
}

func getDocumentsURL() -> NSURL {
    let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
    return documentsURL
}

func fileInDocumentsDirectory(filename: String) -> String {
    
    let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
    return fileURL.path!
    
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func randomColor() -> UIColor {
        let r = CGFloat.random()
        let g = CGFloat.random()
        let b = CGFloat.random()
        
        // If you wanted a random alpha, just create another
        // random number for that too.
        return UIColor(red: r, green: g, blue: b, alpha: 2.5)
    }
    class func hex (hexStr : NSString, alpha : CGFloat) -> UIColor {
        
        let realHexStr = hexStr.stringByReplacingOccurrencesOfString("#", withString: "")
        let scanner = NSScanner(string: realHexStr as String)
        var color: UInt32 = 0
        if scanner.scanHexInt(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            print("invalid hex string", terminator: "")
            return UIColor.whiteColor()
        }
    }
}

extension NSDate {
    func getComponent(component:NSCalendarUnit) -> Int?{
        if
            let cal: NSCalendar = NSCalendar.currentCalendar(){
            return cal.component(component, fromDate: self)
        } else {
            return nil
        }
    }
}

extension NSNumber {
    func toMaskReais() ->String?{
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "pt_BR")
        return formatter.stringFromNumber(self)
    }
    func maskToCurrency() ->String?{
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyAccountingStyle
        return formatter.stringFromNumber(self)
    }
}

extension Int
{
    static func random(range: Range<Int> ) -> Int
    {
        var offset = 0
        
        if range.startIndex < 0   // allow negative ranges
        {
            offset = abs(range.startIndex)
        }
        
        let mini = UInt32(range.startIndex + offset)
        let maxi = UInt32(range.endIndex   + offset)
        
        return Int(mini + arc4random_uniform(maxi - mini)) - offset
    }
}

func flatten<T>(a: [[T]]) -> [T] {
    return a.reduce([]) {
        res, ca in
        return res + ca
    }
}

extension String
{
    func trim() -> String
    {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    func removeSpaces() -> String
    {
        return self.stringByReplacingOccurrencesOfString(" ", withString: "")
    }
}

public protocol Groupable {
    func sameGroupAs(otherPerson: Self) -> Bool
}


extension CollectionType where Self.Generator.Element: Groupable {
    
    public func group() -> [[Self.Generator.Element]] {
        return self.groupBy { $0.sameGroupAs($1) }
    }
    
}

extension CollectionType where Self.Generator.Element: Comparable {
    
    public func uniquelyGroupBy(grouper: (Self.Generator.Element, Self.Generator.Element) -> Bool) -> [[Self.Generator.Element]] {
        let sorted = self.sort()
        return sorted.groupBy(grouper)
    }
    
}

extension CollectionType {
    
    public typealias ItemType = Self.Generator.Element
    public typealias Grouper = (ItemType, ItemType) -> Bool
    
    public func groupBy(grouper: Grouper) -> [[ItemType]] {
        var result : Array<Array<ItemType>> = []
        
        var previousItem: ItemType?
        var group = [ItemType]()
        
        for item in self {
            // Current item will be the next item
            defer {previousItem = item}
            
            // Check if it's the first item
            guard let previous = previousItem else {
                group.append(item)
                continue
            }
            
            if grouper(previous, item) {
                // Item in the same group
                group.append(item)
            } else {
                // New group
                result.append(group)
                group = [ItemType]()
                group.append(item)
            }
        }
        
        result.append(group)
        
        return result
    }
    
}

extension SequenceType where Generator.Element: Equatable {
    func containsObject(val: Self.Generator.Element?) -> Bool {
        if val != nil {
            for item in self {
                if item == val {
                    return true
                }
            }
        }
        return false
    }
}

extension SequenceType where Generator.Element: AnyObject {
    func containsObject(obj: Self.Generator.Element?) -> Bool {
        if obj != nil {
            for item in self {
                if item === obj {
                    return true
                }
            }
        }
        return false
    }
}

public extension SequenceType {
    
    /// Categorises elements of self into a dictionary, with the keys given by keyFunc
    
    func categorise<U : Hashable>(@noescape keyFunc: Generator.Element -> U) -> [U:[Generator.Element]] {
        var dict: [U:[Generator.Element]] = [:]
        for el in self {
            let key = keyFunc(el)
            if case nil = dict[key]?.append(el) { dict[key] = [el] }
        }
        return dict
    }
}


extension NSDate {
    func yearsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
    func offsetFrom(date:NSDate) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
}

extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
}