struct Trie {
    class Node {
        var children: [Character:Node] = [:]
        var contained: Bool = false
    }
    let root: Node = Node()
    func search(_ word: String) -> Bool {
        var curNode = root
        for char in word {
            guard let node = curNode.children[char] else { return false }
            curNode = node
        }
        return curNode.contained
    }
    
    func remove(_ word: String) {
        guard search(word) else { return }
        var curNode = root
        for char in word {
            guard let node = curNode.children[char] else { return }
            curNode = node
        }
        curNode.contained = false
    }
    
    func insert(_ word: Substring, atNode node: Node) {
        if let char = word.first {
            if let nextNode = node.children[char] {
                insert(word.dropFirst(), atNode: nextNode)
            } else {
                let newNode = Node()
                node.children[char] = newNode
                insert(word.dropFirst(), atNode: newNode)
            }
        } else {
            node.contained = true
        }
    }

    func insert(_ word: String) {
        if word.count == 0 { return }
        insert(word[...], atNode: root)
    }
}



var testTrie = Trie()

testTrie.insert("cat")
assert(testTrie.search("cat") == true)
assert(testTrie.search("car") == false)

testTrie.insert("car")
assert(testTrie.search("car") == true)
assert(testTrie.search("cat") == true)
assert(testTrie.search("ca") == false)
assert(testTrie.search("cad") == false)
assert(testTrie.search("carburetor") == false)

testTrie.insert("carburetor")
assert(testTrie.search("carburetor") == true)
assert(testTrie.search("car") == true)
assert(testTrie.search("cat") == true)
assert(testTrie.search("ca") == false)

testTrie.remove("car")
assert(testTrie.search("carburetor") == true)
assert(testTrie.search("car") == false)
assert(testTrie.search("cat") == true)

// inserting empty strings (should be a no-op)
testTrie.insert("")
assert(testTrie.search("") == false)

// removing nonexistent items (should be a no-op)
testTrie.remove("ca") // shouldn't crash
testTrie.remove("car") // shouldn't crash
assert(testTrie.search("carburetor") == true)
assert(testTrie.search("car") == false)
assert(testTrie.search("cat") == true)
assert(testTrie.search("ca") == false)

// repeated inserts (should be a no-op)
testTrie.insert("cat")
testTrie.insert("cat")
testTrie.insert("cat")
assert(testTrie.search("cat") == true)
assert(testTrie.search("car") == false)
assert(testTrie.search("ca") == false)

// single-char inserts, just to make sure I didn't screw that up.
assert(testTrie.search("c") == false)
testTrie.insert("c")
assert(testTrie.search("c") == true)
assert(testTrie.search("ca") == false)
testTrie.remove("c")
assert(testTrie.search("c") == false)
assert(testTrie.search("cat") == true)
assert(testTrie.search("car") == false)

// two-char inserts because I'm paranoid
assert(testTrie.search("ca") == false)
testTrie.insert("ca")
assert(testTrie.search("ca") == true)
assert(testTrie.search("c") == false)
assert(testTrie.search("cat") == true)
assert(testTrie.search("car") == false)


print("success")
