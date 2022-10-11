

# Build a Node class. It should have an attribute for the data it stores as well as its left and right children. As a bonus, try including the Comparable module and compare nodes using their data attribute.


module Comparable
    def compare(node1,node2)
        if node1.data == node2.data
            "equal"
        else
            "not equal"
        end
    end
end

class Node
    include Comparable 
    attr_accessor :data, :left, :right
    @@list_of_nodes = []
    def initialize(data)
        @data = data
        @left = nil
        @right = nil
        @@list_of_nodes << self
        self
    end
end


# Build a Tree class which accepts an array when initialized. The Tree class should have a root attribute which uses the return value of #build_tree which you’ll write next.

class Tree < Node
    attr_accessor :root

    def initialize(array)
        @root = build_tree(array.sort.uniq, 0, (array.length-1))
    end


# Write a #build_tree method which takes an array of data (e.g. [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]) and turns it into a balanced binary tree full of Node objects appropriately placed (don’t forget to sort and remove duplicates!). The #build_tree 
# method should return the level-0 root node.
    
    def build_tree(array, start = 0, ending = array.length+1)
            if start > ending
                nil 
            else
                mid = (start+ending)/2
                root = Node.new(array[mid])
                root.left = build_tree(array, start, mid-1)
                root.right = build_tree(array, mid+1, ending)
            end
            root
    end

    def pretty_print(node = @root, prefix = '', is_left = true)
        pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
        pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
    end

    def find(value, node = root)
        return node if node.nil? || node.data == value
    
        value < node.data ? find(value, node.left) : find(value, node.right)
      end

# THIS FUNCTION WORKS BUT DOESN'T ACTUALL INSERT THE NODE IN THE FUCKING TREE
    # def insert(value, node = root)
    #     if node == nil
    #         node = Node.new(value)
    #         root = node
        
    #     elsif value < node.data
    #         insert(value, node.left) 
    #     elsif value > node.data
    #         insert(value, node.right)
    #     end
    # end

# took this one from an article. I still don't know why this one does a different job than the one above...it seems I'm missing a step or something...

    def insert(value)
        if root == nil
            root = Node.new(value)
        else
            curr_node = @root
            prev_node = @root
        
        while curr_node != nil
            prev_node = curr_node
            if value < curr_node.data
                curr_node = curr_node.left
            else
                curr_node = curr_node.right
            end 
        end
        if value < prev_node.data
            prev_node.left = Node.new(value)
        else
            prev_node.right = Node.new(value)
        end
        end
    end

# when the function is 30 lines long... there must be something off
    # def delete(value)
    #     node = find(value)
    #     parent = find_parent(value)
    #     if node.left == nil && node.right == nil
    #         if parent.left.data == value
    #             parent.left = nil
    #         else 
    #             parent.right = nil
    #         end
    #     elsif node.left == nil && node.right != nil
    #         if parent.right.data == value
    #             parent.right = node.right
    #         else 
    #             parent.left = node.right
    #         end
    #     elsif node.left != nil && node.right == nil
    #         if parent.left.data == value
    #             parent.left = node.left
    #         else 
    #             parent.right = node.left
    #         end
    #     else
    #         new_node = find(minv(node.right))
    #         new_parent = find_parent(new_node.data)
    #         if parent.left.data == value
    #             parent.left = new_node
    #             if new_parent.left.data == new_node.data
    #                 new_parent.left = nil
    #             else 
    #                 new_parent.right = nil
    #             end
    #         else 
    #             parent.right = new_node
    #             if parent.left.data == value
    #                 parent.left = new_node
    #                 if new_parent.left.data == new_node.data
    #                     new_parent.left = nil
    #                 else 
    #                     new_parent.right = nil
    #                 end
    #             end
    #         end
    #     node
    # end

#gonna try this one I found online

def delete(value, node = root)
    return node if node.nil?

    if value < node.data
      node.left = delete(value, node.left)
    elsif value > node.data
      node.right = delete(value, node.right)
    else
      # if node has one or no child
      return node.right if node.left.nil?
      return node.left if node.right.nil?

      # if node has two children
      leftmost_node = leftmost_leaf(node.right)
      node.data = leftmost_node.data
      node.right = delete(leftmost_node.data, node.right)
    end
    node
  end

  def leftmost_leaf(node)
    node = node.left until node.left.nil?

    node
  end

def minValue(node = root)
    minv = node.data
    while node.left != nil
        minv = node.left.data
        node = node.left
    end
    minv
end 

def inorderRec(node = root)
    if node != nil
        inorderRec(node.left);
        puts "#{node.data} ";
        inorderRec(node.right);
    end
end

# Write an #insert and #delete method which accepts a value to insert/delete (you’ll have to deal with several cases for delete such as when a node has children or not). If you need additional resources, check out these two articles on inserting and deleting, or this video with several visual examples.

# Write a #find method which accepts a value and returns the node with the given value.

# Write a #level_order method which accepts a block. This method should traverse the tree in breadth-first level order and yield each node to the provided block. This method can be implemented using either iteration or recursion (try implementing both!). The method should return an array of values if no block is given. Tip: You will want to use an array acting as a queue to keep track of all the child nodes that you have yet to traverse and to add new ones to the list (as you saw in the video).

def level_order(node = root, queue = [])
    print "#{node.data} "
    queue << node.left unless node.left.nil?
    queue << node.right unless node.right.nil?
    return if queue.empty?

    level_order(queue.shift, queue)
  end

# Write #inorder, #preorder, and #postorder methods that accepts a block. Each method should traverse the tree in their respective depth-first order and yield each node to the provided block. The methods should return an array of values if no block is given.
def preorder(node = root)
    # Root Left Right
    return if node.nil?

    puts "#{node.data} "
    preorder(node.left)
    preorder(node.right)
  end

  def inorder(node = root)
    # Left Root Right
    return if node.nil?

    inorder(node.left)
    puts "#{node.data} "
    inorder(node.right)
  end

  def postorder(node = root)
    # Left Right Root
    return if node.nil?

    postorder(node.left)
    postorder(node.right)
    puts "#{node.data} "
  end
  

# Write a #height method which accepts a node and returns its height. Height is defined as the number of edges in longest path from a given node to a leaf node.

def height(node = root, count = -1)
    return count if node.nil?

    count += 1
    [height(node.left, count), height(node.right, count)].max
  end


# Write a #depth method which accepts a node and returns its depth. Depth is defined as the number of edges in path from a given node to the tree’s root node.

def depth(node = root, parent = root, edges = 0)
    return 0 if node == parent
    return -1 if parent.nil?

    if node < parent.data
      edges += 1
      depth(node, parent.left, edges)
    elsif node > parent.data
      edges += 1
      depth(node, parent.right, edges)
    else
      edges
    end
  end


# Write a #balanced? method which checks if the tree is balanced. A balanced tree is one where the difference between heights of left subtree and right subtree of every node is not more than 1.

def balanced?(node = root)
    #Find the height of the left subtree
    #Find the height of the right subtree
    #If left_branch height is == right_branch height (+- 1) true, else false
    left_height = height(node.left, 0)
    right_height = height(node.right, 0)
    return true if (left_height - right_height).between?(-1,1)
    false
  end



# Write a #rebalance method which rebalances an unbalanced tree. Tip: You’ll want to use a traversal method to provide a new array to the #build_tree method.

def rebalance
    self.data = inorder_array
    p inorder_array
    self.root = build_tree(data)
  end

  def inorder_array(node = root, array = [])
    unless node.nil?
      inorder_array(node.left, array)
      array << node.data
      inorder_array(node.right, array)
    end
    array
  end

# Tie it all together

# Write a simple driver script that does the following:

# Create a binary search tree from an array of random numbers (Array.new(15) { rand(1..100) })
# Confirm that the tree is balanced by calling #balanced?
# Print out all elements in level, pre, post, and in order
# Unbalance the tree by adding several numbers > 100
# Confirm that the tree is unbalanced by calling #balanced?
# Balance the tree by calling #rebalance
# Confirm that the tree is balanced by calling #balanced?
# Print out all elements in level, pre, post, and in order


end


array = Array.new(15) { rand(1..100) }
bst = Tree.new(array)

bst.pretty_print

puts bst.balanced? ? 'Your Binary Search Tree is balanced.' : 'Your Binary Search Tree is not balanced.'

puts 'Level order traversal: '
puts bst.level_order

puts 'Preorder traversal: '
puts bst.preorder

puts 'Inorder traversal: '
puts bst.inorder

puts 'Postorder traversal: '
puts bst.postorder

10.times do
  a = rand(100..150)
  bst.insert(a)
  puts "Inserted #{a} to tree."
end

bst.pretty_print

puts bst.balanced? ? 'Your Binary Search Tree is balanced.' : 'Your Binary Search Tree is not balanced.'

puts 'Rebalancig tree...'
bst.rebalance

bst.pretty_print

puts bst.balanced? ? 'Your Binary Search Tree is balanced.' : 'Your Binary Search Tree is not balanced.'

puts 'Level order traversal: '
puts bst.level_order

puts 'Preorder traversal: '
puts bst.preorder

puts 'Inorder traversal: '
puts bst.inorder

puts 'Postorder traversal: '
puts bst.postorder


