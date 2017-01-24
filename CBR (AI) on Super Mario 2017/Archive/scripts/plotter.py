import matplotlib.pyplot as plt
import numpy as np

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

data = np.loadtxt("data_long.txt", delimiter=',')
game_list = data[0,:]
score_list = data[1,:]

score_mean_list, score_std_list = moving_average(score_list, 100)

fig = plt.figure()

ax = fig.add_subplot(211)

ax.plot(game_list, score_list, color='b')
ax.axis('tight')
ax.set_ylabel('Number of avoided enemies')

ax = fig.add_subplot(212)

ax.plot(game_list, score_mean_list, color='r')
ax.fill_between(game_list, score_mean_list - 2*score_std_list, score_mean_list + 2*score_std_list, alpha = 0.5)
plt.axis('tight')
ax.set_ylabel('Number of avoided enemies')
ax.set_xlabel('Number of games played')

plt.savefig('fig.png')
plt.show()



