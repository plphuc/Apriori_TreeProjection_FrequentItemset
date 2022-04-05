include("./treeprojection.jl")
using .TreeProjection

# elapsedTime = @elapsed root, minsup = @time tp_run("data/mushrooms.txt", 0.4)
# result = BFS(root)
# len = length(result) - 1
# open("result/mushrooms_TP.txt", "w") do file
#     println(file , "Min support: $minsup")
#     println(file ,"Elapsed time: $elapsedTime")
#     println(file , "Frequent itemsets has $len itemsets")
#     for itemset in result[2:end]
#         write(file, "$itemset\n")
#     end
# end

# elapsedTime = @elapsed root, minsup = @time tp_run("data/retail.txt", 0.01)
# result = BFS(root)
# len = length(result) - 1
# open("result/retail_TP.txt", "w") do file
#     println(file , "Min support: $minsup")
#     println(file ,"Elapsed time: $elapsedTime")
#     println(file , "Frequent itemsets has $len itemsets")
#     for itemset in result[2:end]
#         write(file, "$itemset\n")
#     end
# end

elapsedTime = @elapsed root, minsup = @time tp_run("data/foodmartFIM.txt", 0.004)
result = BFS(root)
len = length(result) - 1
open("result/foodmartFIM_TP.txt", "w") do file
    println(file , "Min support: $minsup")
    println(file ,"Elapsed time: $elapsedTime")
    println(file , "Frequent itemsets has $len itemsets")
    for itemset in result[2:end]
        write(file, "$itemset\n")
    end
end


elapsedTime = @elapsed root, minsup = @time tp_run("data/chess.txt", 0.75)
result = BFS(root)
len = length(result) - 1
open("result/chess_TP.txt", "w") do file
    println(file , "Min support: $minsup")
    println(file ,"Elapsed time: $elapsedTime")
    println(file , "Frequent itemsets has $len itemsets")
    for itemset in result[2:end]
        write(file, "$itemset\n")
    end
end