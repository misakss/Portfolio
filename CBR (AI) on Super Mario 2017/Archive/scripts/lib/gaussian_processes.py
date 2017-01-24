import numpy as np

def fit_predict(X_train, y_train, X_predict, length_scale = 1):
    n_training_points = X_train.shape[0]
    n_prediction_points = X_predict.shape[0]

    # Create covariance matrices for training points to training points, etc
    K_tt = np.zeros((n_training_points, n_training_points))
    K_tp = np.zeros((n_training_points, n_prediction_points))
    K_pt = np.zeros((n_prediction_points, n_training_points))
    K_pp = np.zeros((n_prediction_points, n_prediction_points))

    # Create the covariance function. Squared exponential (no hyper parameters)
    k = lambda x1, x2: np.exp(-0.5 * np.linalg.norm(np.divide(x1 - x2, 
                                                              length_scale))**2)

    # Calculate K_tt and K_tp
    for i, x1 in enumerate(X_train):
        # Compute the K_tt matrix
        for j, x2 in enumerate(X_train):
            K_tt[i, j] = k(x1, x2)

        for j, x2 in enumerate(X_predict):
            K_tp[i, j] = k(x1, x2)

    # Calculate K_pt and K_pp
    for i, x1 in enumerate(X_predict):
        # Compute the K_tt matrix
        for j, x2 in enumerate(X_train):
            K_pt[i, j] = k(x1, x2)

        for j, x2 in enumerate(X_predict):
            K_pp[i, j] = k(x1, x2)

    q = np.linalg.solve(K_tt, y_train) # Find q = K_tt_inv * y_train
    y_mean = np.dot(K_pt, q)

    q = np.linalg.solve(K_tt, K_tp) # Find q = K_tt_inv * K_tt
    y_var = K_pp - np.dot(K_pt, q)
    y_std = np.sqrt(np.diag(y_var))

    return y_mean, y_std
