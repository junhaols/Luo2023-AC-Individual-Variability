
# Background
We obtained a group-level auditory cortex (AC) mask, deriving from the combination region of the manually delineated individualized planum temporale (PT) and Heschl’s gyrus (HG).
We calculated the individual variability in the resting-state functional connectivity (rsFC) of the group AC and applied the spectral clustering algorithm based on this variability, resulting in 
four subregions for both left and right ACs. We also demonstrated the functional specialization of each subregion.

# Clustering results with different gammas
![image](https://github.com/junhaols/Luo2023-AC-Individual-Variability/blob/main/Figures/Fig-gammas.png)

# The final AC subregions
**The parameters for the final AC subregions are set as follows:**
- n_cluster = 4
- eigen_solver = ‘arpack’
- n_components = 4
- random_state = 0
- gamma = 0.001
- affinity = ‘rbf’
- assign_labels = ‘discretize’
- Other parameters are set as default.

**The AC atlas files are in the folder:**
- **fsLR32k: ~/bin/AC-Altas/fs_LR32k**
- **MNI152-2mm: ~/bin/AC-Altas/MNI152**
- **The label value 1,2,3,and 4 in these files represent the "Cluster1", "Cluster2","Cluster3" and "Cluster4", respectively.**

![image](https://github.com/junhaols/Luo2023-AC-Individual-Variability/blob/main/Figures/Final-AC-subregions.png)

# Reference
Luo, J., Qin, P., Bi, Q., Wu, K., & Gong, G. (2024). Individual variability in functional connectivity of human auditory cortex. Cerebral Cortex, bhae007.

# Bugs and Questions
Please contact Junhao Luo at junhaol@mail.bnu.edu.cn and Gaolang Gong at gaolang.gong@gmail.com.
