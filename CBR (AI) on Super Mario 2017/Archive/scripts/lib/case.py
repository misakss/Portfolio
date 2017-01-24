from copy import deepcopy

'''
This class contains information about the location, speed and shape of a single enemy.
Several instances of it can be associated with a single case.
It can be converted to a list by calling list() function on it. That is, 
all its variable entries are placed in a list.
'''
class EnemyInfo:
    def __init__(self, height, width, distance_x, distance_y, velocity_x):
        self.height = height
        self.width = width
        self.distance_x = distance_x
        self.distance_y = distance_y
        self.velocity_x = velocity_x

        # If adding new variables, make sure to add them to the __str__ method too.

    def __iter__(self):
        the_list = [self.height, self.width, self.distance_x, self.distance_y, self.velocity_x]

        for item in the_list:
            yield item

    def __str__(self):

        var2str = lambda name, self=self: name + ": {}".format(eval("self."+name))

        #Construct the string
        str = ''
        str += var2str('height'); str += ", "
        str += var2str('width'); str += ", "
        str += var2str('distance_x'); str += ", "
        str += var2str('distance_y'); str += ", "
        str += var2str('velocity_x')
        return str


'''
This class contains the information about the particular game environment that is associated
with a particular case. Essentially, it contains a list with enemies present (instances of EnemyInfo).

An instance of this class is passed to the CBR from "communicator.py" (which plays the game and 
communicates with the CBR). 

The class can be converted to a list by calling list() function on it. The resulting list contains
the variables returned when applying the list function to instances of the EnemyInfo class. 
Hence, its size varies with the number of enemies and could be zero.
'''
class CaseEnvironment:
    def __init__(self, enemy_list): 
        assert type(enemy_list) == type([])
        self.enemy_list = deepcopy(enemy_list)

        # Declare new case variables here. Don't forget to add them to "__str__" function too.
        self.example_var = 0

    def __iter__(self):
        the_list = sum([list(enemy) for enemy in self.enemy_list], []) # Make flat list with enemy info
        
        for enemy in the_list:
            yield enemy

    def __str__(self):

        var2str = lambda name, self=self: name + ": {}".format(eval("self."+name))

        #Construct the string
        str = ''
        str += var2str('example_var'); str += ", "

        # Also add data for the enemy info
        str += "enemy_list: ["
        for enemy in self.enemy_list:
            str += '[' + enemy.__str__() + '], '
        
        if len(self.enemy_list) > 0: str = str[:-2] # Remove extra ", "
        str += ']'

        return str

    def get_enemy_count(self):
        return len(self.enemy_list)


"""
This class represents a case in the case base. It contains a case_id (some unique number),
the solution associated with the case, and also the environment (game state) associated
with the case.

It also contains a variable "completed", which indicates indicates whether the case is
fully evaluated and learned (incomplete cases may exist in the case base,but shouldn't be used 
when searching for new cases)
"""

class Case:
    def __init__(self, case_id, jump_intensity, case_environment, complete):
        self.case_id = case_id
        self.jump_intensity = jump_intensity
        self.case_environment = deepcopy(case_environment)
        #print ("added new, encount:",self.case_environment.get_enemy_count())
        self.score = 0
        self.complete = complete # Cases which haven't gone through entire CBR cycle yet shouldn't be retrieved, etc

    def hash_code(self):
        sum = 0
        for num, coefficient in zip(list(self.case_environment), [1, 12, 76, 44, 55, 667, 113, 123, 500, 32]):
            sum += coefficient * num
        return sum
"""    


enemy1 = EnemyInfo(3, 4, 40, 30, 2)
enemy2 = EnemyInfo(3, 54, 50, 40, 2)


enemy_list = [enemy1, enemy2]

ce1 = CaseEnvironment(enemy_list)

case1 = Case(3, 1, ce1, False)

print(list(case1.case_environment))

ce2 = CaseEnvironment([enemy1])

case2 = Case(4, 0.5, ce2, True)

print(list(case2.case_environment))


for enemy in case1.case_environment.enemy_list:
    print(enemy.width)
    print( list(enemy))


"""

       
