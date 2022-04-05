include("./apriori.jl")
using .apriori

elapsedTime = @elapsed F, minsup= @time apriori_run("data/retail.txt", 0.01)
len = length(F)
open("result/retail_apriori.txt","w") do io 
    println(io, "Min support: $minsup")
    println(io,"Elapsed time: $elapsedTime")
    println(io, "Frequent itemsets has $len itemsets")
    for itemset in F
        println(io,itemset)
    end
end

elapsedTime = @elapsed F, minsup = @time apriori_run("data/foodmartFIM.txt", 0.004)
len = length(F)
open("result/foodmartFIM_apriori.txt","w") do io 
    println(io, "Min support: $minsup")
    println(io,"Elapsed time: $elapsedTime")
    println(io, "Frequent itemsets has $len itemsets")
    for itemset in F
        println(io,itemset)
    end
end

elapsedTime = @elapsed F, minsup = @time apriori_run("data/chess.txt", 0.75)
len = length(F)
open("result/chess_apriori.txt","w") do io 
    println(io, "Min support: $minsup")
    println(io,"Elapsed time: $elapsedTime")
    println(io, "Frequent itemsets has $len itemsets")
    for itemset in F
        println(io,itemset)
    end
end

elapsedTime = @elapsed F, minsup = @time apriori_run("data/mushrooms.txt", 0.4)
len = length(F)
open("result/mushrooms_apriori.txt","w") do io 
    println(io, "Min support: $minsup")
    println(io,"Elapsed time: $elapsedTime")
    println(io, "Frequent itemsets has $len itemsets")
    for itemset in F
        println(io,itemset)
    end
end