package ast

fun checkTreeStructure(element: ASTNode?) {
    if (true) {
        doCheckTreeStructure(element)
    }
}

fun doCheckTreeStructure(anyElement: ASTNode?) {
    if (anyElement == null) return
    var root: ASTNode = anyElement
    while (root.treeParent != null) {
        root = root.treeParent!!
    }
    if (root is CompositeElement) {
        checkSubtree(root)
    }
}

private fun checkSubtree(root: CompositeElement) {
    if (root.rawFirstChild() == null) {
        if (root.rawLastChild() != null) {
            throw IncorrectTreeStructureException(root, "firstChild == null, but lastChild != null")
        }
    } else {
        var child = root.firstChildNode
        while (child != null) {
            if (child is CompositeElement) {
                checkSubtree(child as CompositeElement)
            }
            if (child!!.treeParent !== root) {
                throw IncorrectTreeStructureException(child, "child has wrong parent value")
            }
            if (child === root.firstChildNode) {
                if (child!!.treePrev != null) {
                    throw IncorrectTreeStructureException(root, "firstChild.prev != null")
                }
            } else {
                if (child!!.treePrev == null) {
                    throw IncorrectTreeStructureException(child, "not first child has prev == null")
                }
                if (child!!.treePrev!!.treeNext !== child) {
                    throw IncorrectTreeStructureException(child, "element.prev.next != element")
                }
            }
            if (child!!.treeNext == null) {
                if (root.lastChildNode !== child) {
                    throw IncorrectTreeStructureException(child, "not last child has next == null")
                }
            }
            child = child!!.treeNext
        }
    }
}

class IncorrectTreeStructureException(val element: ASTNode, message: String) : RuntimeException(message)