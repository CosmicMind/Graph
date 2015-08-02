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
		:description:	Internal storage of members.
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
	public convenience init(members: Element...) {
		self.init(members: members)
	}

	/**
		:name:	init
		:description:	Constructor.
	*/
	public convenience init(members: Array<Element>) {
		self.init()
		insert(members)
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
	public func contains(members: Element...) -> Bool {
		return contains(members)
	}
	
	/**
		:name:	contains
		:description:	A boolean check if an array of values exist
		 in the set.
	*/
	public func contains(members: Array<Element>) -> Bool {
		if 0 == members.count {
			return false
		}
		for x in members {
			if 0 == tree.countOf(x) {
				return false
			}
		}
		return true
	}
	
	/**
		:name:	countOf
		:description:	Conforms to ProbabilityType protocol.
	*/
	public override func countOf(members: Element...) -> Int {
		return tree.countOf(members)
	}

	/**
		:name:	countOf
		:description:	Conforms to ProbabilityType protocol.
	*/
	public override func countOf(members: Array<Element>) -> Int {
		return tree.countOf(members)
	}

	/**
		:name:	insert
		:description:	Inserts new members into the OrderedSet.
	*/
	public func insert(members: Element...) {
		insert(members)
	}

	/**
		:name:	insert
		:description:	Inserts new members into the OrderedSet.
	*/
	public func insert(members: Array<Element>) {
		for x in members {
			if tree.insert(x, value: x) {
				count = tree.count
			}
		}
	}

	/**
		:name:	remove
		:description:	Removes members from the OrderedSet.
	*/
	public func remove(members: Element...) {
		remove(members)
	}

	/**
		:name:	remove
		:description:	Removes members from the OrderedSet.
	*/
	public func remove(members: Array<Element>) {
		for x in members {
			if nil != tree.removeValueForKey(x) {
				count = tree.count
			}
		}
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
		:name:	isDisjointWith
		:description:	Returns true if no members in the set are in a finite sequence of Sets.
	*/
	public func isDisjointWith(sets: OrderedSet<Element>...) -> Bool {
		return isDisjointWith(sets)
	}

	/**
		:name:	isDisjointWith
		:description:	Returns true if no members in the set are in a finite sequence of Sets.
	*/
	public func isDisjointWith(sets: Array<OrderedSet<Element>>) -> Bool {
		return intersect(sets).isEmpty
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
		:description:	Remove all members in the set that occur in a finite sequence of Sets.
	*/
	public func subtractInPlace(sets: OrderedSet<Element>...) {
		return subtractInPlace(sets)
	}

	/**
		:name:	subtractInPlace
		:description:	Remove all members in the set that occur in a finite sequence of Sets.
	*/
	public func subtractInPlace(sets: Array<OrderedSet<Element>>) {
		let s: OrderedSet<Element> = subtract(sets)
		removeAll()
		for x in s {
			insert(x)
		}
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
		for x in self {
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
		:description:	Remove any members of this set that aren't also in a finite sequence of Sets.
	*/
	public func intersectInPlace(sets: Array<OrderedSet<Element>>) {
		let s: OrderedSet<Element> = intersect(sets)
		removeAll()
		for x in s {
			insert(x)
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
			for x in u {
				s.insert(x)
			}
		}
		for x in self {
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
		let s: OrderedSet<Element> = union(sets)
		removeAll()
		for x in s {
			insert(x)
		}
	}

	/**
		:name:	isSubsetOf
		:description:	Returns true if the set is a subset of a finite sequence as a Set.
	*/
	public func isSubsetOf(set: OrderedSet<Element>) -> Bool {
		if count > set.count {
			return false
		}
		return count == intersect(set).count
	}

	/**
		:name:	isSupersetOf
		:description:	Returns true if the set is a superset of a finite sequence as a Set.
	*/
	public func isSupersetOf(set: OrderedSet<Element>) -> Bool {
		if count < set.count {
			return false
		}
		return set.count == intersect(set).count
	}

	/**
		:name:	isStrictSubsetOf
		:description:	Returns true if the set is a subset of a finite sequence as a Set but not equal.
	*/
	public func isStrictSubsetOf(set: OrderedSet<Element>) -> Bool {
		return count < set.count && isSubsetOf(set)
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
