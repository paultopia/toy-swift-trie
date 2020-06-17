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

testTrie.insert("") // should no longer crash
assert(testTrie.search("") == false)

testTrie.remove("ca") // shouldn't crash
testTrie.remove("car") // shouldn't crash
assert(testTrie.search("carburetor") == true)
assert(testTrie.search("car") == false)
assert(testTrie.search("cat") == true)
assert(testTrie.search("ca") == false)


print("success")
