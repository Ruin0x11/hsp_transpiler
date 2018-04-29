package ast

import java.util.LinkedList
import java.util.function.Consumer


interface ASTNode {
    val elementType: ElementType

    val text: String

    val treeParent: ASTNode?
    val firstChildNode: ASTNode?
    val lastChildNode: ASTNode?
    val treeNext: ASTNode?
    val treePrev: ASTNode?

    fun findChildByType(type: ElementType): ASTNode?
}

abstract class Node(private val myType: ElementType) {
    public val childNodes = LinkedList<Node>()
    private val parentNode: Node? = null

    fun treeIterable(traversal: TreeTraversal): Iterator<Node> =
        when(traversal) {
            TreeTraversal.BreadthFirst -> BreadthFirstIterator(this)
        }

    fun walk(traversal: TreeTraversal, consumer: Consumer<Node>) {
        for (node in treeIterable(traversal)) {
            consumer.accept(node)
        }
    }
}

enum class TreeTraversal {
    BreadthFirst,
}

class BreadthFirstIterator(node: Node) : Iterator<Node> {
    private val queue = LinkedList<Node>()

    init {
        queue.add(node)
    }

    override fun hasNext(): Boolean {
        return !queue.isEmpty()
    }

    override fun next(): Node {
        val next = queue.remove()
        queue.addAll(next.childNodes)
        return next
    }
}

// TODO: add visitor for ast