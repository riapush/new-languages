import Foundation

// Структура для узла бинарного дерева
class TreeNode {
    var value: Int
    var left: TreeNode?
    var right: TreeNode?
    
    init(_ value: Int) {
        self.value = value
        self.left = nil
        self.right = nil
    }
}

// Функция для создания бинарного дерева из строки
func buildBinaryTree(from string: String) -> TreeNode? {
    let values = string.split(separator: " ").compactMap { Int($0) }
    var index = 0
    
    // Вспомогательная функция для создания дерева
    func buildTree() -> TreeNode? {
        guard index < values.count else {
            return nil
        }
        
        let value = values[index]
        index += 1
        
        if value == -1 { // -1 используется для представления пустых узлов
            return nil
        }
        
        let node = TreeNode(value)
        node.left = buildTree()
        node.right = buildTree()
        return node
    }
    
    return buildTree()
}

func printBinaryTreeDFS(_ node: TreeNode?) {
    guard let node = node else {
        return
    }
    
    print(node.value)
    printBinaryTreeDFS(node.left)
    printBinaryTreeDFS(node.right)
}


let filename = "tree.txt"

if let treeString = try? String(contentsOfFile: filename) {
    if let root = buildBinaryTree(from: treeString) {
        printBinaryTreeDFS(root)
    } else {
        print("Не смог напечатать дерево")
    }
} else {
    print("Не смог прочитать файл")
}