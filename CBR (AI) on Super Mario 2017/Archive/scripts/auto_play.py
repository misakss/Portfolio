
'''
The purpose of this script is to be a link between the game and the CBR. Its task is to run the game and translate its state to something the CBR can understand, i.e translating
the state of the game into a case. Once the CBR finds a solution, the instructions are given back to the game.
'''
from lib.cbr import ask_cbr, tell_cbr, get_case_count
import pygame
from _thread import start_new_thread
from lib.mario import Mario
from time import sleep
from lib.case import CaseEnvironment, EnemyInfo, Case
import numpy as np

game_number = 1
def moving_average(y, n_points = 1):
    l = len(y)
    y_out = [0,]*l
    y_std = [0,]*l

    for index in range(l):
        start = max(0, index - n_points)
        end   = min(index + n_points, l - 1)

        vals = y[start:end]
        y_out[index] = np.mean(vals)
        y_std[index] = np.std(vals)

    y_out = np.asarray(y_out)
    y_std = np.asarray(y_std)

    return y_out, y_std

def post_space_updown(which):
    # This function simulates a keypress (space key, which makes the jump) in the game.

    dict = {'up': mario.SPECIAL_UP, 
            'down': mario.SPECIAL_DOWN}

    space_button_event = pygame.event.Event(dict[which])
    pygame.event.post(space_button_event)


def translate_to_case(frame_info):
    player_rect = frame_info['player_rect']
    player_velocity = frame_info['player_velocity']

    enemy_info = frame_info['enemy_info'] # the frame_info, old one.

    enemy_list = [] # new info about enemies. This is added to the case.

    for enemy in enemy_info:
        enemy_rect = enemy['rect']

        relative_velocity = player_velocity[0] - enemy['velocity'][0]
        relative_distance = [abs(-player_rect.center[0] + enemy_rect.center[0]), abs(-player_rect.center[1] + enemy_rect.center[1])]
        height, width = enemy_rect.bottom - enemy_rect.top, enemy_rect.right - enemy_rect.left

        # Create new object and add it to the list
        enemyinfo = EnemyInfo(height, width, relative_distance[0], relative_distance[1], relative_velocity)
        enemy_list.append(enemyinfo)

    case_environment = CaseEnvironment(enemy_list)
    return case_environment

def query_and_execute(frame_info):
    # Purpose of this function is to translate the frame info to case info and then pass it to the CBR module
    # When the CBR module returns a solution to the case, the solution is executeed.
    case_info = translate_to_case(frame_info)

    global game_number
    start_game_number = game_number



    # Ask CBR what to do
    case = ask_cbr(case_info)
    jump_intensity = case.jump_intensity
    
    
    #print ("RECEIVED INSTRUCTION TO JUMP WITH ", jump_intensity)


    if jump_intensity > 0:
        post_space_updown('down')
        jump_time = mario.max_jump_time * jump_intensity
        sleep(jump_time)
        post_space_updown('up')    
        
    
        # Wait for jump to commence
        while not mario.player.jumping:
            sleep(0.01)
    
        # Wait for jump to stop
        while mario.player.jumping:
            sleep(0.01)

    sleep(1)

    # Report about state for some times
    tell_count = 1
    time_step = 0.5
    time = [0.1 + time_step * i for i in range(tell_count)]
    for t in time:
        sleep(time_step)
        alive = game_number == start_game_number# If a new game started we must have died
        tell_cbr(case, alive, t)

query_time = 0.5 # How many seconds between each query to the CBRt
global game_number

game_list = []
score_list = []

while True:
    mario = Mario(automated = True)
    
    while mario.playing:
        frame_info = mario.tick(pass_info = True)
        
        if not frame_info['jumping'] and len(frame_info['enemy_info']) > 0:
            if mario.fps > 1 and mario.current_frame % int(mario.fps * query_time) == 0:
                start_new_thread(query_and_execute, (frame_info,))

    score_list.append(mario.score)
    game_list.append(game_number)
    game_number += 1    

    if mario.quitted:
        sleep(15)
        break


data = np.asarray([game_list, score_list])
np.savetxt("data.txt", data,delimiter=',')
