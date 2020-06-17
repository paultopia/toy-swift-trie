struct Trie {
    let root: Node
    init() {
        root = Node()
    }
    func search(_ word: String) -> Bool {
        var curNode = root
        for letter in word {
            guard let node = curNode.children[letter] else {
                return false
            }
            curNode = node
        }
        return curNode.contained
    }
    
    func remove(_ word: String) {
        guard search(word) else {
            return
        }
        var curNode = root
        for letter in word {
            guard let node = curNode.children[letter] else {
                return
            }
            curNode = node
        }
        curNode.contained = false
    }
    
    func insert(_ letters: Substring, parent: Node) -> Node {
        if letters.count == 1 {
            let letter = letters.first!
            if parent.children.contains(where: {(key, _) in
                key == letter
            }) {
                print("should be here")
                parent.children[letter]!.contained = true
                return parent
            } else {
                return Node(letter, final: true)
            }
        } else {
            let first = letters.first!
            let rest = letters.dropFirst()
            if let subtree = parent.children.first(where: {(key, _) in
                           key == first
            }) {
                let newNode = Node(first, final: subtree.value.contained, kids: subtree.value.children)
                newNode.children[rest.first!] = insert(rest, parent: newNode)
                return newNode

            } else {
            let newNode = Node(first, final: false)
                newNode.children[rest.first!] = insert(rest, parent: newNode)
            return newNode
            }
        }
    }
    func insert(_ word: String) {
        if word.count == 0 {
            return
        }
        if word.count == 1 {
            if root.children[word.first!] != nil {
                root.children[word.first!]!.contained = true
            } else {
                root.children[word.first!] = Node("x", final: true, kids: [:])
            }
        }
        if search(word) {
            return
        }
        let new_subtree = insert(word[...], parent: root)
        root.children[word.first!] = new_subtree
    }
}

class Node {
    var children: [Character:Node]
    var contained: Bool
    init() {
        children = [:]
        contained = false
    }
    init(_ c: Character, final: Bool) {
        children = [:]
        contained = final
    }
    init(_ c: Character, final: Bool, kids: [Character:Node]) {
        children = kids
        contained = final
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

// single-letter inserts, just to make sure I didn't screw that up.
assert(testTrie.search("c") == false)
testTrie.insert("c")
assert(testTrie.search("c") == true)
assert(testTrie.search("ca") == false)
testTrie.remove("c")
assert(testTrie.search("c") == false)
assert(testTrie.search("cat") == true)
assert(testTrie.search("car") == false)

// two-letter inserts because I'm paranoid
assert(testTrie.search("ca") == false)
testTrie.insert("ca")
assert(testTrie.search("ca") == true)
assert(testTrie.search("c") == false)
assert(testTrie.search("cat") == true)
assert(testTrie.search("car") == false)


print("success")
