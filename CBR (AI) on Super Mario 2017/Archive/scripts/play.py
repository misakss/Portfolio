from lib.mario import Mario


while True:
    mario = Mario()

    while mario.playing:
        mario.tick()
