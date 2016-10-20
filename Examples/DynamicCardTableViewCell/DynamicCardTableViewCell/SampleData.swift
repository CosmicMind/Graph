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
 *	*	Neither the name of CosmicMind nor the names of its
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

import UIKit
import Material
import Graph

extension UIImage {
    public class func load(contentsOfFile name: String, ofType type: String) -> UIImage? {
        return UIImage(contentsOfFile: Bundle.main.path(forResource: name, ofType: type)!)
    }
}

struct SampleData {
    public static func createSampleData() {
        let graph = Graph()
        
        let e1 = Entity(type: "Item")
        e1["title"] = "Daniel Dahan"
        e1["status"] = "Making the world a better place, one line of code at a time."
        e1["photo"] = UIImage.load(contentsOfFile: "daniel", ofType: "jpg")?.crop(toWidth: 60, toHeight: 60)
        
        let e2 = Entity(type: "Item")
        e2["title"] = "Deepali Parhar"
        e2["status"] = "I haven’t come this far, only to come this far."
        e2["photo"] = UIImage.load(contentsOfFile: "deepali", ofType: "jpg")?.crop(toWidth: 60, toHeight: 60)
        
        let e3 = Entity(type: "Item")
        e3["title"] = "Eve"
        e3["status"] = "Life is beautiful, so reflect it."
        e3["photo"] = UIImage.load(contentsOfFile: "eve", ofType: "jpg")?.crop(toWidth: 60, toHeight: 60)
        
        let e4 = Entity(type: "Item")
        e4["title"] = "Kendall Johnson"
        e4["status"] = "It’s all about perspective"
        e4["photo"] = UIImage.load(contentsOfFile: "kendall", ofType: "jpg")?.crop(toWidth: 60, toHeight: 60)
        
        let e5 = Entity(type: "Item")
        e5["title"] = "Ashton McGregor"
        e5["status"] = "So much to say, so few words."
        e5["photo"] = UIImage.load(contentsOfFile: "ashton", ofType: "png")?.crop(toWidth: 60, toHeight: 60)
        
        let e7 = Entity(type: "Item")
        e7["title"] = "Laura Graham"
        e7["status"] = "Eyes are the mirror to your soul."
        e7["photo"] = UIImage.load(contentsOfFile: "laura", ofType: "jpg")?.crop(toWidth: 60, toHeight: 60)
        
        let e8 = Entity(type: "Item")
        e8["title"] = "Karen Si"
        e8["status"] = "Letting go to move forward."
        e8["photo"] = UIImage.load(contentsOfFile: "karen", ofType: "jpg")?.crop(toWidth: 60, toHeight: 60)
        
        let e9 = Entity(type: "Item")
        e9["title"] = "Jonathan Kuran"
        e9["status"] = "Calculating the distance from here to there."
        e9["photo"] = UIImage.load(contentsOfFile: "jonathan", ofType: "jpg")?.crop(toWidth: 60, toHeight: 60)
        
        let e10 = Entity(type: "Item")
        e10["title"] = "Thomas Wallace"
        e10["status"] = "I’m in it to win it. Long game."
        e10["photo"] = UIImage.load(contentsOfFile: "thomas", ofType: "jpg")?.crop(toWidth: 60, toHeight: 60)
        
        let e11 = Entity(type: "Item")
        e11["title"] = "Charles St. Louis"
        e11["status"] = "Double Major in Mathematics and Philosophy. Modern Day Renaissance Man."
        e11["photo"] = UIImage.load(contentsOfFile: "charles", ofType: "jpg")?.crop(toWidth: 60, toHeight: 60)
        
        let e12 = Entity(type: "Item")
        e12["title"] = "Kelly Martin"
        e12["status"] = "The world is mine."
        e12["photo"] = UIImage.load(contentsOfFile: "kelly", ofType: "jpeg")?.crop(toWidth: 60, toHeight: 60)
        
        graph.sync()
    }
}
