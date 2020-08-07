# 3D Patch Self-Convolution

Description
-----

The package includes: 1. directory `demo_Self-MM` (the original Self-MM program)

[Self-MM](https://arxiv.org/abs/2006.13714) is a multi-modality image denoising framework based on self-covolution and online sparse and group low-rank model learning scheme.

2. 3D image patch and 2D search window version of self-convolution `self_convolution_2d.m`

```
% Goal : self-convolution to replace original block matching (searching K most similar patches of each reference patch)
% Inputs:
%   1. Xr      : image, Height*Width*Channels
%   2. X            : extracted patches, patch_size*num_patches
%   3. param             : parameters
%      - PatchNO         : number of similar patches (K)
%      - PatchSize       : size of image patch
%      - SearchWin       : size of search window
%      - step            : step of extracting patches
% Output:
%   1. NLBLK     : K most similar patches for every reference patch
%   within search window, PatchNO * num_patches
```


Running the Code
-----

- **A Simple Example**<br />
  For a RGB-NIR image denoising example run the 'demo_rgbnir_denoising.m' file.

Requirements and Dependencies
-----

- Matlab with an Image Processing Toolbox.
