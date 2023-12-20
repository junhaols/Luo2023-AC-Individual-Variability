# MRI related func
import pandas as pd
import scipy.io as sio
import numpy as np
import os
import sys
import glob
import matplotlib.pyplot as plt
import matplotlib
import seaborn as sns
import nibabel as nib
from scipy.stats import pearsonr
# read: nib.load()
# write: nib.save()
#### ******************************* file split ********************************** ####
def file_split(file_path):
    filepath, tempfilename = os.path.split(file_path)
    filename, extension = os.path.splitext(tempfilename)
    return filepath, filename, extension

#### ******************************* read h5 or pickle file as a df ********************************** ####

def read_file(file):
    _, _, ext = file_split(file)
    if ext == '.h5':
        df = pd.read_hdf(file)
    elif ext == '.pkl':
        df = pd.read_pickle(file)
    else:
        print('file shoud be xxx.h5 or xxx.pkl...')

    return df

def select_data_subj(df, subj_id, df_column_name):
    data = df[df_column_name][df['subject'] == subj_id]
    return data # series datatype with dim of (1,),for the ndarray contents,data = data[0]

def select_data_multi_subj(df, subj_ids, df_column_name):
    subj_df = df['subject'].to_numpy()
    sub, index1, index2 = np.intersect1d(subj_df, subj_ids, assume_unique=False, return_indices=True)
    data = df.loc[index1, df_column_name] # loc,select column name. iloc,select data as index
    return data.to_numpy() # convert pd series to numpy ndarray


#### ******************************* read MRI files ****************************** ####
def read_surf(surface):
    surf = nib.load(surface)
    arr = surf.darrays
    coord = arr[0].data # coordinate of vertices
    vert = arr[1].data # index of vertices
    return coord, vert

def read_nii(T1w):
    T1 = nib.load(T1w)
    data = T1.get_fdata() # 3-D ‘ray
    header = T1.header # header
    return data, header

def read_shape_gii(shape_gii):
    gii = nib.load(shape_gii)
    data = gii.darrays[0].data
    return gii, data

#### ******************************* Creat a .shape.gii file ****************************** ####

def creat_shape_gii(shape_gii_base, array_write, savepath):
    gii, _ = read_shape_gii(shape_gii_base)
    gii.darrays[0].data = array_write
    nib.save(gii, savepath)


## Creat a .shape gii file with atlas, e.g.,Kong400,Schaefer400
def creat_fs_lr32k_atlas(shape_gii_base,array_write, atlas_file, hemi, savepath):
    #cdata = np.zeros((32492,))
    f_atlas = nib.load(atlas_file)
    f_data = f_atlas.get_fdata() # 0 mean medial wall, label start from 1
    f_data = f_data[0,:]

    if hemi == 'L':
        cdata = f_data[0:int(len(f_data)/2)].copy() # L
        print('cdata.shape: %d' %(len(cdata)))
        for i, data in enumerate(array_write):
            cdata[np.where(cdata==i+1)] = data
    else:
        cdata = f_data[int(len(f_data) / 2):int(len(f_data))].copy() # R
        for i, data in enumerate(array_write):
            cdata[np.where(cdata==i+1+int(np.max(f_data)/2))] = data

    creat_shape_gii(shape_gii_base, cdata, savepath)

###################################### Corr with pvalue ###################################################
def Corr(x, y):
    r, p = pearsonr(x, y)
    rr = round(r, 3)
    pp = round(p, 3)
    return rr, pp

###################################### Join plot ###########################################################
# x,y should not be object data type, if so, convert it to np.float data type.
def jointplot_fitlinear(x, y):
    plt.figure(figsize=(20,16))
    sns.jointplot(x = x,y = y, kind = 'reg',scatter_kws={"s": 8})
#sns.regplot(x='LL_LPAC_Math_Corr',y='ReadEng_AgeAdj',data=df, color='red', scatter_kws={"s": 8}),不显示分布信息

###################################### Extract top N in a array ##############################
# Extract top N element in a array and set others to 0.
def topN_array(arr, topN):
    idx_all = set(np.arange(len(arr)))
    idx_topN = arr.argsort()[::-1][:topN]
    idx_res = idx_all - set(idx_topN)
    # keep topN, set others to zero
    idx_res = np.array(list(idx_res))
    arr_topN = arr.copy()
    arr_topN[idx_res] = 0
    return arr_topN


################################ remove outlier observer ########################################################
def df_remove_outliers(df, column1, column2):
    
    c1 = df[column1]
    c2 = df[column2]
    c1_z = (c1-np.mean(c1))/np.std(c1)
    c2_z = (c2-np.mean(c2))/np.std(c2)        
    
    c1_subjs = df[(c1_z>-3) & (c1_z<3)]['Subject'].to_numpy()
    c2_subjs = df[(c2_z>-3) & (c2_z<3)]['Subject'].to_numpy()
    
    # common
    c_subjs = list(set(c1_subjs).intersection(set(c2_subjs)))
    
    df_s = df.query('Subject==@c_subjs').reset_index(drop=True)
    
    return df_s



################################ draw paired box with sig. marker ################################################
# boxplot with sig
root_dir = '/Users/fiona/OneDrive - mail.bnu.edu.cn/Project/Prediction/Article'
#root_dir = '/Volumes/Seagate Backup Plus Drive/Restore_Prediction/Article'
from statannotations.Annotator import Annotator
sys.path.append(root_dir + '/Pipeline/Statistics/statannotations-tutorials-main/Tutorial_1')
import utils
from utils import *



def plot_cmp_pairs(df, pairs, y, x, figtitle, ttest_type, figsize = (16,12), xlabel = None, ylabel = None, y_range = None, types_order = None, hu = None, hu_order = None, save_fig = None):
    # ttest_type="t-test_paired" : paired t test.
    # ttest_type="t-test_ind" : two sample t test
    
    #types_palette = sns.color_palette("YlGnBu", n_colors=5)
    types_palette = sns.color_palette("Set1", n_colors=6)
    
    hue_plot_params = {
        'data': df,
        'x': x,
        'y': y,
        "order": types_order,
        "hue": hu,
        "hue_order": hu_order,
        "palette": types_palette
    }

    with sns.plotting_context("notebook", font_scale = 1.4):
        # Create new plot
        fig, ax = plt.subplots(1, 1, figsize = figsize)

        # Plot with seaborn
        ax = sns.boxplot(ax=ax, **hue_plot_params)

        # Add annotations
        annotator = Annotator(ax, pairs, **hue_plot_params)
        annotator.configure(test = ttest_type, comparisons_correction="bonferroni")
        _, corrected_results = annotator.apply_and_annotate()

        # Label and show
        
        ax.legend(loc = 'upper right')
        ax.set_ylabel(ylabel)
        ax.set_xlabel(xlabel)
        ax.set_title(figtitle)
        if y_range is not None:
            ax.set_ylim(y_range[0],y_range[1])
        
        if save_fig is not None:
            plt.savefig(save_fig, facecolor = 'white')
        plt.show()
    return ax
######## 