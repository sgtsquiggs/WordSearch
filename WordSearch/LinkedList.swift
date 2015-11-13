//
//  LinkedList.swift
//  WordSearch
//
//  Created by Matthew Crenshaw on 11/12/15.
//  Copyright © 2015 Matthew Crenshaw. All rights reserved.
//

import Foundation

class Node<T: Equatable> {
    var value: T?
    var next: Node?
}

class LinkedList<T: Equatable> {
    var head = Node<T>()
    var last: Node<T> {
        var node = head
        while node.next != nil {
            node = node.next!
        }
        return node
    }

    func append(value: T) {
        let newNode = Node<T>()
        newNode.value = value
        last.next = newNode
    }

    func remove(value: T) {
        var node = head
        var prevNode: Node<T>?
        while node.value != value && node.next != nil {
            prevNode = node
            node = node.next!
        }

        if node.value == value {
            prevNode?.next = node.next
        }
    }
}
