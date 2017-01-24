import math

from lib.case import Case, CaseEnvironment, EnemyInfo


intervals_list = []
attribute_index_list = []

def init_tree(attribute_specs):
    for spec in attribute_specs:
        intervals_list.append(spec['intervals'])
        attribute_index_list.append(spec['attribute_index'])    
    
def whichInterval(attribute,intervals):
    for index,interval in enumerate(intervals):
        if interval[0] <= attribute < interval[1]:
            return index
    raise ValueError
    
def memberCount(ce,intervals,attribute_index):
    member_count = [0,]*len(intervals)
    for enemy in ce.enemy_list:
        interval_index = whichInterval(list(enemy)[attribute_index],intervals)
        member_count[interval_index] += 1
    return member_count
    
def searchTree(tree,case):
    subtree = tree
    for attribute_index,intervals in zip(attribute_index_list,intervals_list):
        member_count = memberCount(case.case_environment,intervals,attribute_index)
        new_subtree = None        
        for branch in subtree:
            if branch[0] == member_count:
                new_subtree = branch[1]
                break
        if new_subtree == None:
            new_subtree = []
            new_branch = (member_count,new_subtree)
            subtree.append(new_branch)
        subtree = new_subtree
    exist_list = [list(existing.case_environment) for existing in subtree]
    if not list(case.case_environment) in exist_list:
        subtree.append(case)
    return tree, subtree
