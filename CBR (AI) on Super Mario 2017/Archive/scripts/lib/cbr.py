from lib.case import Case, CaseEnvironment, EnemyInfo
from random import triangular, randint, normalvariate
from math import exp
from numpy.random import binomial
from numpy import clip, average
from lib.tree import searchTree, init_tree
from lib.gaussian_processes import fit_predict

MAX_RELEVANT_CASES = 20 # The number of cases to return from retrieval
SINGLE_CASE_DISTANCE_SCALE = 10 # The greater this value, the wider the radius of neighbors are afffected by feedback from communicator
GP_LENGTH_SCALE = 100 # The length scale of the gaussian processes
MODIFICATION_STD = 0.1 # standard deviation to modify a previously working solution with.

HEIGHT_SPECS = {'attribute_index': 0, 'intervals': ((0,70),(70,1000))}
WIDTH_SPECS = {'attribute_index': 1, 'intervals': ((0,70),(70,1000))}
XDIST_SPECS = {'attribute_index': 2, 'intervals': ((0,100),(100,200),(200,400))}
YDIST_SPECS = {'attribute_index': 3, 'intervals': ((0,100),(100,200),(200,400))}
ATTRIBUTE_SPECS = [HEIGHT_SPECS, WIDTH_SPECS, XDIST_SPECS, YDIST_SPECS]

init_tree(ATTRIBUTE_SPECS)

case_base = [] # every case is an instance of the Case class. Could be a list, a tree, or something.
case_count = 0

def retrieve(input_case_env):  
    # Construct a new case which might be added to the tree
    new_case = Case(0, 0, input_case_env, False)

    # Search the case base 
    global case_base
    global case_count
    
    # Search the case base and return relevant cases (and possibly updated case base)
    case_base, relevant_cases = searchTree(case_base, new_case)
    relevant_cases = [case for case in relevant_cases if case.complete] # Care only about complete cases
    
    print ("FOUND {} RELEVANT CASES".format(len(relevant_cases)))

    if len(relevant_cases) == 0:
        # If there are no cases, this is the first one of it's kind. Do nada.
        new_case.jump_intensity = 0
        new_case.complete = True
        case_count += 1
        return new_case, [], []

    # Now lets calculate the feature distance to our case among the relevant ones
    input_case_features = list(input_case_env)
    distances = [0,] * len(relevant_cases)

    for index, case in enumerate(relevant_cases):        
        case_features = list(case.case_environment)
        # Calculate the euclidean distance (squared)
        distances[index] = sum(map(lambda a, b: (a - b)**2, input_case_features, case_features))

        if distances[index] == 0:
            # new case and found case are equal.
            return case, [], []

    # Now, lets refine the search by only selecting the first few (could also use some tolerance for distance perhaps)
    relevant_cases_and_distances = sorted(zip(relevant_cases, distances), key = lambda x: x[1])
    relevant_cases = [x for x, y in relevant_cases_and_distances]
    distances = [y for x, y in relevant_cases_and_distances]
    
    return new_case, relevant_cases[:MAX_RELEVANT_CASES], distances[:MAX_RELEVANT_CASES]

def adapt(new_case, relevant_cases, distances): 
    """ Returns jump intensity based on the relevant cases
    """

    if len(relevant_cases) == 0:
        # Do nothing when no or only one relevant cases were found.
        return new_case.jump_intensity
    elif len(relevant_cases) == 1:
        # When only one relevant case was found, do something similar. The farther away, the less similar
        scaling = 1 - exp(-(distances[0]/float(SINGLE_CASE_DISTANCE_SCALE))**2)
        jump_intensity = clip(normalvariate(relevant_cases[0].jump_intensity, scaling), 0, 1)
        return jump_intensity

    # Do some gaussian process regression..
    import numpy as np
    X = np.atleast_2d([list(case.case_environment) for case in relevant_cases])
    y = np.asarray([case.jump_intensity for case in relevant_cases])
    x = np.atleast_2d(list(new_case.case_environment))

    length_scale = np.mean(X, axis = 0) + 1e-12
    length_scale = GP_LENGTH_SCALE
    y_mean, y_std = fit_predict(X, y, x, length_scale)
    y_mean = y_mean[0]; y_std = y_std[0]

    if y_mean != y_mean : # If nan 
        y_mean = 0.5
        y_std = 0.5
        print ("Nan received...")

    jump_intensity = clip(normalvariate(y_mean, y_std), 0, 1)
        

    print ("Calculated jump_intensity for new case ({}) = ".format(new_case.hash_code()), jump_intensity, y_mean, y_std)    

    return jump_intensity

def ask_cbr(input_case_env):
    # Given this environment, find similar or identical cases + their distances as distances
    
    new_case, relevant_cases, distances = retrieve(input_case_env)
    new_case.jump_intensity = adapt(new_case, relevant_cases, distances)
    #new_case.complete = True

    return new_case

def tell_cbr(new_case, alive, time):
    # Evaluate the solution and figure out the performance somehow
    
    if new_case.complete:
        if not alive:
            print ("Treating old ({}), valid solution which resulte in death. Modify it a little".format(new_case.hash_code()))
            new_case.jump_intensity = clip(normalvariate(new_case.jump_intensity, MODIFICATION_STD), 0, 1)
        else:
            print ("Old solution ({}) worked fine again!".format(new_case.hash_code()))
    else:
        
        if not alive:
            print("Treating new solution ({}), which resulted in death. Discard it".format(new_case.hash_code()))
            # REMOVE IT FROM TREE FOR PERFORMANCE
        else:
            print("Treating new solution ({}). Still alive. Marking it complete".format(new_case.hash_code()))
            new_case.complete = True

def get_case_count():
    global case_count
    return case_count

