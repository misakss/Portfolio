# -*- coding: utf-8 -*-
"""
Created on Thu Dec  8 23:17:05 2016

@author: Martin
"""

import nltk
from nltk.corpus import treebank
from nltk import Nonterminal, Tree

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
                rules.append(production)
    
    # Add the lexical rules
    for word, tag in tags_words:
        
        # For each tagged word, create a tree containing that
        # lexical rule 
        # This is to be able to add it to the list rules
        t = Tree.fromstring("("+ tag + " " + word  +")")
        for production in t.productions():
                rules.append(production)
          
    # All the syntactic rules and all of the lexical rules 
    # are extracted from the training-data
    # Here the PCFG is extracted
    rules_prob = nltk.grammar.induce_pcfg(Nonterminal('S'), rules)
    return rules_prob
    
def accuracy(train_rules, test_rules, prob_thresh):
    """
    Gives the NP production rules which are exclusive to one set of rules.
    """

    NP = Nonterminal('NP')
    trainAmount = 0
    testAmount = 0
    rules_train = []
    for rule in train_rules.productions():
        if NP == rule.lhs(): # and rule.lhs() != 'NNP' and rule.lhs() != 'NNPS':
            trainAmount += 1
            rules_train.append(rule.rhs())
    
    rules_test = []
    for rule in test_rules.productions():
        if NP == rule.lhs(): # and rule.lhs() != 'NNP' and rule.lhs() != 'NNPS':
            testAmount += 1
            rules_test.append(rule.rhs())
    
    rulesExclusivelyInTrain = 0
    for train_rule in rules_train:
        if train_rule not in rules_test:
            rulesExclusivelyInTrain += 1
            
    rulesExclusivelyInTest = 0
    for test_rule in rules_test:
        if test_rule not in rules_train:
            rulesExclusivelyInTest += 1

    return rulesExclusivelyInTrain, rulesExclusivelyInTest, trainAmount, testAmount

def parse(grammar, raw_sents, goldenStandard):
    """
    Parses the raw text with the provided grammar and compares chunking result to the golden standard.
    Counts false positives and false negatives of chunked noun phrases
    """
    parser = nltk.ViterbiParser(grammar)
    falsePositives = 0
    falseNegative = 0
    amountPosTest = 0
    amountNegTest = 0
    posSucess = 0
    negSucess = 0
    for i in range(0, len(goldenStandard)):
        if len(raw_sents[i]) > 12:
            continue
        print("==== Parsing sentence " + str(i), flush=True)
        # This will raise an exception if the tokens in the test_sentence
        # are not covered by the grammar; should not happen.
        grammar.check_coverage(raw_sents[i])
        # Test prints for seeing each parsed sentenced
        '''
        print(raw_test_set[i])
        print("[" + str(i) + "] Reference parse:")
        print(test_set[i])
        print("[" + str(i) + "] Parse trees:")'''
        for tree in parser.parse(raw_sents[i]):
            #print(tree)
            for parsedTree in tree.subtrees():
                if 'NP' in parsedTree.label() and parsedTree.label() != 'NNP' and parsedTree.label() != 'NNPS':
                    amountPosTest += 1
                    checkSuccess = posSucess
                    for goldTree in goldenStandard[i].subtrees():
                        if 'NP' in goldTree.label()and goldTree.label() != 'NNP' and goldTree.label() != 'NNPS':
                            if parsedTree.leaves() == goldTree.leaves():
                                posSucess += 1
                                break
                    if checkSuccess == posSucess:
                        falsePositives += 1
                        print("FALSE POSITIVE, Noun phrase not in golden standard:", parsedTree.leaves())

            for goldTree in goldenStandard[i].subtrees():
                if 'NP' in goldTree.label() and goldTree.label() != 'NNP' and goldTree.label() != 'NNPS':
                    amountNegTest += 1
                    checkSuccess = negSucess
                    for parsedTree in tree.subtrees():
                        if 'NP' in parsedTree.label()and parsedTree.label() != 'NNP' and parsedTree.label() != 'NNPS':
                            if parsedTree.leaves() == goldTree.leaves():
                                negSucess += 1
                                break
                    if checkSuccess == negSucess:
                        falseNegative += 1
                        print("FALSE NEGATIVE, Noun phrase not in parsed tree:", goldTree.leaves())
    print("false positives: ",falsePositives, "out of",amountPosTest,"tests")
    print("false negatives: ",falseNegative, "out of",amountNegTest,"tests")
    print("correctly parsed noun phrases:",posSucess, "out of", posSucess+falseNegative, "in gold standard")
#----------------------------------- MAIN -----------------------------------

sentences = treebank.parsed_sents()

train_len = round(0.9*len(sentences))
data_train = sentences[0:train_len]
data_test = sentences[train_len+1:-1]

sents = treebank.sents()
raw_sents = [ [ w for w in sents[i] ] for i in range(train_len+1, len(sentences)) ]

train_rules = chunker(data_train)
test_rules = chunker(data_test)

# All the rules with a probability under the value of
# prob_thresh will be discarded
prob_thresh = 0

rulesExclusivelyInTrain, rulesExclusivelyInTest, trainAmount, testAmount = accuracy(train_rules, test_rules, prob_thresh)

print('Noun phrase rules that occur exclusively in the train corpus: ',rulesExclusivelyInTrain)
print('Total number of NP rules in the train corpus:', trainAmount)
print('Noun phrase rules that occur exclusively in the test corpus: ',rulesExclusivelyInTest)
print('Total number of NP rules in the test corpus:', testAmount)
parse(train_rules, raw_sents, data_test)



