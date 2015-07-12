/**
* Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero General Public License as published
* by the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Affero General Public License for more details.
*
* You should have received a copy of the GNU Affero General Public License
* along with this program located at the root of the software package
* in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
*
* OrderedMultiSet
*/

public class OrderedMultiSet<Element: Comparable>: Probability<Element>, CollectionType, Equatable, Printable {
	internal typealias TreeType = MultiTree<Element, Element>
	internal typealias SetType = OrderedMultiSet<Element>
	internal typealias Generator = GeneratorOf<Element>
	
	/**
	* tree
	*/
	internal var tree: TreeType
	
	/**
	* description
	* Conforms to the Printable Protocol. Outputs the
	* data in the OrderedMultiSet in a readable format.
	*/
	public var description: String {
		var output: String = "OrderedMultiSet("
		for var i: Int = 0; i < count; ++i {
			output += "\(tree[i]!)"
			if i + 1 != count {
				output += ", "
			}
		}
		return output + ")"
	}
	
	/**
	* first
	* Get the first node value in the tree, this is
	* the first node based on the order of keys where
	* k1 <= k2 <= K3 ... <= Kn
	*/
	public var first: Element? {
		return tree.first
	}
	
	/**
	* last
	* Get the last node value in the tree, this is
	* the last node based on the order of keys where
	* k1 <= k2 <= K3 ... <= Kn
	*/
	public var last: Element? {
		return tree.last
	}
	
	/**
	* isEmpty
	* A boolean of whether the RedBlackTree is empty.
	*/
	public var isEmpty: Bool {
		return 0 == count
	}
	
	/**
	* startIndex
	* Conforms to the CollectionType Protocol.
	*/
	public var startIndex: Int {
		return 0
	}
	
	/**
	* endIndex
	* Conforms to the CollectionType Protocol.
	*/
	public var endIndex: Int {
		return count
	}
	
	/**
	* init
	* Constructor
	*/
	public override init() {
		tree = TreeType()
	}
	
	/**
	* generate
	* Conforms to the SequenceType Protocol. Returns
	* the next value in the sequence of nodes using
	* index values [0...n-1].
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
	* operator [0...count - 1]
	* Allows array like access of the index.
	* Items are kept in order, so when iterating
	* through the items, they are returned in their
	* ordered form.
	* @param		index: Int
	* @return		value V?
	*/
	public subscript(index: Int) -> Element {
		return tree[index]!
	}
	
	/**
	* countOf
	* Conforms to _ProbabilityType protocol.
	*/
	public override func countOf(members: Element...) -> Int {
		return tree.countOf(members)
	}
	
	/**
	* countOf
	* Conforms to ProbabilityType protocol.
	*/
	public override func countOf(members: Array<Element>) -> Int {
		return tree.countOf(members)
	}
	
	/**
	* insert
	* Inserts new members into the OrderedMultiSet.
	* @param		members: Element...
	*/
	public func insert(members: Element...) {
		insert(members)
	}
	
	/**
	* insert
	* Inserts new members into the OrderedMultiSet.
	* @param		member: Array<Element>
	*/
	public func insert(members: Array<Element>) {
		for x in members {
			if tree.insert(x, value: x) {
				count = tree.count
			}
		}
	}
	
	/**
	* remove
	* Removes members from the OrderedMultiSet.
	* @param		members: Element...
	*/
	public func remove(members: Element...) {
		remove(members)
	}
	
	/**
	* remove
	* Removes members from the OrderedMultiSet.
	* @param		member: Array<Element>
	*/
	public func remove(members: Array<Element>) {
		for x in members {
			if tree.remove(x) {
				count = tree.count
			}
		}
	}
	
	/**
	* removeAll
	* Remove all nodes from the tree.
	*/
	public func removeAll() {
		tree.removeAll()
		count = tree.count
	}
	
	/**
	* interset
	* Return a new set with elements common to this set and a finite sequence of sets.
	* @param		sets: SetType...
	* @return		SetType
	*/
	public func intersect(sets: SetType...) -> SetType {
		return intersect(sets)
	}
	
	/**
	* interset
	* Return a new set with elements common to this set and a finite sequence of sets.
	* @param		sets: Array<SetType>
	* @return		SetType
	*/
	public func intersect(sets: Array<SetType>) -> SetType {
		let s: SetType = SetType()
		for x in self {
			var toInsert: Bool = true
			for set in sets {
				if nil == set.tree.find(x) {
					toInsert = false
					break
				}
			}
			if toInsert {
				s.insert(x)
			}
		}
		return s	}
	
	/**
	* intersetInPlace
	* Remove any members of this set that aren't also in a finite sequence of sets.
	* @param		sets: SetType...
	*/
	public func intersectInPlace(sets: SetType...) {
		intersectInPlace(sets)
	}
	
	/**
	* intersetInPlace
	* Remove any members of this set that aren't also in a finite sequence of sets.
	* @param		sets: Array<SetType>
	*/
	public func intersectInPlace(sets: Array<SetType>) {
		let s: SetType = SetType()
		for x in self {
			var toInsert: Bool = true
			for set in sets {
				if nil == set.tree.find(x) {
					toInsert = false
					break
				}
			}
			if toInsert {
				s.insert(x)
			}
		}
		removeAll()
		for x in s {
			insert(x)
		}
	}
}

public func ==<Element: Comparable>(lhs: OrderedMultiSet<Element>, rhs: OrderedMultiSet<Element>) -> Bool {
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
