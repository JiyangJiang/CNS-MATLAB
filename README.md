# CNS2 (in development)
 
 **Improvement over CNS**
 
 1. fully based on SPM12 and MATLAB, therefore cross-platform
 2. new segmentation and WMH classification algorithms
 3. more user-friendly (continue with the next scan if errors occur during processing)
 

 **Image segmentation algorithms**

 In order to get rid of FSL FAST and fully using MATLAB and SPM, two image segmentation algorithms have been implemented in UBO Detector in CNS2.

 1. kmeans : This method can pick up subtle WMH, but require more computational resources.
 2. superpixel : This method is much faster than kmeans, but can miss small WMH clusters.
