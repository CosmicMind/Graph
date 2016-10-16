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

struct SampleData {
    public static func createSampleData() {
        let graph = Graph()
        
        let u1 = Entity(type: "User")
        u1["name"] = "Daniel Dahan"
        u1["status"] = "Working on CosmicMind frameworks!"
        u1["photo"] = UIImage.image(with: Color.grey.lighten5, size: CGSize(width: 100, height: 100))
        
        let u2 = Entity(type: "User")
        u2["name"] = "Deepali Parhar"
        u2["status"] = "Posting a tweet!"
        u2["photo"] = UIImage.image(with: Color.grey.lighten5, size: CGSize(width: 100, height: 100))
        
        let u3 = Entity(type: "User")
        u3["name"] = "Eve"
        u3["status"] = "Doing yoga <3"
        u3["photo"] = UIImage.image(with: Color.grey.lighten5, size: CGSize(width: 100, height: 100))
        
        let u4 = Entity(type: "User")
        u4["name"] = "Charles St. Louis"
        u4["status"] = "Kicking butt at Queens University."
        u4["photo"] = UIImage.image(with: Color.grey.lighten5, size: CGSize(width: 100, height: 100))
        
        graph.sync()
    }
}
