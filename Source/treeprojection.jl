module TreeProjection
using Setfield
export Transaction, tp_run, BFS

struct TreeNode
    parent
    children
    matrix
    level
    name
    count
    active
    TreeNode() = new()
    TreeNode(parent, children, matrix, level, name, count, active) = new(parent, children, matrix, level, name, count, active)
    TreeNode(parent, name, level) = new(parent, Any[], Matrix{Any}[], level, name, 0, true)
    TreeNode(parent, name, level, count) = new(parent, Any[], Matrix{Any}[], level, name, count, true)
end

struct Transaction
    items::Vector{Int}
end

function union(itemset1::Vector{Int}, itemset2::Vector{Int})
    collect(Set(vcat(itemset1, itemset2)))
end

function createMatrices(node::TreeNode, level::Int)
    if (node.level == level)
        n = length(node.children)
        node = @set node.matrix = zeros((n, n))
        return node
    else
        children = []
        for child in node.children
            if child.active
                child = createMatrices(child, level)
            end
            push!(children, child)
        end
        node = @set node.children = children
        return node
    end
end

function tp_run(filename::String,minsupport)

    rootNode=TreeNode(nothing, nothing, 0)

    lines = strip.(readlines(filename))
    itemsets = Set()
    transactions = []
    
    for line in lines
        transaction = Transaction([parse(Int, ss) for ss in split(line)])
        push!(transactions, transaction)

        for item in transaction.items
            push!(itemsets, [item])
        end
    end

    minSupCount = floor(Int, length(transactions) * minsupport)

    n = length(itemsets)

    rootNode = @set rootNode.matrix = zeros((n,n))

    F = []
    freqCount = []

    for itemset in sort(collect(itemsets))
        count = 0
        for transaction in transactions
            if issubset(itemset, transaction.items)
                count += 1
            end
        end
        push!(freqCount, count)
        push!(F, itemset)
    end
    
    childNodes = []

    for (idx, child) in enumerate(F)
        push!(childNodes, TreeNode(rootNode, child[1], 1, freqCount[idx]))
    end

    rootNode = @set rootNode.children = childNodes

    k = 1

    while rootNode.active
        rootNode = createMatrices(rootNode, k - 1)
        for transaction in transactions
            rootNode = addCounts(transaction.items, rootNode, k - 1)
        end
        createNewNodes(rootNode, k, minSupCount)
        rootNode = pruneTree(rootNode, k-1, minSupCount)
        k+=1
    end

    return rootNode, minsupport

end

function pruneTree(node::TreeNode, level::Int, minSupCount::Int)
    if (node.level == level)
        if length(node.children) == 0
            if (node.count < minSupCount)
                node = nothing
            else
                node = @set node.active = false
            end
        end
        return node
    else
        children = []
        active = false
        for child in node.children
            child = pruneTree(child, level, minSupCount)
            if child !== nothing
                push!(children, child)
                if child.active
                    active = true
                end
            end
        end
        node = @set node.children = children
        node = @set node.active = active
        return node
    end
end

function createNewNodes(node::TreeNode, level::Int, minSupCount::Int)
    if (node.level == level - 1)
        n = length(node.children)
        for i in 1:n
            for j in 1:n
                if (node.matrix[i, j] >= minSupCount)
                    newNode = TreeNode(node, Any[], Matrix{Any}[], level + 1, node.children[j].name, node.matrix[i, j], true)
                    push!(node.children[i].children, newNode)
                end
            end
        end
    else
        for child in node.children
            createNewNodes(child, level, minSupCount)
        end
    end
end

function addCounts(transaction, node, level)
    if (node.level == level)
        for (idx1, child1) in enumerate(node.children)
            for (idx2, child2) in enumerate(node.children)
                if (idx1 < idx2)
                    if (child1.name in transaction && child2.name in transaction)
                        matrix = node.matrix
                        matrix[idx1, idx2] += 1
                        node = @set node.matrix = matrix
                    end
                end
            end
        end
        return node
    else

        findList = findall(x->x==node.name, transaction)

        if node.name !== nothing
            T = transaction
            if length(findList) > 0
                deleteat!(T, findList)
            else
                return node
            end
        else
            T = transaction
        end

        children = []

        for childNode in node.children
            if childNode.active
                childNode = addCounts(T, childNode, level)
            end
            push!(children, childNode)
        end 

        node = @set node.children = children

        return node
    end
end

function BFS(node::TreeNode)
    queue = []
    result = []
    push!(queue, ("", node))
    while length(queue) > 0
        tup = queue[1]

        if tup[2].name !== nothing
            itemset = "$(tup[1])$(tup[2].name)"
        else
            itemset = ""
        end

        deleteat!(queue, 1)
        push!(result, strip(itemset))

        node = tup[2]

        for child in node.children
            push!(queue, ("$itemset ", child))
        end
    end
    return result
end
end