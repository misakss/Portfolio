# -*- coding: utf-8 -*-
"""
Created on Thu Dec  8 23:17:05 2016

@author: Martin
"""

import nltk
from nltk.corpus import treebank
from nltk.tree import *
from nltk import Nonterminal, nonterminals, Production, CFG

def chunker(parsedData):
    """
    Extract the grammar rules from the input parsed text and assign
    each rule with the probability of it occuring in the parsed text.
    """
    tags_words = treebank.tagged_words()
      
    # This is the list where all the rules will be stored, for
    # construction of the PCFG
    rules = []
    NP = Nonterminal('NP')
    rhs_rules = []
    
    # Extract the rules from the training-data
    for sent in parsedData:
        for production in sent.productions():
            rhs_rules = []
            [rhs_rules.append(i == NP) for i in production.rhs()]
            if production.lhs() == NP and not any(rhs_rules):
                rules.append(production)
    
    # Add the lexical rules
    for word, tag in tags_words:
        
        # For each tagged word, create a tree containing that
        # lexical rule 
        # This is to be able to add it to the list rules
        t = Tree.fromstring("("+ tag + " " + word  +")")
        for production in t.productions():
            rhs_rules = []
            [rhs_rules.append(i == NP) for i in production.rhs()]
            if production.lhs() == NP and not any(rhs_rules):
                rules.append(production)
          
    # All the syntactic rules and all of the lexical rules 
    # are extracted from the training-data
    # Here the PCFG is extracted
    rules_prob = nltk.grammar.induce_pcfg(Nonterminal('S'), rules)
    return rules_prob
    
def accuracy(train_rules, test_rules, prob_thresh):
    """
    Gives the false-positive and false-negative as outputs.
    The variable prob_thresh is the value where all the rules with
    a probability lower than prob_thresh will be discarded.
    """
    rules_train = []
    for rule in train_rules.productions():
        if rule.prob() > prob_thresh:
            rules_train.append(rule.rhs())
    
    rules_test = []
    for rule in test_rules.productions():
        if rule.prob() > prob_thresh:
            rules_test.append(rule.rhs())
    
    falsePositive = 0
    for train_rule in rules_train:
        if train_rule not in rules_test:
            falsePositive += 1
            
    falseNegative = 0
    for test_rule in rules_test:
        if test_rule not in rules_train:
            falseNegative += 1
            
    return falsePositive, falseNegative

#----------------------------------- MAIN -----------------------------------

sentences = treebank.parsed_sents()

train_len = round(0.9*len(sentences))
data_train = sentences[0:train_len]
data_test = sentences[train_len+1:-1]

train_rules = chunker(data_train)
test_rules = chunker(data_test)

# All the rules with a probability under the value of
# prob_thresh will be discarded
prob_thresh = 0

falsePositive, falseNegative = accuracy(train_rules, test_rules, prob_thresh)

print('False-Positive: ',falsePositive)
print('False-Negative: ',falseNegative)



