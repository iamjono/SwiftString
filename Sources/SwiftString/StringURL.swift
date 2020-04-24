//
//  StringHTTP.swift
//  SwiftString
//
//  Created by thislooksfun on 1/3/17.
//
//

import Foundation

private let parentBacktrackRegex = "([^/]*)?\\/+\\.\\."
public extension String {
	/// The parent directory or url
	/// i.e. calling `"/foo/bar/baz".parent` will return `"/foo/bar"`
	var parent: String? {
		var ref = self
		if self.lastIndex(of: "/") == self.length - 1 {
			ref = self[0..<self.length - 1]
		}
		
		let index = ref.lastIndex(of: "/")
		if index > -1 {
			return ref[0..<index]
		}
		return nil
	}
	/// The full file or directory name and extension
	/// i.e. calling `"/foo/bar/baz.txt".file` will return `"baz.txt"`
	var file: String? {
		var ref = self
		if self.lastIndex(of: "/") == self.length - 1 {
			ref = self[0..<self.length - 1]
		}
		
		let index = ref.lastIndex(of: "/")
		if index > -1 {
			print(index, self.length)
			return ref[index+1..<ref.length]
		}
		return nil
	}
	/// The file or directory name without extension
	/// i.e. calling `"/foo/bar/baz.txt".file` will return `"baz"`
	var fileName: String? {
		guard let f = file else {
			return nil
		}
		
		let index = f.lastIndex(of: ".")
		if index > -1 {
			return f[0..<index]
		}
		return file
	}
	/// The file or directory extension
	/// i.e. calling `"/foo/bar/baz.txt".file` will return `"txt"`
	var `extension`: String? {
		guard let f = file else {
			return nil
		}
		
		let index = f.lastIndex(of: ".")
		if index > -1 {
			return f[index+1..<f.length]
		}
		return nil
	}
	
	/// The file path, but removing all double slashes (//) and resolving 'back' paths (..)
	/// i.e. calling `cleanPath` on `"/foo///bar/baz/../thing.txt"` would result in `"/foo/bar/thing.txt"`
	mutating func cleanPath() {
		self = cleanedPath()
	}
	/// The file path, but removing all double slashes (//) and resolving 'back' paths (..)
	/// i.e. calling `"/foo///bar/baz/../thing.txt".cleanedPath()` would return `"/foo/bar/thing.txt"`
	func cleanedPath() -> String {
		// Remove duplicate slashes
		var str = self
		while str.contains("//") {
			str = str.replacingOccurrences(of: "//", with: "/")
		}
		// Parse `..`s
		while let range = str.range(of: parentBacktrackRegex, options: .regularExpression) {
			str.removeSubrange(range)
		
			while str.contains("//") {
				str = str.replacingOccurrences(of: "//", with: "/")
			}
		}
		return str
	}
	
	/// Join a series of paths together with this as the base
	/// i.e. calling `"/foo".join("bar/", "../baz.txt")` will result in `"/foo/baz.txt"`
	/// Note: This calls `cleanPath()`, so there is no need to do that yourself
	mutating func join(_ paths: String...) {
		join(paths: paths)
	}
	/// Join an array of paths together with this as the base
	/// i.e. calling `"/foo".join(paths: ["bar/", "../baz.txt"])` will result in `"/foo/baz.txt"`
	/// Note: This calls `cleanPath()`, so there is no need to do that yourself
	mutating func join(paths: [String]) {
		for path in paths {
			self += "/\(path)"
		}
		self.cleanPath()
	}
	
	/// Join a series of paths together with this as the base, and return it
	/// i.e. calling `"/foo".joining("bar/", "../baz.txt")` will return `"/foo/baz.txt"`
	/// Note: This calls `cleanPath()`, so there is no need to do that yourself
	func joining(_ paths: String...) -> String {
		return joining(paths: paths)
	}
	/// Join an array of paths together with this as the base, and return it
	/// i.e. calling `"/foo".joining(paths: ["bar/", "../baz.txt"])` will return `"/foo/baz.txt"`
	/// Note: This calls `cleanPath()`, so there is no need to do that yourself
	func joining(paths: [String]) -> String {
		var tmp = self
		tmp.join(paths: paths)
		return tmp
	}
}
