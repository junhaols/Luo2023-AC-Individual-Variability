#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Apr  2 19:12:04 2022

@author: luojunhao
"""

import pandas as pd
from pylab import text
from scipy.stats import entropy
from scipy.stats import ttest_rel
from scipy import interpolate
import scipy.io as sio
import numpy as np
import os
import sys
import glob
import matplotlib.pyplot as plt
import matplotlib
import seaborn as sns
from sklearn.metrics import mean_squared_error
from sklearn.metrics import r2_score
from scipy.stats import mannwhitneyu, normaltest
import seaborn as sns



# filesplit

def file_split(file_path):
 
    filepath, tempfilename = os.path.split(file_path)
    filename, extension = os.path.splitext(tempfilename)
    return filepath,filename,extension

# hist
def hist_(data_, xlabel_, ylabel_, title_):
      plt.hist(data_)
      plt.xlabel(xlabel_)
      plt.ylabel(ylabel_)
      plt.title(title_)
      plt.show()
      
# fit linear
def fit_linear_(x_, y_, xlabel_, ylabel_, title_, ax = None, *args):
    if ax is None:
        fig = plt.figure()
        ax = fig.gca()

    max_x = np.max(x_)
    max_y = np.max(y_)
    min_x = np.min(x_)
    min_y = np.min(y_)

    if max_x >= max_y:
        max_ = max_x
    else:
        max_ = max_y

    if min_x <= min_y:
        min_ = min_x
    else:
        min_ = min_y

    if args:
        print(len(args))
        xlim = args[0]
        ylim = args[0]
    else:
        xlim = np.array([min_ , max_])
        ylim = np.array([min_ , max_])


    parameter = np.polyfit(x_, y_, 1)
    y_fit = parameter[0] * x_ + parameter[1]
    ax.scatter(x_, y_, s=8, c='red')
    ax.plot(x_, y_fit, 'k')
    ax.set_xlim(xlim)
    ax.set_ylim(ylim)
    ax.set_xlabel(xlabel_)
    ax.set_ylabel(ylabel_)
    ax.set_title(title_)
    plt.show()
    return fig,ax
    plt.close()

# prediction evaluate index

def evaluate_index(testing_y_sub, predict_y_sub):

       # evaluate index
       sub_Corr = np.corrcoef(testing_y_sub, predict_y_sub)
       sub_Corr = sub_Corr[0, 1]  # tri
       sub_MAE = np.mean(np.abs(np.subtract(testing_y_sub, predict_y_sub)))
       sub_R2 = r2_score(testing_y_sub, predict_y_sub)
       sub_MSE = mean_squared_error(testing_y_sub, predict_y_sub, squared=False)
       sub_NRMSE = sub_MSE / (max(testing_y_sub) - min(testing_y_sub))
       return sub_Corr, sub_MAE, sub_R2, sub_NRMSE

# plot y = x as baseline,and compare x and y
def cmp_x_y(x, y, xlabel, ylabel, title,  paired_ttest_flag = 0, ax = None , *args):
        # a function to compare two vector, baseline is y = x
        # args: x and y axis range
        if ax is None:
            ax = plt.gca()

        max_x = np.max(x)
        max_y = np.max(y)
        min_x = np.min(x)
        min_y = np.min(y)

        if max_x >= max_y:
            max_ = max_x
        else:
            max_ = max_y

        if min_x <= min_y:
            min_ = min_x
        else:
            min_ = min_y

        if args:
            print(len(args))
            xlim = args[0]
            ylim = args[0]
        else:
            xlim = np.array([min_ - 0.1 * abs(min_), max_ + 0.1 * abs(max_)])
            ylim = np.array([min_ - 0.1 * abs(min_), max_ + 0.1 * abs(max_)])

        # plot y = x, baseline
        ref_x = np.linspace(xlim[0], xlim[1], 100)
        ref_y = ref_x
        ax.plot(ref_x, ref_y, 'k')  # black line

        # plot x,y scatter
        ax.scatter(x, y, s=8, c='red')
        #
        ax.set_xlim(xlim)
        ax.set_ylim(ylim)
        ax.set_xlabel(xlabel)
        ax.set_ylabel(ylabel)
        ax.set_title(title)
        if paired_ttest_flag:
            tt = ttest_rel(x, y)
            p_val = tt.pvalue
            ax.text(0.01, 0.95, 'x_mean=%.3f,y_mean=%.3f,p=%.3f' %(np.mean(x),np.mean(y),p_val), transform=ax.transAxes)
        # if save_fig is not None:
        #     fig.save(save_fig)
        plt.show()
        return ax
