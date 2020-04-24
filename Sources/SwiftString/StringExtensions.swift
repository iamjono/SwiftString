//
//  SwiftString.swift
//  SwiftString
//
//  Created by Andrew Mayne on 30/01/2016.
//  Copyright © 2016 Red Brick Labs. All rights reserved.
//
import Foundation

public extension String {

    ///  Finds the string between two bookend strings if it can be found.
    ///
    ///  - parameter left:  The left bookend
    ///  - parameter right: The right bookend
    ///
    ///  - returns: The string between the two bookends, or nil if the bookends cannot be found, the bookends are the same or appear contiguously.
    func between(_ left: String, _ right: String) -> String? {
        guard
            let leftRange = range(of:left), let rightRange = range(of: right, options: .backwards),
				left != right && leftRange.upperBound != rightRange.lowerBound
            else { return nil }

		return String(self[leftRange.upperBound...index(before: rightRange.lowerBound)])

    }
    
    // https://gist.github.com/stevenschobert/540dd33e828461916c11
    func camelize() -> String {
        let source = clean(with: " ", allOf: "-", "_")
        if source.contains(" ") {
			let first = self[self.startIndex...self.index(after: startIndex)] //source.substringToIndex(source.index(after: startIndex))
			let cammel = source.capitalized.replacingOccurrences(of: " ", with: "")
//            let cammel = String(format: "%@", strip)
            let rest = String(cammel.dropFirst())
            return "\(first)\(rest)"
        } else {
			let first = source[self.startIndex...self.index(after: startIndex)].lowercased()
            let rest = String(source.dropFirst())
            return "\(first)\(rest)"
        }
    }
    
    func capitalize() -> String {
        return capitalized
    }
    
//    func contains(_ substring: String) -> Bool {
//        return range(of: substring) != nil
//    }

    func chompLeft(_ prefix: String) -> String {
        if let prefixRange = range(of: prefix) {
            if prefixRange.upperBound >= endIndex {
				return String(self[startIndex..<prefixRange.lowerBound])
            } else {
				return String(self[prefixRange.upperBound..<endIndex])
            }
        }
        return self
    }
    
    func chompRight(_ suffix: String) -> String {
		if let suffixRange = range(of: suffix, options: .backwards) {
            if suffixRange.upperBound >= endIndex {
				return String(self[startIndex..<suffixRange.lowerBound])
            } else {
				return String(self[suffixRange.upperBound..<endIndex])
            }
        }
        return self
    }
    
    func collapseWhitespace() -> String {
        let thecomponents = components(separatedBy: NSCharacterSet.whitespacesAndNewlines).filter { !$0.isEmpty }
        return thecomponents.joined(separator: " ")
    }
    
    func clean(with: String, allOf: String...) -> String {
        var string = self
        for target in allOf {
            string = string.replacingOccurrences(of: target, with: with)
        }
        return string
    }
    
    func count(_ substring: String) -> Int {
        return components(separatedBy: substring).count-1
    }
    
    func endsWith(_ suffix: String) -> Bool {
        return hasSuffix(suffix)
    }
    
    func ensureLeft(_ prefix: String) -> String {
        if startsWith(prefix) {
            return self
        } else {
            return "\(prefix)\(self)"
        }
    }
    
    func ensureRight(_ suffix: String) -> String {
        if endsWith(suffix) {
            return self
        } else {
            return "\(self)\(suffix)"
        }
    }
    
    @available(*, deprecated, message: "Use `index(of:)` instead")
    func indexOf(_ substring: String) -> Int? {
        if let range = range(of: substring) {
			return self.distance(from: startIndex, to: range.lowerBound)
//            return startIndex.distanceTo(range.lowerBound)
        }
        return nil
    }
    
    func initials() -> String {
        let words = self.components(separatedBy: " ")
		return words.reduce(""){$0 + $1[startIndex...startIndex]}
//		return words.reduce(""){$0 + $1[0...0]}
    }
    
    func initialsFirstAndLast() -> String {
		let words = self.components(separatedBy: " ")
		return words.reduce("") { ($0 == "" ? "" : String($0[startIndex...startIndex])) + $1[startIndex...startIndex]}
    }
    
    func isAlpha() -> Bool {
        for chr in self {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                return false
            }
        }
        return true
    }
    
    func isAlphaNumeric() -> Bool {
        let alphaNumeric = NSCharacterSet.alphanumerics
		let output = self.unicodeScalars.split { !alphaNumeric.contains($0)}.map(String.init)
		if output.count == 1 {
			if output[0] != self {
				return false
			}
		}
		return output.count == 1
//        return componentsSeparatedByCharactersInSet(alphaNumeric).joinWithSeparator("").length == 0
    }
    
    func isEmpty() -> Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).length == 0
    }
    
    func isNumeric() -> Bool {
        if let _ = defaultNumberFormatter().number(from: self) {
            return true
        }
        return false
    }
    
    private func join<S: Sequence>(_ elements: S) -> String {
        return elements.map{String(describing: $0)}.joined(separator: self)
    }

    func latinize() -> String {
        return self.folding(options: .diacriticInsensitive, locale: .current)
//		stringByFoldingWithOptions(.DiacriticInsensitiveSearch, locale: NSLocale.currentLocale())
    }
    
    func lines() -> [String] {
        return self.components(separatedBy: NSCharacterSet.newlines)
    }
    
    var length: Int {
        get {
            return self.count
        }
    }
    
    func pad(_ n: Int, _ string: String = " ") -> String {
        return "".join([string.times(n), self, string.times(n)])
    }
    
    func padLeft(_ n: Int, _ string: String = " ") -> String {
        return "".join([string.times(n), self])
    }
    
    func padRight(_ n: Int, _ string: String = " ") -> String {
        return "".join([self, string.times(n)])
    }
    
    func slugify(withSeparator separator: Character = "-") -> String {
        let slugCharacterSet = NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789\(separator)")
        return latinize()
            .lowercased()
            .components(separatedBy: slugCharacterSet.inverted)
            .filter { $0 != "" }
            .joined(separator: String(separator))
    }

	/// split the string into a string array by white spaces
	func tokenize() -> [String] {
		return self.components(separatedBy: .whitespaces)
	}

    func split(_ separator: Character = " ") -> [String] {
        return self.split{$0 == separator}.map(String.init)
    }
    
    func startsWith(_ prefix: String) -> Bool {
        return hasPrefix(prefix)
    }

    func stripPunctuation() -> String {
        return components(separatedBy: .punctuationCharacters)
            .joined(separator: "")
            .components(separatedBy: " ")
            .filter { $0 != "" }
            .joined(separator: " ")
    }
    
    func times(_ n: Int) -> String {
		var x = self
		for _ in 1..<n {
			x += self
		}
		return x
//        return (0..<n).reduce("") { $0.0 + self }
    }
    
    func toFloat() -> Float? {
        if let number = defaultNumberFormatter().number(from: self) {
            return number.floatValue
        }
        return nil
    }
    
    func toInt() -> Int? {
        if let number = defaultNumberFormatter().number(from: self) {
            return number.intValue
        }
        return nil
    }
        
    func toBool() -> Bool? {
        let trimmed = self.trimmed().lowercased()
		if Int(trimmed) != 0 {
			return true
		}
		switch trimmed {
		case "true", "yes", "1":
			return true
		case "false", "no", "0":
			return false
		default:
			return false
		}
    }

    func toDate(_ format: String = "yyyy-MM-dd") -> Date? {
        return dateFormatter(format).date(from: self) as Date?
    }
    
    func toDateTime(_ format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        return toDate(format)
    }
    
    func trimmedLeft() -> String {
        if let range = rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines.inverted) {
			return String(self[range.lowerBound..<endIndex])
        }
        return self
    }
    
    func trimmedRight() -> String {
        if let range = rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines.inverted, options: NSString.CompareOptions.backwards) {
			return String(self[startIndex..<range.upperBound])
        }
        return self
    }
    
    func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    subscript(_ r: CountableRange<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
			return String(self[startIndex..<endIndex])
        }
    }
    
    subscript(_ range: CountableClosedRange<Int>) -> String {
        get {
            return self[range.lowerBound..<range.upperBound + 1]
        }
    }
    
    subscript(safe range: CountableRange<Int>) -> String {
        get {
            if length == 0 { return "" }
            let lower = range.lowerBound < 0 ? 0 : range.lowerBound
            let upper = range.upperBound < 0 ? 0 : range.upperBound
            let s = index(startIndex, offsetBy: lower, limitedBy: endIndex) ?? endIndex
            let e = index(startIndex, offsetBy: upper, limitedBy: endIndex) ?? endIndex
			return String(self[s..<e])
        }
    }
    
    subscript(safe range: CountableClosedRange<Int>) -> String {
        get {
            if length == 0 { return "" }
            let closedEndIndex = index(endIndex, offsetBy: -1, limitedBy: startIndex) ?? startIndex
            let lower = range.lowerBound < 0 ? 0 : range.lowerBound
            let upper = range.upperBound < 0 ? 0 : range.upperBound
            let s = index(startIndex, offsetBy: lower, limitedBy: closedEndIndex) ?? closedEndIndex
            let e = index(startIndex, offsetBy: upper, limitedBy: closedEndIndex) ?? closedEndIndex
			return String(self[s...e])
        }
    }
    
    func substring(_ startIndex: Int, length: Int) -> String {
        let start = self.index(self.startIndex, offsetBy: startIndex)
        let end = self.index(self.startIndex, offsetBy: startIndex + length)
		return String(self[start..<end])
    }
    
    subscript(i: Int) -> Character {
        get {
            let index = self.index(self.startIndex, offsetBy: i)
            return self[index]
        }
    }

//	/// get the left part of the string before the index
//	func left(_ range:Range<String.Index>?) -> String {
//		return self.substring(to: (range?.lowerBound)!)
//	}
//	/// get the right part of the string after the index
//	func right(_ range:Range<String.Index>?) -> String {
//		return self.substring(from: self.index((range?.lowerBound)!, offsetBy:1))
//	}
	
	/// The first index of the given string
	func indexRaw(of str: String, after: Int = 0, options: String.CompareOptions = .literal, locale: Locale? = nil) -> String.Index? {
		guard str.length > 0 else {
			// Can't look for nothing
			return nil
		}
		guard (str.length + after) <= self.length else {
			// Make sure the string you're searching for will actually fit
			return nil
		}
		
		let startRange = self.index(self.startIndex, offsetBy: after)..<self.endIndex
		return self.range(of: str, options: options.removing(.backwards), range: startRange, locale: locale)?.lowerBound
	}
	
	func index(of str: String, after: Int = 0, options: String.CompareOptions = .literal, locale: Locale? = nil) -> Int {
		guard let index = indexRaw(of: str, after: after, options: options, locale: locale) else {
			return -1
		}
		return self.distance(from: self.startIndex, to: index)
	}
	
	/// The last index of the given string
	func lastIndexRaw(of str: String, before: Int = 0, options: String.CompareOptions = .literal, locale: Locale? = nil) -> String.Index? {
		guard str.length > 0 else {
			// Can't look for nothing
			return nil
		}
		guard (str.length + before) <= self.length else {
			// Make sure the string you're searching for will actually fit
			return nil
		}
		
		let startRange = self.startIndex..<self.index(self.endIndex, offsetBy: -before)
		return self.range(of: str, options: options.inserting(.backwards), range: startRange, locale: locale)?.lowerBound
	}
	
	func lastIndex(of str: String, before: Int = 0, options: String.CompareOptions = .literal, locale: Locale? = nil) -> Int {
		guard let index = lastIndexRaw(of: str, before: before, options: options, locale: locale) else {
			return -1
		}
		return self.distance(from: self.startIndex, to: index)
	}

}

private enum ThreadLocalIdentifier {
    case dateFormatter(String)

    case defaultNumberFormatter
    case localeNumberFormatter(Locale)

    var objcDictKey: String {
        switch self {
        case .dateFormatter(let format):
            return "SS\(self)\(format)"
        case .localeNumberFormatter(let l):
            return "SS\(self)\(l.identifier)"
        default:
            return "SS\(self)"
        }
    }
}

private func threadLocalInstance<T: AnyObject>(_ identifier: ThreadLocalIdentifier, initialValue: @autoclosure () -> T) -> T {
	#if os(Linux)
		var storage = Thread.current.threadDictionary
	#else
		let storage = Thread.current.threadDictionary
	#endif
    let k = identifier.objcDictKey

    let instance: T = storage[k] as? T ?? initialValue()
    if storage[k] == nil {
        storage[k] = instance
    }

    return instance
}

private func dateFormatter(_ format: String) -> DateFormatter {
    return threadLocalInstance(.dateFormatter(format), initialValue: {
        let df = DateFormatter()
        df.dateFormat = format
        return df
    }())
}

private func defaultNumberFormatter() -> NumberFormatter {
    return threadLocalInstance(.defaultNumberFormatter, initialValue: NumberFormatter())
}

private func localeNumberFormatter(_ locale: Locale) -> NumberFormatter {
    return threadLocalInstance(.localeNumberFormatter(locale), initialValue: {
        let nf = NumberFormatter()
        nf.locale = locale
        return nf
    }())
}

/// Add the `inserting` and `removing` functions
private extension OptionSet where Element == Self {
	/// Duplicate the set and insert the given option
	func inserting(_ newMember: Self) -> Self {
		var opts = self
		opts.insert(newMember)
		return opts
	}
	
	/// Duplicate the set and remove the given option
	func removing(_ member: Self) -> Self {
		var opts = self
		opts.remove(member)
		return opts
	}
}

public extension String {

	func isValidEmail() -> Bool {
		#if os(Linux) && !swift(>=3.1)
			let regex = try? RegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
		#else
			let regex = try? NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
		#endif
		return regex?.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil
	}


	/// Encode a String to Base64
	func toBase64() -> String {
		return Data(self.utf8).base64EncodedString()
	}

	/// Decode a String from Base64. Returns nil if unsuccessful.
	func fromBase64() -> String? {
		guard let data = Data(base64Encoded: self) else { return nil }
		return String(data: data, encoding: .utf8)
	}
}

