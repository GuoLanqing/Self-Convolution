# 2D Patch Self-Convolution

Description
-----

The package includes: 

1. the original SAIST program (directory `demo_SAIST`)

2. 2D image patch and 2D search window version of self-convolution `self_convolution_2d.m`

```
% Goal : self-convolution to replace original block matching (searching K most similar patches of each reference patch)
% Inputs:
%   1. im      : image, Height*Width
%   2. par             : parameters
%      - win           : size of search winodw
%      - step          : step of extracting patches
%      - nblk          : number of similar patches (K)
% Output:
%   1. pos_arr         : K most similar patches for every reference patch
%   within search window, nblk * num_patches
```

Running the Code
-----

- **A Simple Example**<br />
  For a gray-scale image denoising example run the `Denoising_Main.m` file.

Requirements and Dependencies
-----

- Matlab with an Image Processing Toolbox.
