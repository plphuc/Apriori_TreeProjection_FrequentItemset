module apriori

export Transaction, read_csv, apriori_gen, apriori_run

struct Transaction
    items::Vector{Int}
end

function union(itemset1::Vector{Int}, itemset2::Vector{Int})
    collect(Set(vcat(itemset1, itemset2)))
end

function isin_Nonitemset(nonitemset, itemset)
        for item in nonitemset
            if issubset(item, itemset)
                return true 
            end
        end
    return false
end

function apriori_gen(frequent_itemsets, k)
    k_itemsets = Set()

    for item1 in frequent_itemsets
        for item2 in frequent_itemsets
            newItem = union(item1, item2)
            if length(newItem) == k
                sort!(newItem)
                push!(k_itemsets, newItem)
            end
        end
    end
    return sort!(collect(k_itemsets))
end

function apriori_run(filename::String, minsupport)
    lines = strip.(readlines(filename))
    frequent_itemsets = Set()
    k_itemsets = Set()
    non_frequent_itemsets = []
    F = []
    transactions = []

    for line in lines
        transaction = Transaction([parse(Int, ss) for ss in split(line)])
        push!(transactions, transaction)

        for item in transaction.items
            push!(k_itemsets, [item])
        end
    end

    minSupCount = floor(Int, length(transactions)*minsupport)

    for itemset in k_itemsets
        count = 0
        for transaction in transactions
            if issubset(itemset, transaction.items)
                count += 1
                if count == minSupCount
                    push!(F, itemset)
                    push!(frequent_itemsets, itemset)
                end
            end
        end
    end
    sort!(F)
    k = 2

    k_itemsets = apriori_gen(frequent_itemsets, k)

    for itemset in k_itemsets
        count = 0
        for transaction in transactions
            if issubset(itemset, transaction.items)
                count += 1
                if count == minSupCount
                    push!(F, itemset)
                    push!(frequent_itemsets, itemset)
                    break
                end
            end
        end
        if count < minSupCount
            push!(non_frequent_itemsets, itemset)
        end
    end

    if length(F) == 0
        return F
    end

    k = 3
    while (true)
        Lk = []
        k_itemsets = apriori_gen(frequent_itemsets, k)
        for itemset in k_itemsets
            count = 0

            if isin_Nonitemset(non_frequent_itemsets, itemset)
                continue
            end

            for transaction in transactions
                if issubset(itemset, transaction.items)
                    count += 1
                    if count == minSupCount
                        push!(Lk, itemset)
                        push!(frequent_itemsets, itemset)
                        break
                    end
                end
            end
        end
        
        if length(Lk) == 0
            break
        end

        F = vcat(F, Lk)

        k += 1

    end       
    return F, minsupport
end
end