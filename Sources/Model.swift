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

import CoreData

internal struct ModelSingleton {
    static var dispatchToken: dispatch_once_t = 0
    static var managedObjectModel: NSManagedObjectModel?
}

internal struct ModelIdentifier {
    static let entityIndexName: String = "ManagedEntity"
    static let entityDescriptionName: String = entityIndexName
    static let entityObjectClassName: String = entityIndexName
    static let entityGroupIndexName: String = "ManagedEntityGroup"
    static let entityGroupObjectClassName: String = entityGroupIndexName
    static let entityGroupDescriptionName: String = entityGroupIndexName
    static let entityPropertyIndexName: String = "ManagedEntityProperty"
    static let entityPropertyObjectClassName: String = entityPropertyIndexName
    static let entityPropertyDescriptionName: String = entityPropertyIndexName
    
    static let actionIndexName: String = "ManagedAction"
    static let actionDescriptionName: String = actionIndexName
    static let actionObjectClassName: String = actionIndexName
    static let actionGroupIndexName: String = "ManagedActionGroup"
    static let actionGroupObjectClassName: String = actionGroupIndexName
    static let actionGroupDescriptionName: String = actionGroupIndexName
    static let actionPropertyIndexName: String = "ManagedActionProperty"
    static let actionPropertyObjectClassName: String = actionPropertyIndexName
    static let actionPropertyDescriptionName: String = actionPropertyIndexName
    
    static let relationshipIndexName: String = "ManagedRelationship"
    static let relationshipDescriptionName: String = relationshipIndexName
    static let relationshipObjectClassName: String = relationshipIndexName
    static let relationshipGroupIndexName: String = "ManagedRelationshipGroup"
    static let relationshipGroupObjectClassName: String = relationshipGroupIndexName
    static let relationshipGroupDescriptionName: String = relationshipGroupIndexName
    static let relationshipPropertyIndexName: String = "ManagedRelationshipProperty"
    static let relationshipPropertyObjectClassName: String = relationshipPropertyIndexName
    static let relationshipPropertyDescriptionName: String = relationshipPropertyIndexName
}

internal struct Model {
    /// Creates a NSManagedObjectModel.
    static func createManagedObjectModel() -> NSManagedObjectModel {
        dispatch_once(&ModelSingleton.dispatchToken) {
            let entityDescription = NSEntityDescription()
            var entityProperties = [AnyObject]()
            entityDescription.name = ModelIdentifier.entityDescriptionName
            entityDescription.managedObjectClassName = ModelIdentifier.entityObjectClassName
            
            let actionDescription = NSEntityDescription()
            var actionProperties = [AnyObject]()
            actionDescription.name = ModelIdentifier.actionDescriptionName
            actionDescription.managedObjectClassName = ModelIdentifier.actionObjectClassName
            
            let relationshipDescription = NSEntityDescription()
            var relationshipProperties = [AnyObject]()
            relationshipDescription.name = ModelIdentifier.relationshipDescriptionName
            relationshipDescription.managedObjectClassName = ModelIdentifier.relationshipObjectClassName
            
            let entityGroupDescription = NSEntityDescription()
            var entityGroupProperties = [AnyObject]()
            entityGroupDescription.name = ModelIdentifier.entityGroupDescriptionName
            entityGroupDescription.managedObjectClassName = ModelIdentifier.entityGroupObjectClassName
            
            let actionGroupDescription = NSEntityDescription()
            var actionGroupProperties = [AnyObject]()
            actionGroupDescription.name = ModelIdentifier.actionGroupDescriptionName
            actionGroupDescription.managedObjectClassName = ModelIdentifier.actionGroupObjectClassName
            
            let relationshipGroupDescription = NSEntityDescription()
            var relationshipGroupProperties = [AnyObject]()
            relationshipGroupDescription.name = ModelIdentifier.relationshipGroupDescriptionName
            relationshipGroupDescription.managedObjectClassName = ModelIdentifier.relationshipGroupObjectClassName
            
            let entityPropertyDescription = NSEntityDescription()
            var entityPropertyProperties = [AnyObject]()
            entityPropertyDescription.name = ModelIdentifier.entityPropertyDescriptionName
            entityPropertyDescription.managedObjectClassName = ModelIdentifier.entityPropertyObjectClassName
            
            let actionPropertyDescription = NSEntityDescription()
            var actionPropertyProperties = [AnyObject]()
            actionPropertyDescription.name = ModelIdentifier.actionPropertyDescriptionName
            actionPropertyDescription.managedObjectClassName = ModelIdentifier.actionPropertyObjectClassName
            
            let relationshipPropertyDescription = NSEntityDescription()
            var relationshipPropertyProperties = [AnyObject]()
            relationshipPropertyDescription.name = ModelIdentifier.relationshipPropertyDescriptionName
            relationshipPropertyDescription.managedObjectClassName = ModelIdentifier.relationshipPropertyObjectClassName
            
            let nodeClass = NSAttributeDescription()
            nodeClass.name = "nodeClass"
            nodeClass.attributeType = .Integer64AttributeType
            nodeClass.optional = false
            entityProperties.append(nodeClass.copy() as! NSAttributeDescription)
            actionProperties.append(nodeClass.copy() as! NSAttributeDescription)
            relationshipProperties.append(nodeClass.copy() as! NSAttributeDescription)
            
            let type = NSAttributeDescription()
            type.name = "type"
            type.attributeType = .StringAttributeType
            type.optional = false
            entityProperties.append(type.copy() as! NSAttributeDescription)
            actionProperties.append(type.copy() as! NSAttributeDescription)
            relationshipProperties.append(type.copy() as! NSAttributeDescription)
            
            let createdDate = NSAttributeDescription()
            createdDate.name = "createdDate"
            createdDate.attributeType = .DateAttributeType
            createdDate.optional = false
            entityProperties.append(createdDate.copy() as! NSAttributeDescription)
            actionProperties.append(createdDate.copy() as! NSAttributeDescription)
            relationshipProperties.append(createdDate.copy() as! NSAttributeDescription)
            
            let propertyName = NSAttributeDescription()
            propertyName.name = "name"
            propertyName.attributeType = .StringAttributeType
            propertyName.optional = false
            entityPropertyProperties.append(propertyName.copy() as! NSAttributeDescription)
            actionPropertyProperties.append(propertyName.copy() as! NSAttributeDescription)
            relationshipPropertyProperties.append(propertyName.copy() as! NSAttributeDescription)
            
            let propertyValue = NSAttributeDescription()
            propertyValue.name = "object"
            propertyValue.attributeType = .TransformableAttributeType
            propertyValue.attributeValueClassName = "AnyObject"
            propertyValue.optional = false
            propertyValue.allowsExternalBinaryDataStorage = true
            entityPropertyProperties.append(propertyValue.copy() as! NSAttributeDescription)
            actionPropertyProperties.append(propertyValue.copy() as! NSAttributeDescription)
            relationshipPropertyProperties.append(propertyValue.copy() as! NSAttributeDescription)
            
            let propertyRelationship = NSRelationshipDescription()
            propertyRelationship.name = "node"
            propertyRelationship.minCount = 1
            propertyRelationship.maxCount = 1
            propertyRelationship.optional = false
            propertyRelationship.deleteRule = .NoActionDeleteRule
            
            let propertySetRelationship = NSRelationshipDescription()
            propertySetRelationship.name = "propertySet"
            propertySetRelationship.minCount = 0
            propertySetRelationship.maxCount = 0
            propertySetRelationship.optional = false
            propertySetRelationship.deleteRule = .NoActionDeleteRule
            propertyRelationship.inverseRelationship = propertySetRelationship
            propertySetRelationship.inverseRelationship = propertyRelationship
            
            propertyRelationship.destinationEntity = entityDescription
            propertySetRelationship.destinationEntity = entityPropertyDescription
            entityPropertyProperties.append(propertyRelationship.copy() as! NSRelationshipDescription)
            entityProperties.append(propertySetRelationship.copy() as! NSRelationshipDescription)
            
            propertyRelationship.destinationEntity = actionDescription
            propertySetRelationship.destinationEntity = actionPropertyDescription
            actionPropertyProperties.append(propertyRelationship.copy() as! NSRelationshipDescription)
            actionProperties.append(propertySetRelationship.copy() as! NSRelationshipDescription)
            
            propertyRelationship.destinationEntity = relationshipDescription
            propertySetRelationship.destinationEntity = relationshipPropertyDescription
            relationshipPropertyProperties.append(propertyRelationship.copy() as! NSRelationshipDescription)
            relationshipProperties.append(propertySetRelationship.copy() as! NSRelationshipDescription)
            
            let groupName = NSAttributeDescription()
            groupName.name = "name"
            groupName.attributeType = .StringAttributeType
            groupName.optional = false
            entityGroupProperties.append(groupName.copy() as! NSAttributeDescription)
            actionGroupProperties.append(groupName.copy() as! NSAttributeDescription)
            relationshipGroupProperties.append(groupName.copy() as! NSAttributeDescription)
            
            let groupRelationship = NSRelationshipDescription()
            groupRelationship.name = "node"
            groupRelationship.minCount = 1
            groupRelationship.maxCount = 1
            groupRelationship.optional = false
            groupRelationship.deleteRule = .NoActionDeleteRule
            
            let groupSetRelationship = NSRelationshipDescription()
            groupSetRelationship.name = "groupSet"
            groupSetRelationship.minCount = 0
            groupSetRelationship.maxCount = 0
            groupSetRelationship.optional = false
            groupSetRelationship.deleteRule = .NoActionDeleteRule
            groupRelationship.inverseRelationship = groupSetRelationship
            groupSetRelationship.inverseRelationship = groupRelationship
            
            groupRelationship.destinationEntity = entityDescription
            groupSetRelationship.destinationEntity = entityGroupDescription
            entityGroupProperties.append(groupRelationship.copy() as! NSRelationshipDescription)
            entityProperties.append(groupSetRelationship.copy() as! NSRelationshipDescription)
            
            groupRelationship.destinationEntity = actionDescription
            groupSetRelationship.destinationEntity = actionGroupDescription
            actionGroupProperties.append(groupRelationship.copy() as! NSRelationshipDescription)
            actionProperties.append(groupSetRelationship.copy() as! NSRelationshipDescription)
            
            groupRelationship.destinationEntity = relationshipDescription
            groupSetRelationship.destinationEntity = relationshipGroupDescription
            relationshipGroupProperties.append(groupRelationship.copy() as! NSRelationshipDescription)
            relationshipProperties.append(groupSetRelationship.copy() as! NSRelationshipDescription)
            
//          Inverse relationship for Subjects -- B.
            let actionSubjectSetRelationship = NSRelationshipDescription()
            actionSubjectSetRelationship.name = "subjectSet"
            actionSubjectSetRelationship.minCount = 0
            actionSubjectSetRelationship.maxCount = 0
            actionSubjectSetRelationship.optional = false
            actionSubjectSetRelationship.deleteRule = .NoActionDeleteRule
            actionSubjectSetRelationship.destinationEntity = entityDescription
            
            let actionSubjectRelationship = NSRelationshipDescription()
            actionSubjectRelationship.name = "actionSubjectSet"
            actionSubjectRelationship.minCount = 0
            actionSubjectRelationship.maxCount = 0
            actionSubjectRelationship.optional = false
            actionSubjectRelationship.deleteRule = .NoActionDeleteRule
            actionSubjectRelationship.destinationEntity = actionDescription
            actionSubjectRelationship.inverseRelationship = actionSubjectSetRelationship
            actionSubjectSetRelationship.inverseRelationship = actionSubjectRelationship
            
            entityProperties.append(actionSubjectRelationship.copy() as! NSRelationshipDescription)
            actionProperties.append(actionSubjectSetRelationship.copy() as! NSRelationshipDescription)
//          Inverse relationship for Subjects -- E.
            
//          Inverse relationship for Objects -- B.
            let actionObjectSetRelationship = NSRelationshipDescription()
            actionObjectSetRelationship.name = "objectSet"
            actionObjectSetRelationship.minCount = 0
            actionObjectSetRelationship.maxCount = 0
            actionObjectSetRelationship.optional = false
            actionObjectSetRelationship.deleteRule = .NoActionDeleteRule
            actionObjectSetRelationship.destinationEntity = entityDescription
            
            let actionObjectRelationship = NSRelationshipDescription()
            actionObjectRelationship.name = "actionObjectSet"
            actionObjectRelationship.minCount = 0
            actionObjectRelationship.maxCount = 0
            actionObjectRelationship.optional = false
            actionObjectRelationship.deleteRule = .NoActionDeleteRule
            actionObjectRelationship.destinationEntity = actionDescription
            actionObjectRelationship.inverseRelationship = actionObjectSetRelationship
            actionObjectSetRelationship.inverseRelationship = actionObjectRelationship
            
            entityProperties.append(actionObjectRelationship.copy() as! NSRelationshipDescription)
            actionProperties.append(actionObjectSetRelationship.copy() as! NSRelationshipDescription)
//          Inverse relationship for Objects -- E.
            
//          Inverse relationship for Subjects -- B.
            let relationshipSubjectSetRelationship = NSRelationshipDescription()
            relationshipSubjectSetRelationship.name = "subject"
            relationshipSubjectSetRelationship.minCount = 1
            relationshipSubjectSetRelationship.maxCount = 1
            relationshipSubjectSetRelationship.optional = true
            relationshipSubjectSetRelationship.deleteRule = .NoActionDeleteRule
            relationshipSubjectSetRelationship.destinationEntity = entityDescription
            
            let relationshipSubjectRelationship = NSRelationshipDescription()
            relationshipSubjectRelationship.name = "relationshipSubjectSet"
            relationshipSubjectRelationship.minCount = 0
            relationshipSubjectRelationship.maxCount = 0
            relationshipSubjectRelationship.optional = false
            relationshipSubjectRelationship.deleteRule = .NoActionDeleteRule
            relationshipSubjectRelationship.destinationEntity = relationshipDescription
            
            relationshipSubjectRelationship.inverseRelationship = relationshipSubjectSetRelationship
            relationshipSubjectSetRelationship.inverseRelationship = relationshipSubjectRelationship
            
            entityProperties.append(relationshipSubjectRelationship.copy() as! NSRelationshipDescription)
            relationshipProperties.append(relationshipSubjectSetRelationship.copy() as! NSRelationshipDescription)
//          Inverse relationship for Subjects -- E.
            
//          Inverse relationship for Objects -- B.
            let relationshipObjectSetRelationship = NSRelationshipDescription()
            relationshipObjectSetRelationship.name = "object"
            relationshipObjectSetRelationship.minCount = 1
            relationshipObjectSetRelationship.maxCount = 1
            relationshipObjectSetRelationship.optional = true
            relationshipObjectSetRelationship.deleteRule = .NoActionDeleteRule
            relationshipObjectSetRelationship.destinationEntity = entityDescription
            
            let relationshipObjectRelationship = NSRelationshipDescription()
            relationshipObjectRelationship.name = "relationshipObjectSet"
            relationshipObjectRelationship.minCount = 0
            relationshipObjectRelationship.maxCount = 0
            relationshipObjectRelationship.optional = false
            relationshipObjectRelationship.deleteRule = .NoActionDeleteRule
            relationshipObjectRelationship.destinationEntity = relationshipDescription
            relationshipObjectRelationship.inverseRelationship = relationshipObjectSetRelationship
            relationshipObjectSetRelationship.inverseRelationship = relationshipObjectRelationship
            
            entityProperties.append(relationshipObjectRelationship.copy() as! NSRelationshipDescription)
            relationshipProperties.append(relationshipObjectSetRelationship.copy() as! NSRelationshipDescription)
//          Inverse relationship for Objects -- E.
            
            entityDescription.properties = entityProperties as! [NSPropertyDescription]
            entityGroupDescription.properties = entityGroupProperties as! [NSPropertyDescription]
            entityPropertyDescription.properties = entityPropertyProperties as! [NSPropertyDescription]
            
            actionDescription.properties = actionProperties as! [NSPropertyDescription]
            actionGroupDescription.properties = actionGroupProperties as! [NSPropertyDescription]
            actionPropertyDescription.properties = actionPropertyProperties as! [NSPropertyDescription]
            
            relationshipDescription.properties = relationshipProperties as! [NSPropertyDescription]
            relationshipGroupDescription.properties = relationshipGroupProperties as! [NSPropertyDescription]
            relationshipPropertyDescription.properties = relationshipPropertyProperties as! [NSPropertyDescription]
            
            ModelSingleton.managedObjectModel = NSManagedObjectModel()
            ModelSingleton.managedObjectModel?.entities = [
                entityDescription,
                entityGroupDescription,
                entityPropertyDescription,
                
                actionDescription,
                actionGroupDescription,
                actionPropertyDescription,
                
                relationshipDescription,
                relationshipGroupDescription,
                relationshipPropertyDescription
            ]
        }
        return ModelSingleton.managedObjectModel!
    }
}
