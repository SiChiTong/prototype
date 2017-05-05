#!/usr/bin/env python3
from math import tan
from random import uniform as randf

import numpy as np
from numpy import dot

from prototype.utils.math import deg2rad


def focal_length(image_width, image_height, fov):
    fx = (image_width / 2.0) / tan(deg2rad(fov) / 2.0)
    fy = (image_height / 2.0) / tan(deg2rad(fov) / 2.0)
    return (fx, fy)


def projection_matrix(K, R, t):
    extrinsics = np.array([[R[0], R[1], R[2], t[0]], [R[3], R[4], R[5], t[1]],
                           [R[6], R[7], R[8], t[2]]])
    return dot(K, extrinsics)


def camera_intrinsics(fx, fy, cx, cy):
    K = np.array([
        [fx, 0.0, cx],
        [0.0, fy, cy],
        [0.0, 0.0, 1.0]
    ])
    return K


def generate_random_3d_features(bounds, nb_features):
    features = []

    # generate random 3d features
    for i in range(nb_features):
        point = [0, 0, 0, 0]
        point[0] = randf(bounds["x"]["min"], bounds["x"]["max"])
        point[1] = randf(bounds["y"]["min"], bounds["y"]["max"])
        point[2] = randf(bounds["z"]["min"], bounds["z"]["max"])
        point[3] = 1.0
        features.append(point)

    return features