/*
* Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>. 
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
*	*	Redistributions of source code must retain the above copyright notice, this
*		list of conditions and the following disclaimer.
*
*	*	Redistributions in binary form must reproduce the above copyright notice,
*		this list of conditions and the following disclaimer in the documentation
*		and/or other materials provided with the distribution.
*
*	*	Neither the name of GraphKit nor the names of its
*		contributors may be used to endorse or promote products derived from
*		this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

public class SortedMultiSet<Element : Comparable> : ProbableType, CollectionType, Comparable, Equatable, CustomStringConvertible {
	public typealias Generator = AnyGenerator<Element>
	
	/**
	Total number of elements within the RedBlackTree
	*/
	public internal(set) var count: Int = 0
	
	/**
		:name:	tree
		:description:	Internal storage of elements.
		- returns:	RedBlackTree<Element, Element>
	*/
	internal var tree: RedBlackTree<Element, Element>

	/**
		:name:	asArray
	*/
	public var asArray: Array<Element> {
		var a: Array<Element> = Array<Element>()
		for x in self {
			a.append(x)
		}
		return a
	}
	
	/**
		:name:	description
		:description:	Conforms to the Printable Protocol. Outputs the
		data in the SortedMultiSet in a readable format.
		- returns:	String
	*/
	public var description: String {
		var output: String = "["
		for var i: Int = 0, l = count - 1; i <= l; ++i {
			output += "\(self[i])"
			if i != l {
				output += ", "
			}
		}
		return output + "]"
	}

	/**
		:name:	first
		:description:	Get the first node value in the tree, this is
		the first node based on the order of keys where
		k1 <= k2 <= K3 ... <= Kn
		- returns:	Element?
	*/
	public var first: Element? {
		return tree.first?.value
	}

	/**
		:name:	last
		:description:	Get the last node value in the tree, this is
		the last node based on the order of keys where
		k1 <= k2 <= K3 ... <= Kn
		- returns:	Element?
	*/
	public var last: Element? {
		return tree.last?.value
	}

	/**
		:name:	isEmpty
		:description:	A boolean of whether the RedBlackTree is empty.
		- returns:	Bool
	*/
	public var isEmpty: Bool {
		return 0 == count
	}

	/**
		:name:	startIndex
		:description:	Conforms to the CollectionType Protocol.
		- returns:	Int
	*/
	public var startIndex: Int {
		return 0
	}

	/**
		:name:	endIndex
		:description:	Conforms to the CollectionType Protocol.
		- returns:	Int
	*/
	public var endIndex: Int {
		return count
	}

	/**
		:name:	init
		:description:	Constructor
	*/
	public init() {
		tree = RedBlackTree<Element, Element>(uniqueKeys: false)
	}

	/**
		:name:	init
		:description:	Constructor
	*/
	public convenience init(elements: Element...) {
		self.init(elements: elements)
	}

	/**
		:name:	init
		:description:	Constructor
	*/
	public convenience init(elements: Array<Element>) {
		self.init()
		insert(elements)
	}

	//
	//	:name:	generate
	//	:description:	Conforms to the SequenceType Protocol. Returns
	//	the next value in the sequence of nodes using
	//	index values [0...n-1].
	//	:returns:	SortedMultiSet.Generator
	//	
	public func generate() -> SortedMultiSet.Generator {
		var index = startIndex
		return anyGenerator {
			if index < self.endIndex {
				return self[index++]
			}
			return nil
		}
	}

	/**
	Conforms to ProbableType protocol.
	*/
	public func countOf<T: Equatable>(keys: T...) -> Int {
		return countOf(keys)
	}
	
	/**
	Conforms to ProbableType protocol.
	*/
	public func countOf<T: Equatable>(keys: Array<T>) -> Int {
		return tree.countOf(keys)
	}
	
	/**
	The probability of elements.
	*/
	public func probabilityOf<T: Equatable>(elements: T...) -> Double {
		return probabilityOf(elements)
	}
	
	/**
	The probability of elements.
	*/
	public func probabilityOf<T: Equatable>(elements: Array<T>) -> Double {
		return tree.probabilityOf(elements)
	}
	
	/**
	The probability of elements.
	*/
	public func probabilityOf(block: (element: Element) -> Bool) -> Double {
		if 0 == count {
			return 0
		}
		
		var c: Int = 0
		for x in self {
			if block(element: x) {
				++c
			}
		}
		return Double(c) / Double(count)
	}
	
	/**
	The expected value of elements.
	*/
	public func expectedValueOf<T: Equatable>(trials: Int, elements: T...) -> Double {
		return expectedValueOf(trials, elements: elements)
	}
	
	/**
	The expected value of elements.
	*/
	public func expectedValueOf<T: Equatable>(trials: Int, elements: Array<T>) -> Double {
		return tree.expectedValueOf(trials, elements: elements)
	}
	
	/**
		:name:	operator [0...count - 1]
		:description:	Allows array like access of the index.
		Items are kept in order, so when iterating
		through the items, they are returned in their
		ordered form.
		- returns:	Element
	*/
	public subscript(index: Int) -> Element {
		return tree[index].key
	}

	/**
		:name:	indexOf
		:description:	Returns the Index of a given member, or -1 if the member is not present in the set.
		- returns:	Int
	*/
	public func indexOf(element: Element) -> Int {
		return tree.indexOf(element)
	}
	
	/**
		:name:	contains
		:description:	A boolean check if values exists
		in the set.
		- returns:	Bool
	*/
	public func contains(elements: Element...) -> Bool {
		return contains(elements)
	}
	
	/**
		:name:	contains
		:description:	A boolean check if an array of values exist
		in the set.
		- returns:	Bool
	*/
	public func contains(elements: Array<Element>) -> Bool {
		if 0 == elements.count {
			return false
		}
		for x in elements {
			if nil == tree.findValueForKey(x) {
				return false
			}
		}
		return true
	}
	
	/**
		:name:	insert
		:description:	Inserts new elements into the SortedMultiSet.
	*/
	public func insert(elements: Element...) {
		insert(elements)
	}

	/**
		:name:	insert
		:description:	Inserts new elements into the SortedMultiSet.
	*/
	public func insert(elements: Array<Element>) {
		for x in elements {
			tree.insert(x, value: x)
		}
		count = tree.count
	}

	/**
		:name:	remove
		:description:	Removes elements from the SortedMultiSet.
	*/
	public func remove(elements: Element...) {
		remove(elements)
	}

	/**
		:name:	remove
		:description:	Removes elements from the SortedMultiSet.
	*/
	public func remove(elements: Array<Element>) {
		tree.removeValueForKeys(elements)
		count = tree.count
	}

	/**
		:name:	removeAll
		:description:	Remove all nodes from the tree.
	*/
	public func removeAll() {
		tree.removeAll()
		count = tree.count
	}

	/**
		:name:	intersect
		:description:	Return a new set with elements common to this set and a finite sequence of Sets.
		- returns:	SortedMultiSet<Element>
	*/
	public func intersect(set: SortedMultiSet<Element>) -> SortedMultiSet<Element> {
		let s: SortedMultiSet<Element> = SortedMultiSet<Element>()
		var i: Int = 0
		var j: Int = 0
		let k: Int = count
		let l: Int = set.count
		while k > i && l > j {
			let x: Element = self[i]
			let y: Element = set[j]
			if x < y {
				++i
			} else if y < x {
				++j
			} else {
				s.insert(x)
				++i
				++j
			}
		}
		return s
	}
	
	/**
		:name:	intersectInPlace
		:description:	Insert elements of a finite sequence of Sets.
	*/
	public func intersectInPlace(set: SortedMultiSet<Element>) {
		let l = set.count
		if 0 == l {
			removeAll()
		} else {
			var i: Int = 0
			var j: Int = 0
			while count > i && l > j {
				let x: Element = self[i]
				let y: Element = set[j]
				if x < y {
					tree.removeInstanceValueForKey(x)
					count = tree.count
				} else if y < x {
					++j
				} else {
					++i
					++j
				}
			}
		}
	}
	
	/**
		:name:	union
		:description:	Return a new Set with items in both this set and a finite sequence of Sets.
		- returns:	SortedMultiSet<Element>
	*/
	public func union(set: SortedMultiSet<Element>) -> SortedMultiSet<Element> {
		let s: SortedMultiSet<Element> = SortedMultiSet<Element>()
		var i: Int = 0
		var j: Int = 0
		let k: Int = count
		let l: Int = set.count
		while k > i && l > j {
			let x: Element = self[i]
			let y: Element = set[j]
			if x < y {
				s.insert(x)
				++i
			} else if y < x {
				s.insert(y)
				++j
			} else {
				s.insert(x)
				++i
				++j
			}
		}
		while k > i {
			s.insert(self[i++])
		}
		while l > j {
			s.insert(set[j++])
		}
		return s
	}
	
	/**
		:name:	unionInPlace
		:description:	Return a new Set with items in both this set and a finite sequence of Sets.
	*/
	public func unionInPlace(set: SortedMultiSet<Element>) {
		var i: Int = 0
		var j: Int = 0
		let l: Int = set.count
		while count > i && l > j {
			let x: Element = self[i]
			let y: Element = set[j]
			if x < y {
				++i
			} else if y < x {
				insert(y)
				++j
			} else {
				++i
				++j
			}
		}
		while l > j {
			insert(set[j++])
		}
	}
	
	/**
		:name:	subtract
		:description:	Return a new set with elements in this set that do not occur in a finite sequence of Sets.
		- returns:	SortedMultiSet<Element>
	*/
	public func subtract(set: SortedMultiSet<Element>) -> SortedMultiSet<Element> {
		let s: SortedMultiSet<Element> = SortedMultiSet<Element>()
		var i: Int = 0
		var j: Int = 0
		let k: Int = count
		let l: Int = set.count
		while k > i && l > j {
			let x: Element = self[i]
			let y: Element = set[j]
			if x < y {
				s.insert(x)
				++i
			} else if y < x {
				++j
			} else {
				++i
				++j
			}
		}
		while k > i {
			s.insert(self[i++])
		}
		return s
	}
	
	/**
		:name:	subtractInPlace
		:description:	Remove all elements in the set that occur in a finite sequence of Sets.
	*/
	public func subtractInPlace(set: SortedMultiSet<Element>) {
		var i: Int = 0
		var j: Int = 0
		let l: Int = set.count
		while count > i && l > j {
			let x: Element = self[i]
			let y: Element = set[j]
			if x < y {
				++i
			} else if y < x {
				++j
			} else {
				tree.removeInstanceValueForKey(x)
				count = tree.count
				++j
			}
		}
	}
	
	/**
		:name:	exclusiveOr
		:description:	Return a new set with elements that are either in the set or a finite sequence but do not occur in both.
		- returns:	SortedMultiSet<Element>
	*/
	public func exclusiveOr(set: SortedMultiSet<Element>) -> SortedMultiSet<Element> {
		let s: SortedMultiSet<Element> = SortedMultiSet<Element>()
		var i: Int = 0
		var j: Int = 0
		let k: Int = count
		let l: Int = set.count
		while k > i && l > j {
			let x: Element = self[i]
			let y: Element = set[j]
			if x < y {
				s.insert(x)
				++i;
			} else if y < x {
				s.insert(y)
				++j
			} else {
				i += countOf(x)
				j += set.countOf(y)
			}
		}
		while k > i {
			s.insert(self[i++])
		}
		while l > j {
			s.insert(set[j++])
		}
		return s
	}
	
	/**
		:name:	exclusiveOrInPlace
		:description:	For each element of a finite sequence, remove it from the set if it is a
		common element, otherwise add it to the set. Repeated elements of the sequence will be
		ignored.
	*/
	public func exclusiveOrInPlace(set: SortedMultiSet<Element>) {
		var i: Int = 0
		var j: Int = 0
		let l: Int = set.count
		while count > i && l > j {
			let x: Element = self[i]
			let y: Element = set[j]
			if x < y {
				++i
			} else if y < x {
				insert(y)
				++j
			} else {
				remove(x)
				++j
			}
		}
		while l > j {
			insert(set[j++])
		}
	}
	
	/**
		:name:	isDisjointWith
		:description:	Returns true if no elements in the set are in a finite sequence of Sets.
		- returns:	Bool
	*/
	public func isDisjointWith(set: SortedMultiSet<Element>) -> Bool {
		var i: Int = count - 1
		var j: Int = set.count - 1
		while 0 <= i && 0 <= j {
			let x: Element = self[i]
			let y: Element = set[j]
			if x < y {
				--j
			} else if y < x {
				--i
			} else {
				return false
			}
		}
		return true
	}
	
	/**
		:name:	isSubsetOf
		:description:	Returns true if the set is a subset of a finite sequence as a Set.
		- returns:	Bool
	*/
	public func isSubsetOf(set: SortedMultiSet<Element>) -> Bool {
		if count > set.count {
			return false
		}
		for x in self {
			if !set.contains(x) {
				return false
			}
		}
		return true
	}
	
	/**
		:name:	isStrictSubsetOf
		:description:	Returns true if the set is a subset of a finite sequence as a Set but not equal.
		- returns:	Bool
	*/
	public func isStrictSubsetOf(set: SortedMultiSet<Element>) -> Bool {
		return count < set.count && isSubsetOf(set)
	}
	
	/**
		:name:	isSupersetOf
		:description:	Returns true if the set is a superset of a finite sequence as a Set.
		- returns:	Bool
	*/
	public func isSupersetOf(set: SortedMultiSet<Element>) -> Bool {
		if count < set.count {
			return false
		}
		for x in set {
			if !contains(x) {
				return false
			}
		}
		return true
	}
	
	/**
		:name:	isStrictSupersetOf
		:description:	Returns true if the set is a superset of a finite sequence as a Set but not equal.
		- returns:	Bool
	*/
	public func isStrictSupersetOf(set: SortedMultiSet<Element>) -> Bool {
		return count > set.count && isSupersetOf(set)
	}
}

public func ==<Element: Comparable>(lhs: SortedMultiSet<Element>, rhs: SortedMultiSet<Element>) -> Bool {
	if lhs.count != rhs.count {
		return false
	}
	for var i: Int = lhs.count - 1; 0 <= i; --i {
		if lhs[i] != rhs[i] {
			return false
		}
	}
	return true
}

public func !=<Element: Comparable>(lhs: SortedMultiSet<Element>, rhs: SortedMultiSet<Element>) -> Bool {
	return !(lhs == rhs)
}

public func +<Element : Comparable>(lhs: SortedMultiSet<Element>, rhs: SortedMultiSet<Element>) -> SortedMultiSet<Element> {
	return lhs.union(rhs)
}

public func +=<Element : Comparable>(lhs: SortedMultiSet<Element>, rhs: SortedMultiSet<Element>) {
	lhs.unionInPlace(rhs)
}

public func -<Element : Comparable>(lhs: SortedMultiSet<Element>, rhs: SortedMultiSet<Element>) -> SortedMultiSet<Element> {
	return lhs.subtract(rhs)
}

public func -=<Element : Comparable>(lhs: SortedMultiSet<Element>, rhs: SortedMultiSet<Element>) {
	lhs.subtractInPlace(rhs)
}

public func <=<Element : Comparable>(lhs: SortedMultiSet<Element>, rhs: SortedMultiSet<Element>) -> Bool {
	return lhs.isSubsetOf(rhs)
}

public func >=<Element : Comparable>(lhs: SortedMultiSet<Element>, rhs: SortedMultiSet<Element>) -> Bool {
	return lhs.isSupersetOf(rhs)
}

public func ><Element : Comparable>(lhs: SortedMultiSet<Element>, rhs: SortedMultiSet<Element>) -> Bool {
	return lhs.isStrictSupersetOf(rhs)
}

public func <<Element : Comparable>(lhs: SortedMultiSet<Element>, rhs: SortedMultiSet<Element>) -> Bool {
	return lhs.isStrictSubsetOf(rhs)
}
