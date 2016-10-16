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
        
        let u1 = Entity(type: "User")
        u1["name"] = "Daniel Dahan"
        u1["status"] = "Making the world a better place, one line of code at a time."
        u1["photo"] = UIImage.load(contentsOfFile: "daniel", ofType: "jpg")?.crop(toWidth: 60, toHeight: 60)
        
        let u2 = Entity(type: "User")
        u2["name"] = "Deepali Parhar"
        u2["status"] = "I haven’t come this far, only to come this far."
        u2["photo"] = UIImage.load(contentsOfFile: "deepali", ofType: "jpg")?.crop(toWidth: 60, toHeight: 60)
        
        let u3 = Entity(type: "User")
        u3["name"] = "Eve"
        u3["status"] = "Life is beautiful, so reflect it."
        u3["photo"] = UIImage.load(contentsOfFile: "eve", ofType: "jpg")?.crop(toWidth: 60, toHeight: 60)
        
        let u4 = Entity(type: "User")
        u4["name"] = "Kendall Johnson"
        u4["status"] = "It’s all about perspective"
        u4["photo"] = UIImage.load(contentsOfFile: "kendall", ofType: "jpg")?.crop(toWidth: 60, toHeight: 60)
        
        let u5 = Entity(type: "User")
        u5["name"] = "Ashton McGregor"
        u5["status"] = "So much to say, so few words."
        u5["photo"] = UIImage.load(contentsOfFile: "ashton", ofType: "png")?.crop(toWidth: 60, toHeight: 60)
        
        let u7 = Entity(type: "User")
        u7["name"] = "Laura Graham"
        u7["status"] = "Eyes are the mirror to your soul."
        u7["photo"] = UIImage.load(contentsOfFile: "laura", ofType: "jpg")?.crop(toWidth: 60, toHeight: 60)
        
        let u8 = Entity(type: "User")
        u8["name"] = "Karen Si"
        u8["status"] = "Letting go to move forward."
        u8["photo"] = UIImage.load(contentsOfFile: "karen", ofType: "jpg")?.crop(toWidth: 60, toHeight: 60)
        
        let u9 = Entity(type: "User")
        u9["name"] = "Jonathan Kuran"
        u9["status"] = "Calculating the distance from here to there."
        u9["photo"] = UIImage.load(contentsOfFile: "jonathan", ofType: "jpg")?.crop(toWidth: 60, toHeight: 60)
        
        let u10 = Entity(type: "User")
        u10["name"] = "Thomas Wallace"
        u10["status"] = "I’m in it to win it. Long game."
        u10["photo"] = UIImage.load(contentsOfFile: "thomas", ofType: "jpg")?.crop(toWidth: 60, toHeight: 60)
        
        let u11 = Entity(type: "User")
        u11["name"] = "Charles St. Louis"
        u11["status"] = "Double Major in Mathematics and Philosophy. Modern Day Renaissance Man."
        u11["photo"] = UIImage.load(contentsOfFile: "charles", ofType: "jpg")?.crop(toWidth: 60, toHeight: 60)
        
        let u12 = Entity(type: "User")
        u12["name"] = "Kelly Martin"
        u12["status"] = "The world is mine."
        u12["photo"] = UIImage.load(contentsOfFile: "kelly", ofType: "jpeg")?.crop(toWidth: 60, toHeight: 60)
        
        graph.sync()
    }
}
