/*
* Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>. All rights reserved.
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

extension Set : ProbableType {
	/**
	The instance count of elements.
	*/
	public func countOf<Element: Equatable>(elements: Element...) -> Int {
		return countOf(elements)
	}
	
	/**
	The instance count of elements.
	*/
	public func countOf<Element: Equatable>(elements: Array<Element>) -> Int {
		var c: Int = 0
		for v in elements {
			for x in self {
				if v == x as! Element {
					++c
				}
			}
		}
		return c
	}
	
	/**
	The probability of elements.
	*/
	public func probabilityOf<Element: Equatable>(elements: Element...) -> Double {
		return probabilityOf(elements)
	}
	
	/**
	The probability of elements.
	*/
	public func probabilityOf<Element: Equatable>(elements: Array<Element>) -> Double {
		return 0 == count ? 0 : Double(countOf(elements)) / Double(count)
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
	public func expectedValueOf<Element: Equatable>(trials: Int, elements: Element...) -> Double {
		return expectedValueOf(trials, elements: elements)
	}
	
	/**
	The expected value of elements.
	*/
	public func expectedValueOf<Element: Equatable>(trials: Int, elements: Array<Element>) -> Double {
		return Double(trials) * probabilityOf(elements)
	}
}
