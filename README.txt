Project Name: Simple Panorama
Project Initiated Date: 10/13/2012
Current members: Dongxi Zheng, Qinyuan Sun

Execution Instructions:
One is supposed to open the sourceCode directory in Matlab and run the code in main.m. After running main.m, the user will be guided through the following procedures from the straight forward console prompts. Calculation results and images will be produced on the fly. Note: when asked to select the input folder, the selected folder should contain images that are used as the input and a runconfig.txt file containing the following information:
+--------------------------------------------------------------------------------
+line 1 - the focal length of the camera when taking the input pictures
+line 2 - the k1 parameter
+line 3 - the k2 parameter
+line 4 - the first image file name
+line 5 - the second image file name
+...
+line i - the (i-3)th image file name
+...
+line N+3 - the Nth image file name, where N is the total number of images
+line N+4 - the first image file name (for stitching the first image in both ends)
+--------------------------------------------------------------------------------
The resulting panorama will be saved as "pano.JPG" in the input folder.