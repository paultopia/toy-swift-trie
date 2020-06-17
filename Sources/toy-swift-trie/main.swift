struct Trie {
    var root: Node
    init() {
        root = Node()
    }
    func search(_ word: String) -> Bool {
        let letters = Array(word)
        var curnode = root
        for letter in letters {
            guard let match = curnode.children.first(where: {(key, _) in
                key == letter
            })
                else {
                    return false
            }
            curnode = match.value
        }
        if curnode.contained {
            return true
        }
        return false
    }
    
    func remove(_ word: String) {
        let letters = Array(word)
        var curnode = root
        for letter in letters {
            if !curnode.children.contains(where: {(key, _) in
                key == letter
            }) {
                break
            } else {
                curnode = curnode.children[letter]!
            }
        }
        curnode.contained = false
    }
    
    func insert(_ letters: [Character], parent: Node) -> Node {
        if letters.count == 1 {
            let letter = letters[0]
            if parent.children.contains(where: {(key, _) in
                key == letter
            }) {
                let newNode = parent
                newNode.children[letter]!.contained = true
                return newNode
            } else {
                let newNode = Node(letter, final: true)
                return newNode
            }
        } else {
            let first = letters[0]
            let rest = Array(letters.dropFirst())
            if let subtree = parent.children.first(where: {(key, _) in
                           key == first
            }) {
                let newNode = Node(first, final: subtree.value.contained, kids: subtree.value.children)
                newNode.children[rest[0]] = insert(rest, parent: newNode)
                return newNode

            } else {
            let newNode = Node(first, final: false)
            newNode.children[rest[0]] = insert(rest, parent: newNode)
            return newNode
            }
        }
    }
    mutating func insert(_ word: String) {
        let new_subtree = insert(Array(word), parent: root)
        root.children[new_subtree.char!] = new_subtree
    }
}

class Node {
    var char: Character?
    var children: [Character:Node]
    var contained: Bool
    init() {
        char = nil
        children = [:]
        contained = false
    }
    init(_ c: Character, final: Bool) {
        children = [:]
        contained = final
        char = c
    }
    init(_ c: Character, final: Bool, kids: [Character:Node]) {
        children = kids
        contained = final
        char = c
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
print("success")
