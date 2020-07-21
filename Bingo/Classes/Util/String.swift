/*
String.swift
Created by William Falcon on 2/15/15.

The MIT License (MIT)

Copyright (c) 2015 William Falcon
will@hacstudios.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import Foundation
import UIKit


/*
String for swift provides many of the String API convenience methods from javascript (and some from python).
*/
extension String
{
    /**
    Returns length of the string
    */
    public var length: Int
    {
        return self.count
    }
    
    //MARK: Subscripting
    /**
    Returns char at an index
    Example: string[0] == "a"
    */
    public subscript(idx: Int) -> Character
    {
        return self[index(startIndex, offsetBy: idx)]
    }
    
    /**
    Returns string at an index
    Example: string[0] == "a"
    */
    public subscript(index: Int) -> String
    {
        return String(self[index])
    }

    /**
    Returns string in a range
    Example: string[0...2] == "abc"
    */
    public subscript(range: Range<Int>) -> String
    {
        let start = self.index(self.startIndex, offsetBy: range.lowerBound)
        let end = self.index(self.startIndex, offsetBy: range.upperBound)
        return String(self[start ..< end])
    }
    
    //MARK: - Searching
    /**
    Searches a string for a match against a regular expression, and returns the matches
    */
    public func matchesForRegex(_ regex: String) -> [String]
    {
        var results: [String] = []
        let regex = try? NSRegularExpression(pattern: regex, options: NSRegularExpression.Options.caseInsensitive)
        
        if let matches = regex?.matches(in: self, options: [], range: NSMakeRange(0, self.length))
        {
            for m in matches
            {
                let match = self[m.range.location..<m.range.location+m.range.length]
                results.append(match)
            }
        }
        
        return results
    }

    /**
    Returns true if string contains input string
    */
    public func contains(_ s: String) -> Bool
    {
        return (self.range(of: s) != nil) ? true : false
    }
    
    //MARK: - Indexing
    /**
    Returns the position of the first found occurrence of a specified value in a string
    */
    public func indexOf(_ string: String?) -> Int?
    {
        var result: Int?
        
        if let string = string,
           let range = self.range(of: string)
        {
            result = self.distance(from: self.startIndex, to: range.lowerBound)
        }
        
        return result
    }
    
    public func indexOf(_ target: String, startIndex: Int) -> Int
    {
        let startRange = self.index(self.startIndex, offsetBy: startIndex)
        let temp: Range<String.Index> = startRange ..< self.endIndex

        if let range = self.range(of: target, options: NSString.CompareOptions.literal, range: temp)
        {
            return self.distance(from: self.startIndex, to: range.lowerBound)
        }
        else
        {
            return -1
        }
    }
    
    public func lastIndexOf(_ target: String) -> Int?
    {
        var index = -1
        var stepIndex = self.indexOf(target)
        
        while let step = stepIndex, step > -1
        {
            index = step
            if step + target.length < self.length
            {
                stepIndex = indexOf(target, startIndex: step + target.length)
            }
            else
            {
                stepIndex = -1
            }
        }
        
        return index
    }
    
    //MARK: - Substrings
    /**
    Extracts the characters from a string, after a specified index
    */
    public func substringFromIndex(_ index: Int) -> String?
    {
        var sub: String?
        
        if index <= self.length && index >= 0
        {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            sub = String(self[startIndex...])
        }
        
        return sub
    }
    
    /**
    Extracts the characters from a string, before a specified index
    */
    public func substringToIndex(_ index: Int) -> String?
    {
        var sub: String?
        
        if index <= self.length && index >= 0
        {
            let endIndex = self.index(self.startIndex, offsetBy: index)
            sub = String(self[..<endIndex])
        }
        
        return sub
    }
    
    /**
    Extracts a part of a string and returns a new string
    */
    public func substringFromIndex(_ index: Int, to: Int) -> String
    {
       return self[Range(index...to)]
    }
    
    /**
    Extracts a part of a string and returns a new string starting at an index and
    going for the length requested
    */
    public func substringFromIndex(_ index: Int, length: Int) -> String
    {
        return self[Range(index...(index+length - 1))]
    }
    
    /**
    Extracts a part of a string and returns a new string
    */
    public func slice(_ start: Int, end: Int) -> String
    {
        return self[Range(start...end)]
    }
    
    /**
    Splits a string into an array of substrings
    */
    public func splitOn(_ separator: String) -> [String]
    {
        let results = self.components(separatedBy: separator)
        return results
    }
    //MARK: - Formatting
    
    /**
    Searches a string for a specified value, or a regular expression, and returns a new string where the specified values are replaced. Can take in an regular expression
    */
    public func replaceAll(_ target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    /**
    Removes whitespace from both ends of a string
    */
    public func trim() -> String
    {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    /**
    Removes the last char of the string
    */
    public func trimLastChar() -> String
    {
        if self.length > 0
        {
            return self[0 ..< self.length-1]
        }
        else
        {
            return self
        }
    }
    
    /**
    Removes the first char of the string
    */
    public func trimFirstChar() -> String
    {
        if self.length > 0
        {
            return self[1 ..< self.length]
        }
        else
        {
            return self
        }
    }
    
    /**
    Reverses the string
    */
    public func reverse() -> String
    {
        var reversed = ""
        
        for i in (0 ..< self.length).reversed()
        {
            let char: String = self[i]
            reversed += char
        }
        
        return reversed
    }
    
    /**
    Separates string into an array of characters
    */
    public func toCharArray() -> [Character]
    {
        var chars = [Character]()
        
        for i in 0 ..< self.count
        {
            chars.append(self[i])
        }
        
        return chars
    }
}


extension String /// Format related
{
    public func formatPhoneNumber() -> String
    {
        var new_phone = ""
        let decCharSet = CharacterSet.decimalDigits
        
        for i in 0 ..< self.length
        {
            let number = self.substringFromIndex(i, length: 1)
            let strCharSet = CharacterSet(charactersIn: number)
            
            if decCharSet.isSuperset(of: strCharSet)
            {
                new_phone += number
            }
            else if number == "#" // extension number
            {
                break
            }
        }
        
        return new_phone
    }
    
    public var isValidEmail: Bool
    {
        var result = false
        
        if self.length > 0
        {
            // regular expression
            let regex = #"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}"#  // use raw string 
            let regexPred = NSPredicate(format: "SELF MATCHES %@", regex)
            result = regexPred.evaluate(with: self)
        }
        
        return result
    }
    
    public var isValidSSN: Bool
    {
        var valid = false
        
        if self.length > 0
        {
            // regular expression
            let regex = #"[a-zA-z]\d{9}"# // use raw string
            let regexPred = NSPredicate(format: "SELF MATCHES %@", regex)
            valid = regexPred.evaluate(with: self)
        }
        
        return valid
    }
}


extension String /// Sizing related
{
    /// returns size of string with a font
    public func sizeWithFont(_ font: UIFont) -> CGSize
    {
        let size = self.size(withAttributes: [NSAttributedString.Key.font: font])
        return size
    }
    
    /// returns size of string with a font
    public func sizeWithFont(_ font: UIFont, width: CGFloat) -> CGSize
    {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        
//        let ns = NSString(string: self)
//        let rect = ns.boundingRect(
//                   with: CGSize(width: width, height: CGFloat(MAXFLOAT)),
//                   options: .usesLineFragmentOrigin,
//                   attributes: [NSAttributedString.Key.font: font],
//                   context: nil)
        
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let requiredSize = label.sizeThatFits(maxSize)
        
        return requiredSize
    }
    
    public var utf8String: UnsafePointer<Int8>?
    {
        return (self as NSString).utf8String
    }
}


extension String /// File related
{
    public func toURL(_ encoding: Bool = true) -> URL?
    {
        var url: URL?
        
        if encoding
        {
            if let str = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
            {
                url = URL(string: str)
            }
        }
        else
        {
            url = URL(string: self)
        }
        
        return url
    }

    public var pathExtension: String?
    {
        return URL(fileURLWithPath: self).pathExtension
    }
    
    public var lastPathComponent: String?
    {
        return URL(fileURLWithPath: self).lastPathComponent
    }
    
    public func stringByAppendingPathComponent(_ pathComponent: String) -> String?
    {
        return URL(fileURLWithPath: self).appendingPathComponent(pathComponent).path
    }
    
    public var stringByDeletingLastPathComponent: String?
    {
        return NSURL(fileURLWithPath: self).deletingLastPathComponent?.path
    }
    
    public var stringByDeletingPathExtension: String?
    {
        return NSURL(fileURLWithPath: self).deletingPathExtension?.path
    }
}


extension String /// Numeric related
{
    public func intValue() -> Int?
    {
        if let i = Int(self)
        {
            return i
        }
        else
        {
            return nil
        }
    }
    
    public func longValue() -> Int64?
    {
        if let l = Int64(self)
        {
            return l
        }
        else
        {
            return nil
        }
    }
    
    public func floatValue() -> Float?
    {
        if let f = Float(self)
        {
            return f
        }
        else
        {
            return nil
        }
    }
    
    public func doubleValue() -> Double?
    {
        if let d = Double(self)
        {
            return d
        }
        else
        {
            return nil
        }
    }
}


extension String /// Localized related
{
    public static func localizedString(_ key: String) -> String
    {
        let localized = NSLocalizedString(key, comment: "")
        return localized
    }
    
    public static func localizedString(_ key: String, _ arguments: CVarArg...) -> String
    {
        return String(format: NSLocalizedString(key, comment: ""), locale: .current, arguments: arguments)
        //return String.localizedStringWithFormat(NSLocalizedString(key, comment: ""), arguments)
    }

    public init(localizedKey: String)
    {
        self = NSLocalizedString(localizedKey, comment: "")
    }
}


extension Int
{
    public func toString() -> String
    {
        return String(self)
    }
}

extension Int8
{
    public func toString() -> String
    {
        return String(self)
    }
}

extension UInt8
{
    public func toString() -> String
    {
        return String(self)
    }
}

extension Int16
{
    public func toString() -> String
    {
        return String(self)
    }
}

extension UInt16
{
    public func toString() -> String
    {
        return String(self)
    }
}

extension Int32
{
    public func toString() -> String
    {
        return String(self)
    }
}

extension UInt32
{
    public func toString() -> String
    {
        return String(self)
    }
}

extension Int64
{
    public func toString() -> String
    {
        return String(self)
    }
}

extension UInt64
{
    public func toString() -> String
    {
        return String(self)
    }
}

extension Float
{
    public func toString() -> String
    {
        return String(self)
    }
    
    public var cleanString: String
    {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

extension Double
{
    public func toString() -> String
    {
        return String(self)
    }
    
    public var cleanString: String
    {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
