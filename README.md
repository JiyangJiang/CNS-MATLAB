# CNS2
 
 **Improvement over CNS**
 
 1. fully based on SPM12 and MATLAB, therefore cross-platform
 2. new segmentation and WMH classification algorithms
 3. more user-friendly (continue with the next scan if errors occur during processing)
 4. more measures regarding volumes and WMH clusters, including average volume per WMH cluster, variance in volumes between WMH clusters, average distance between WMH clusters, etc.
 

 **Image segmentation algorithms in UBO Detector**

 In order to use only MATLAB and SPM, two image segmentation algorithms have been implemented in UBO Detector in CNS2 to replace FSL FAST.

 1. kmeans : This method can pick up subtle WMH, but require more computational resources.
 2. superpixel : This method is much faster than kmeans, but can miss small WMH clusters.
