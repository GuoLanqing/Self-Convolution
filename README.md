# Self-Convolution

Description
-----

Self-Convolution is a self-supervised and highly-efficient image operator that exploits non-local similarity. Self-Convolution can generalize many commonly-used non-local schemes, including block matching and non-local means. 

![avatar](Self-Conv.pdf)

This repo contains the Matlab code package of Self-Convolution which focuses on equivalent  implementation of block matching, which includes 2D-patch and 3D-patch versions of Self-Convolution (dimension of the reference image patch). For each version, we provide a demo to show Self-Convolution can speed up the non-local denoising algorithm. To be specific, [SAIST](http://see.xidian.edu.cn/faculty/wsdong/Papers/Journal/TIP_LASSC.pdf) as an example method relying on 2D patches, and our proposed multi-modality image denoising method [Self-MM](https://arxiv.org/abs/2006.13714) as example of 3D patch. 

The Self-Convolution functions can be plugged in any block matching based image restoration method, just follow the similar usage steps.

Usage
-----
* 2D Patch

Example method: [SAIST](http://see.xidian.edu.cn/faculty/wsdong/Papers/Journal/TIP_LASSC.pdf)

Usage: 

1. replace `Block_matching.m` function with our `self_convolution_2d.m` function (2d here refers to the two-dimensional search window)

2. run `Denoising_Main.m` (a gray-scale image denoising demo)

* 3D Patch

Example method: [Self-MM](https://arxiv.org/abs/2006.13714)

Usage: run `demo_rgbnir_denoising.m` (a RGB-NIR image denoising demo)

Experimental Results
-----
Runtime (in seconds) comparisons of non-local algorithms using BM and Self-Convolution, for denoising 512 * 512 single-channel images (first 7 rows) and 256 * 256 * q multi-channel images  (last 3 rows), where BMtime\% denotes the runtime portion of BM.

|  Method   | Original Runtime | Self-Conv Runtime | BMtime\% |Original BM | Self-Conv | Speed-Ups|
|  ----  | ----  | ----  | ----  | ----  | ----  | ----  |
| [SAIST](http://see.xidian.edu.cn/faculty/wsdong/Papers/Journal/TIP_LASSC.pdf) | 708.2 | 562.2 | 32.0\% |227.0 |78.6 |3X |
| [WNNM](https://ieeexplore.ieee.org/document/6909762) | 63.2 | 43.8 | 36.9\% | 23.3 |7.8| 3X |
| [STROOLR](http://ieeexplore.ieee.org/abstract/document/7952566/) | 87.7 | 68.9 | 36.7\% | 38.2 | 13.3 | 3X |
| [GHP](https://www.cv-foundation.org/openaccess/content_cvpr_2013/papers/Zuo_Texture_Enhanced_Image_2013_CVPR_paper.pdf)|  412.6 | 218.3 |69.9\% |288.6 |94.2 |3X|
| [NCSR](http://www4.comp.polyu.edu.hk/~cslzhang/paper/NCSR_TIP_final.pdf) |  134.7 | 82.4 | 57.1\% | 76.9 | 28.1 | 3X |
| [PGPD](http://www4.comp.polyu.edu.hk/~cslzhang/paper/PGPD.pdf) |  305.2 | 89.6 | 85.3\%| 260.3  | 41.3 | 6X|
| [RRC](https://arxiv.org/abs/1807.02504)  | 601.2 | 505.6 | 26.9\%| 161.8  | 74.2 | 2X |
| [MCWNNM](http://www4.comp.polyu.edu.hk/~csjunxu/paper/MCWNNM.pdf) | 2899.0 | 2371.3 | 15.8\%| 458.6  | 61.6 | 8X |
|[SALT](http://transformlearning.csl.illinois.edu/assets/Bihan/ConferencePapers/BihanICCV2017salt.pdf) | 375.9 |113.8 |75.4\% |294.8  |33.2 |9X|
| [Self-MM](https://arxiv.org/abs/2006.13714) |139.0| 44.3 |78.8\% |109.5 |16.3 |7X|

All the experiments are carried out in the Matlab (R2019b) environmentrunning on a PC with Intel(R) Core(TM) i9-10920K CPU 3.50GHz.

Citation
-----
Paper available [here](https://ieeexplore.ieee.org/document/9414124). 

In case of use, please cite our publication:

L. Guo, Z. Zha, S. Ravishankar and B. Wen, "Self-Convolution: A Highly-Efficient Operator for Non-Local Image Restoration," ICASSP 2021.

Bibtex:
```
@INPROCEEDINGS{9414124,
  author={Guo, Lanqing and Zha, Zhiyuan and Ravishankar, Saiprasad and Wen, Bihan},
  booktitle={ICASSP 2021 - 2021 IEEE International Conference on Acoustics, Speech and Signal Processing (ICASSP)}, 
  title={Self-Convolution: A Highly-Efficient Operator for Non-Local Image Restoration}, 
  year={2021},
  volume={},
  number={},
  pages={1860-1864},
  doi={10.1109/ICASSP39728.2021.9414124}}
```
