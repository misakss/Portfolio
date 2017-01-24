import sys
import pygame
import math
from random import choice, randint


const_gravity = 0.2
const_player_walking_speed = 3
const_animations_per_second = 5
const_ground_position = 326 + 6
const_max_forward_enemy_count = 2


class Thing:
    def __init__(self, game, player = None):
        self.game = game
        
        if player == None:
            self.player = self
        else:
            self.player = player        

        self.velocity = [const_player_walking_speed, 0] # pixels/frame
        self.position = [0, 0] # pixels measured from top left corner of start screen.
        self.last_update_frame = 0
        self.current_image_set = None
        self.image_index = 0

    def set_image_set(self, image_set):
        self.current_image_set = self.image_sets[image_set]
        self.image_index = 0

    def update_position(self, current_frame):
        f = lambda p, v: int(p + v) # always round. 

        relative_velocity = map(f, self.velocity, [-self.player.velocity[0], 0])
        self.position = list(map(f, self.position, relative_velocity))


    def update_animation(self, current_frame, fps):
        image_count = len(self.current_image_set)

        if fps >= const_animations_per_second and current_frame % int(fps / const_animations_per_second)  == 0:
            self.image_index += 1

            if self.image_index == image_count:
                self.image_index = 0

    def update(self, current_frame, fps): 
        self.update_position(current_frame)
        self.update_animation(current_frame, fps)

        self.last_update_frame = current_frame

    def get_image(self): # Gets the current image based on the animation
        return self.current_image_set[self.image_index]

    def get_rect(self): # These are in coordinates relative to the player!!!
        rect = self.get_image().get_rect()
        return rect.move(self.position) # This is where it should be drawn.
        
class Player(Thing):

    def load_image_sets(self):
        # Dictionary which holds the image sets
        self.image_sets = {}

        # Load the images for walking and put them into the dict (could prob. be done nicer)
        walk_images = []
        for i in range(2,7):
            image = pygame.image.load("images/mario_walk_and_run/mario{}.png".format(i))
            image = pygame.transform.scale(image, (50, 75))
            walk_images.append(image)
            
        self.image_sets['mario_walk_set']  = walk_images

        #Load the image for jumping and put it into the dict
        image_mario_jump = pygame.image.load("images/mario_jump/mario_jump.png"); image_mario_jump = pygame.transform.scale(image_mario_jump, (60, 80))
        self.image_sets['mario_jump_set'] = [image_mario_jump]

    def __init__(self, game):
        Thing.__init__(self, game)

        self.walking =  True
        self.jumping = False
        self.dying = False
       
        self.load_image_sets()
        self.set_image_set('mario_walk_set')

    def visible(self, thing, only_forward_visible = False):

        thing_is_to_the_right = thing.position[0] > self.position[0] # it must have a position greater than ours

        visible = self.game.bg_rect.colliderect(thing.get_rect()) and \
            (not only_forward_visible or (only_forward_visible and thing_is_to_the_right)) # If we only care about things heading to us, it must be to our right

        return visible
    #return self.position[0] - thing.position[0] < 640 / 2

    def update_position(self, current_frame):
        if self.jumping:
            if not current_frame > self.jump_end_frame:
                # Now recalculate everything so that it fits the number of frames
                time_in_air = self.jump_end_frame - self.jump_start_frame
                time = current_frame - self.jump_start_frame

                speed = 0.5 * const_gravity * time_in_air
 
                self.velocity[1] = -(speed - const_gravity * time)
                self.velocity[0] = const_player_walking_speed * 2
            else:
                self.velocity[0] = const_player_walking_speed
                self.velocity[1] = 0
                self.jumping = False            
                self.walking = True
                self.set_image_set('mario_walk_set')

        Thing.update_position(self, current_frame)

    def jump(self, current_frame, duration):
        if not self.jumping:

            speed = 12 * duration# TODO these must be scaled by pixels! Gravity etc
            time_in_air = int(2 * speed / const_gravity) # aka number of frames

            self.jump_start_frame = current_frame
            self.jump_end_frame = current_frame + time_in_air # Calculate this somehow from the kinetics.   
            self.jumping = True
            self.walking = False
            self.set_image_set('mario_jump_set')

class Enemy(Thing):

    # Load the images
#    pipe = pygame.image.load("pipe.png")
#    pipe = pygame.transform.scale(pipe, (60, 80))
    
    # Put them into sets
    image_sets = {}
#    image_sets['pipe_set1'] = [pipe]
#    image_sets['pipe_set2'] = [pygame.transform.rotate(pipe, 90)]

    enemy_types = {}       

    # Initialize walking enemy
    walk_images = []
    for i in range(1,3):
        image = pygame.image.load("images/enemy_walk/enemy_walk{}.png".format(i))
        image = pygame.transform.scale(image, (40, 50))
        walk_images.append(image)
            
    image_sets['enemy_walk_set']  = walk_images
    enemy_types['enemy_walk'] = {'image_set': 'enemy_walk_set', 
                           'speed_interval': [0, 0]}

    # Initialize flying pipe
    fly_images = []
    for i in range(1,5):
        image = pygame.image.load("images/enemy_fly/enemy_fly{}.png".format(i))
        image = pygame.transform.scale(image, (50, 60))
        fly_images.append(image)
            
    image_sets['enemy_fly_set']  = fly_images
    enemy_types['enemy_fly'] = {'image_set': 'enemy_fly_set', 
                                  'speed_interval': [1, 3]}

    @staticmethod            
    def get_enemy_types():
        return list(Enemy.enemy_types.keys())
    
    def __init__(self, game, enemy_type, position, player):
        Thing.__init__(self, game, player)

        assert enemy_type in Enemy.get_enemy_types()

        self.velocity = [-randint(*Enemy.enemy_types[enemy_type]['speed_interval']), 0]
        self.position = position
        self.set_image_set(Enemy.enemy_types[enemy_type]['image_set'])

class Mario():
    def __init__(self, automated = False):
        pygame.init()

        self.max_forward_enemy_count = const_max_forward_enemy_count

        self.automated = automated
        self.SPECIAL_DOWN = pygame.USEREVENT + 1
        self.SPECIAL_UP = pygame.USEREVENT + 2
    
        self.size = self.width, self.height = 640, 480
        self.screen = pygame.display.set_mode(self.size)
        
        self.bg = pygame.image.load("images/overworld_bg.png")
        self.bg = pygame.transform.scale(self.bg, self.size)
        self.bg_rect = self.bg.get_rect()
        
        self.g_o = pygame.image.load("images/game_over.jpg")
        self.g_o = pygame.transform.scale(self.g_o, self.size)
        self.g_o_rect = self.g_o.get_rect()
        
        self.player = Player(self)
        self.player.position = [self.width / 2 - 15, const_ground_position]
        
        self.enemy_list = []
        self.score = 0
        
        self.max_jump_time = 0.1 # number of seconds you can hold the jump button until it releases automatically
        
        self.current_frame = 0
        self.jump_load = -1
        
        self.clock = pygame.time.Clock()
        self.playing = True # if not game over        
        self.quitted = False

    def tick(self, pass_info = False):
        self.clock.tick()
        fps = self.clock.get_fps() ; self.fps = fps
        max_jump_load = int(fps * self.max_jump_time) # max hold time is 1 sec
        
        # Handle input and do changes to stuff.
        for event in pygame.event.get():
            if event.type == pygame.QUIT: 
                self.quitted = True
                self.playing = False
                #sys.exit()

            # initiate a jump
            if (event.type == pygame.KEYDOWN and not self.automated) or event.type == self.SPECIAL_DOWN :

                jump_event = False
                if not self.SPECIAL_DOWN:
                    pygame.event.pump()
                    jump_event = event.key == pygame.K_SPACE
                else:
                    jump_event = True
                    
                if jump_event:
                    self.jump_load = self.current_frame
                    
            # Jump button is released.
            if (event.type == pygame.KEYUP and not self.automated) or event.type == self.SPECIAL_UP :

                if not self.SPECIAL_UP:
                    pygame.event.pump()
                    jump_event = event.key == pygame.K_SPACE
                else:
                    jump_event = True
                
                if jump_event and self.jump_load > 0:
                    
                    jump_intensity=(self.current_frame - self.jump_load)/max_jump_load
                    if jump_intensity >= 1: 
                        jump_intensity = 1
                    self.player.jump(self.current_frame, jump_intensity)
                    self.jump_load = -1
                    
        

        # If taking too long to jump it releases and jumps automatically
        if (self.current_frame - self.jump_load) >= max_jump_load and self.jump_load > 0:
            jump_intensity = 1
            self.jump_load = -1
            self.player.jump(self.current_frame, jump_intensity)


        # Spawn new enemy
        forward_enemy_count = sum(list(map(lambda x: self.player.visible(x, True), self.enemy_list))) # Check that enemy count isn't already full
        if fps > 1 and self.current_frame % int(fps * 2) == 0 and (forward_enemy_count < self.max_forward_enemy_count):
            enemy_type = choice(Enemy.get_enemy_types()) # Spawn a random type
    
            spawn_position = {'enemy_walk': [self.width-1, const_ground_position + 24], 
                              'enemy_fly': [self.width-1, 100]}
    
            enemy = Enemy(self, enemy_type, spawn_position[enemy_type], self.player)
            self.enemy_list.append(enemy)
    
        # Update player
        self.player.update(self.current_frame, fps)
        
        # Update enemies
        enemy_index = 0
        while enemy_index < len(self.enemy_list):
            enemy = self.enemy_list[enemy_index]
            
            if self.player.visible(enemy):
                enemy.update(self.current_frame, fps)
                enemy_index += 1
            else:
                self.enemy_list.pop(enemy_index)
                self.score += 1
    
        # Display everything
        self.screen.blit(self.bg, self.bg_rect) # background
    
        #Enemy
        for enemy in self.enemy_list:
            self.screen.blit(enemy.get_image(), enemy.get_rect())
            
        # Player
        self.screen.blit(self.player.get_image(), self.player.get_rect())    
    
        # Game Over
        for enemy in self.enemy_list:
            #if pygame.sprite.collide_rect(player.get_rect(),enemy.get_rect()):
            if self.player.get_rect().colliderect(enemy.get_rect()):
                # Kill Mario --> Game Over
                self.screen.blit(self.g_o, self.g_o_rect)
                pygame.display.flip()
                self.jumping = False
                self.playing = False
                #pygame.time.delay(2000)
                break
        
        # Draw jump-load
        if self.jump_load > 0 and not self.player.jumping:
            margin = 2        # the white border
            white = pygame.Color(255, 255, 255, 255)
            pygame.draw.rect(self.screen, white, (10 - margin,10 - margin,100 + margin,20 + margin), 0)
    
            green = pygame.Color(0, 255, 0, 255)
            jump_intensity=(self.current_frame - self.jump_load)/max_jump_load
            pygame.draw.rect(self.screen, green, (10, 10, int(100*jump_intensity) , 20), 0)

        # Draw FPS
        myfont = pygame.font.SysFont("monospace", 15)
        label = myfont.render("FPS: {}".format(round(fps, 3)), 1, (255,255,0))
        self.screen.blit(label, (530, 10))

        pygame.display.flip()
        self.current_frame += 1
        
        # Pass info from frame
        if pass_info:
            enemy_info = [{'rect': enemy.get_rect(), 
                           'velocity': enemy.velocity} for enemy in self.enemy_list if self.player.visible(enemy)]
            frame_info = {'player_rect': self.player.get_rect(), 
                          'player_velocity':self.player.velocity, 
                          'jumping': self.player.jumping, 
                          'enemy_info':enemy_info}

            return frame_info
        else:
            return None
