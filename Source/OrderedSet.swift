//
// Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program located at the root of the software package
// in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
//

public class OrderedSet<Element : Comparable> : Probability<Element>, CollectionType, Comparable, Equatable, Printable {
	public typealias Generator = GeneratorOf<Element>

	/**
		:name:	tree
		:description:	Internal storage of elements.
	*/
	internal var tree: Tree<Element, Element>

	/**
		:name:	description
		:description:	Conforms to the Printable Protocol. Outputs the
		data in the OrderedSet in a readable format.
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
	*/
	public var first: Element? {
		return tree.first?.value
	}

	/**
		:name:	last
		:description:	Get the last node value in the tree, this is
		the last node based on the order of keys where
		k1 <= k2 <= K3 ... <= Kn
	*/
	public var last: Element? {
		return tree.last?.value
	}

	/**
		:name:	isEmpty
		:description:	A boolean of whether the RedBlackTree is empty.
	*/
	public var isEmpty: Bool {
		return 0 == count
	}

	/**
		:name:	startIndex
		:description:	Conforms to the CollectionType Protocol.
	*/
	public var startIndex: Int {
		return 0
	}

	/**
		:name:	endIndex
		:description:	Conforms to the CollectionType Protocol.
	*/
	public var endIndex: Int {
		return count
	}
	
	/**
		:name:	init
		:description:	Constructor.
	*/
	public override init() {
		tree = Tree<Element, Element>()
	}

	/**
		:name:	init
		:description:	Constructor.
	*/
	public convenience init(elements: Element...) {
		self.init(elements: elements)
	}

	/**
		:name:	init
		:description:	Constructor.
	*/
	public convenience init(elements: Array<Element>) {
		self.init()
		insert(elements)
	}

	/**
		:name:	generate
		:description:	Conforms to the SequenceType Protocol. Returns
		the next value in the sequence of nodes using
		index values [0...n-1].
	*/
	public func generate() -> Generator {
		var index = startIndex
		return GeneratorOf {
			if index < self.endIndex {
				return self[index++]
			}
			return nil
		}
	}

	/**
		:name:	operator [0...count - 1]
		:description:	Allows array like access of the index.
		Items are kept in order, so when iterating
		through the items, they are returned in their
		ordered form.
	*/
	public subscript(index: Int) -> Element {
		return tree[index].value!
	}

	/**
		:name:	contains
		:description:	A boolean check if values exists
		 in the set.
	*/
	public func contains(elements: Element...) -> Bool {
		return contains(elements)
	}
	
	/**
		:name:	contains
		:description:	A boolean check if an array of values exist
		 in the set.
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
		:name:	countOf
		:description:	Conforms to ProbabilityType protocol.
	*/
	public override func countOf(elements: Element...) -> Int {
		return tree.countOf(elements)
	}

	/**
		:name:	countOf
		:description:	Conforms to ProbabilityType protocol.
	*/
	public override func countOf(elements: Array<Element>) -> Int {
		return tree.countOf(elements)
	}

	/**
		:name:	insert
		:description:	Inserts new elements into the OrderedSet.
	*/
	public func insert(elements: Element...) {
		insert(elements)
	}

	/**
		:name:	insert
		:description:	Inserts new elements into the OrderedSet.
	*/
	public func insert(elements: Array<Element>) {
		for x in elements {
			tree.insert(x, value: x)
		}
		count = tree.count
	}

	/**
		:name:	remove
		:description:	Removes elements from the OrderedSet.
	*/
	public func remove(elements: Element...) -> OrderedSet<Element> {
		return remove(elements)
	}

	/**
		:name:	remove
		:description:	Removes elements from the OrderedSet.
	*/
	public func remove(elements: Array<Element>) -> OrderedSet<Element> {
		let s: OrderedSet<Element> = OrderedSet<Element>()
		for x in elements {
			if nil != tree.removeValueForKey(x) {
				count = tree.count
				s.insert(x)
			}
		}
		return s
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
	*/
	public func intersect(sets: OrderedSet<Element>...) -> OrderedSet<Element> {
		return intersect(sets)
	}

	/**
		:name:	intersect
		:description:	Return a new set with elements common to this set and a finite sequence of Sets.
	*/
	public func intersect(sets: Array<OrderedSet<Element>>) -> OrderedSet<Element> {
		let s: OrderedSet<Element> = OrderedSet<Element>()
		for (x, _) in tree {
			var toInsert: Bool = true
			for u in sets {
				if nil == u.tree.findValueForKey(x) {
					toInsert = false
					break
				}
			}
			if toInsert {
				s.insert(x)
			}
		}
		return s
	}

	/**
		:name:	intersectInPlace
		:description:	Insert elements of a finite sequence of Sets.
	*/
	public func intersectInPlace(sets: OrderedSet<Element>...) {
		intersectInPlace(sets)
	}

	/**
		:name:	intersectInPlace
		:description:	Remove any elements of this set that aren't also in a finite sequence of Sets.
	*/
	public func intersectInPlace(sets: Array<OrderedSet<Element>>) {
		for var i: Int = tree.count - 1; 0 <= i; --i {
			let x: Element = tree[i].key
			for u in sets {
				if nil == u.tree.findValueForKey(x) {
					tree.removeValueForKey(x)
					count = tree.count
					break
				}
			}
		}
	}

	/**
		:name:	union
		:description:	Return a new Set with items in both this set and a finite sequence of Sets.
	*/
	public func union(sets: OrderedSet<Element>...) -> OrderedSet<Element> {
		return union(sets)
	}

	/**
		:name:	union
		:description:	Return a new Set with items in both this set and a finite sequence of Sets.
	*/
	public func union(sets: Array<OrderedSet<Element>>) -> OrderedSet<Element> {
		let s: OrderedSet<Element> = OrderedSet<Element>()
		for u in sets {
			for (x, _) in u.tree {
				s.insert(x)
			}
		}
		for (x, _) in tree {
			s.insert(x)
		}
		return s
	}

	/**
		:name:	unionInPlace
		:description:	Return a new Set with items in both this set and a finite sequence of Sets.
	*/
	public func unionInPlace(sets: OrderedSet<Element>...) {
		unionInPlace(sets)
	}

	/**
		:name:	unionInPlace
		:description:	Insert elements of a finite sequence of Sets.
	*/
	public func unionInPlace(sets: Array<OrderedSet<Element>>) {
		for u in sets {
			for (x, _) in u.tree {
				insert(x)
			}
		}
	}
	
	/**
		:name:	subtract
		:description:	Return a new set with elements in this set that do not occur in a finite sequence of Sets.
	*/
	public func subtract(sets: OrderedSet<Element>...) -> OrderedSet<Element> {
		return subtract(sets)
	}
	
	/**
		:name:	subtract
		:description:	Return a new set with elements in this set that do not occur in a finite sequence of Sets.
	*/
	public func subtract(sets: Array<OrderedSet<Element>>) -> OrderedSet<Element> {
		let s: OrderedSet<Element> = OrderedSet<Element>()
		for x in self {
			var toInsert: Bool = true
			for u in sets {
				if nil != u.tree.findValueForKey(x) {
					toInsert = false
					break
				}
			}
			if toInsert {
				s.insert(x)
			}
		}
		return s
	}
	
	/**
		:name:	subtractInPlace
		:description:	Remove all elements in the set that occur in a finite sequence of Sets.
	*/
	public func subtractInPlace(sets: OrderedSet<Element>...) {
		subtractInPlace(sets)
	}
	
	/**
		:name:	subtractInPlace
		:description:	Remove all elements in the set that occur in a finite sequence of Sets.
	*/
	public func subtractInPlace(sets: Array<OrderedSet<Element>>) {
		for u in sets {
			for (x, _) in u.tree {
				if nil != tree.removeValueForKey(x) {
					count = tree.count
				}
			}
		}
	}
	
	/**
		:name:	exclusiveOr
		:description:	Return a new set with elements that are either in the set or a finite sequence but do not occur in both.
	*/
	public func exclusiveOr(sets: OrderedSet<Element>...) -> OrderedSet<Element> {
		return exclusiveOr(sets)
	}
	
	/**
		:name:	exclusiveOr
		:description:	Return a new set with elements that are either in the set or a finite sequence but do not occur in both.
	*/
	public func exclusiveOr(var sets: Array<OrderedSet<Element>>) -> OrderedSet<Element> {
		sets.append(self)
		let s: OrderedSet<Element> = OrderedSet<Element>()
		let n: Int = sets.count - 1
		for var i: Int = n; 0 <= i; --i {
			for (x, _) in sets[i].tree {
				var toInsert: Bool = true
				for var j: Int = n; 0 <= j; --j {
					if i != j {
						if nil != sets[j].tree.findValueForKey(x) {
							toInsert = false
							break
						}
					}
				}
				if toInsert {
					s.insert(x)
				}
			}
		}
		return s
	}
	
	/**
		:name:	exclusiveOrInPlace
		:description:	For each element of a finite sequence, remove it from the set if it is a
		common element, otherwise add it to the set. Repeated elements of the sequence will be
		ignored.
	*/
	public func exclusiveOrInPlace(sets: OrderedSet<Element>...) {
		exclusiveOrInPlace(sets)
	}
	
	/**
		:name:	exclusiveOrInPlace
		:description:	For each element of a finite sequence, remove it from the set if it is a 
		common element, otherwise add it to the set. Repeated elements of the sequence will be 
		ignored.
	*/
	public func exclusiveOrInPlace(sets: Array<OrderedSet<Element>>) {
		let n: Int = sets.count - 1
		for var i: Int = n; 0 <= i; --i {
			for (x, _) in sets[i].tree {
				var toInsert: Bool = true
				for var j: Int = n; 0 <= j; --j {
					if i != j {
						if nil != sets[j].tree.findValueForKey(x) {
							toInsert = false
							break
						}
					}
				}
				if toInsert && nil == tree.findValueForKey(x) {
					insert(x)
				} else if nil != tree.removeValueForKey(x) {
					count = tree.count
				}
			}
		}
	}
	
	
	/**
		:name:	isDisjointWith
		:description:	Returns true if no elements in the set are in a finite sequence of Sets.
	*/
	public func isDisjointWith(sets: OrderedSet<Element>...) -> Bool {
		return isDisjointWith(sets)
	}
	
	/**
		:name:	isDisjointWith
		:description:	Returns true if no elements in the set are in a finite sequence of Sets.
	*/
	public func isDisjointWith(sets: Array<OrderedSet<Element>>) -> Bool {
		for (x, _) in tree {
			for u in sets {
				if nil != u.tree.findValueForKey(x) {
					return false
				}
			}
		}
		return true
	}
	
	/**
		:name:	isSubsetOf
		:description:	Returns true if the set is a subset of a finite sequence as a Set.
	*/
	public func isSubsetOf(set: OrderedSet<Element>) -> Bool {
		if count > set.count {
			return false
		}
		for x in self {
			if nil == set.tree.findValueForKey(x) {
				return false
			}
		}
		return true
	}

	/**
		:name:	isStrictSubsetOf
		:description:	Returns true if the set is a subset of a finite sequence as a Set but not equal.
	*/
	public func isStrictSubsetOf(set: OrderedSet<Element>) -> Bool {
		return count < set.count && isSubsetOf(set)
	}

	/**
		:name:	isSupersetOf
		:description:	Returns true if the set is a superset of a finite sequence as a Set.
	*/
	public func isSupersetOf(set: OrderedSet<Element>) -> Bool {
		if count < set.count {
			return false
		}
		for x in set {
			if nil == tree.findValueForKey(x) {
				return false
			}
		}
		return true
	}
	
	/**
		:name:	isStrictSupersetOf
		:description:	Returns true if the set is a superset of a finite sequence as a Set but not equal.
	*/
	public func isStrictSupersetOf(set: OrderedSet<Element>) -> Bool {
		return count > set.count && isSupersetOf(set)
	}
}

public func ==<Element: Comparable>(lhs: OrderedSet<Element>, rhs: OrderedSet<Element>) -> Bool {
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

public func +<Element : Comparable>(lhs: OrderedSet<Element>, rhs: OrderedSet<Element>) -> OrderedSet<Element> {
	return lhs.union(rhs)
}

public func -<Element : Comparable>(lhs: OrderedSet<Element>, rhs: OrderedSet<Element>) -> OrderedSet<Element> {
	return lhs.subtract(rhs)
}

public func <=<Element : Comparable>(lhs: OrderedSet<Element>, rhs: OrderedSet<Element>) -> Bool {
	return lhs.isSubsetOf(rhs)
}

public func >=<Element : Comparable>(lhs: OrderedSet<Element>, rhs: OrderedSet<Element>) -> Bool {
	return lhs.isSupersetOf(rhs)
}

public func ><Element : Comparable>(lhs: OrderedSet<Element>, rhs: OrderedSet<Element>) -> Bool {
	return lhs.isStrictSupersetOf(rhs)
}

public func <<Element : Comparable>(lhs: OrderedSet<Element>, rhs: OrderedSet<Element>) -> Bool {
	return lhs.isStrictSubsetOf(rhs)
}
