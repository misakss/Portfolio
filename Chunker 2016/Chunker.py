# -*- coding: utf-8 -*-
"""
Created on Thu Dec  8 23:17:05 2016

@author: Martin
"""

import nltk
from nltk.corpus import treebank
import numpy as np

def chunker(data):
    """
    This function takes a dataset of sentences as input and gives
    as output all the rules in the data, and the percentage of how
    much the rule has been used in the dataset. The rules depends
    on what the variable grammar is set to in the code.
    """
    
    # Set the grammar rules
    grammar = """NP: {<DT|PP\$>?<JJ>*<NN>}
                     {<NNP>+}
    """
    
    cp = nltk.RegexpParser(grammar)
    
    result = [None]*len(data)
    for i in range(len(data)):
        result[i] = cp.parse(data[i])
    
    # Draw the tree for visualization
    # result.draw()
    
    # Find the position in the tree-list of the NPs and
    # get the different NP-trees representing a rule in a list
    indx = []
    rules_tree = []
    for i in range(len(result)):
        [indx.append(idx) for idx,tree in list(enumerate(result[i])) if type(tree[0]) == tuple]
        [rules_tree.append(result[i][j]) for j in indx]
        indx = []
        
    # Get the number of tags/cathegories for each rule
    num_tags = []
    for i in range(len(rules_tree)):
        num_tags.append(len(rules_tree[i]))
    
    # Get the different tags/cathegories in a list, in the order of:
    # [Rule1,Rule2,Rule3,...]
    rules_cat = []
    for i in range(len(rules_tree)):
        for j in range(num_tags[i]):
            rules_cat.append(rules_tree[i][j][1])
    
    # Divide the whole list into sublists of each rule:
    # [[Rule1],[Rule2],[Rule3],...]
    rules = []
    cum_sum = np.cumsum(num_tags)
    for i in range(len(num_tags)):
        if i == 0:
            rules.append(rules_cat[0:num_tags[i]])
        elif i > 0:
            rules.append(rules_cat[cum_sum[i-1]:cum_sum[i]])
            
    # Count how many times each rule appears in the whole rule-list
    rules_count = [None]*len(rules)
    for i in range(len(rules)):
        rules_count[i] = (rules[i],rules.count(rules[i]))
    
    # Get the unique rules and their counts
    used = []
    rules_unique = [x for x in rules_count if x not in used and (used.append(x) or True)]
    
    # Normalize the counts so that the treebank-grammar becomes probabilistic and
    # create a list containing the rules (tuples) with the corresponing prob
    total_counts = [rules_unique[i][1] for i in range(len(rules_unique))]
    
    sum_count = sum(total_counts)
    
    rules_prob = []
    for item in rules_unique:
        rules_prob.append((item[0],item[1]/sum_count)) # Sum of prob = 1 
        
    return rules_prob

sentences = treebank.tagged_sents()

train_len = round(0.9*len(sentences))

data_train = sentences[0:train_len]

data_test = sentences[train_len+1:-1]

rules_train = chunker(data_train)

rules_test = chunker(data_test)

# Compare how many rules found in data_test that match with the rules in data_train

test_rules = []
for rule in rules_test:
    test_rules.append(rule[0])

match, miss = 0, 0
for train_rule in rules_train:
    if train_rule[0] in test_rules:
        match += 1
    else:
        miss += 1

print('Train-data results: ',rules_train)
print('Test-data results: ',rules_test)
print('--------------------------------------------------')
print('Matching rules: ',match)
print('Missing rules: ',miss)

