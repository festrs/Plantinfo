#**Plantinfo** [![Build Status](https://travis-ci.org/festrs/Plantinfo.svg?branch=master)](https://travis-ci.org/festrs/Plantinfo)  [![Codacy Badge](https://api.codacy.com/project/badge/Grade/6a7747bff134456cbbc83723fdfdd586)](https://www.codacy.com/app/festrs/Plantinfo?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=festrs/Plantinfo&amp;utm_campaign=Badge_Grade) [![codebeat badge](https://codebeat.co/badges/f4239007-937f-44b7-942f-4e5eaf8c8619)](https://codebeat.co/projects/github-com-festrs-plantinfo)

This project was created as a final paper for the graduation program, of system information at [PUCRS](http://www.pucrs.br/), the goal is to improve the plants classification process and reduce the time at same time. Because of some limitations like, the lack amount images classified of plants and the great quantity of plants, I kept my focus in a specific group of plants, the poisonous or toxic plants.

# Body

This work consists of using deep learning methods for image recognition of plants. The [Caffe](http://caffe.berkeleyvision.org) framework was used to generate the prediction model. A [website](http://plantinfo.herokuapp.com/) complents this mobile aplication bringing more information about the range of plants and auxiliar caracteristics. Also we used the new Deep Learning system from NVIDEA called [DIGITS](https://developer.nvidia.com/digits) whos turned the process a lot easier.

For more information about Deep Learning methods [here](http://cs231n.github.io/convolutional-networks/#add) there is a great article from Stanford University about it.

# Installation

We used cocoapods for managing the dependencies, remember to use **pod install** before compiling.

# Autor

Felipe Pereira [@festrs](festrs.github.io)

**Contributors**

[Rafael Braun](https://www.facebook.com/mbraun.raphael)

## License and Citation

**PlantInfo** is available under the MIT license. See the LICENSE file for more info.

Caffe is released under the [BSD 2-Clause license](https://github.com/BVLC/caffe/blob/master/LICENSE).
The BVLC reference models are released for unrestricted use.

Please cite Caffe in your publications if it helps your research:

    @article{jia2014caffe,
      Author = {Jia, Yangqing and Shelhamer, Evan and Donahue, Jeff and Karayev, Sergey and Long, Jonathan and Girshick, Ross and Guadarrama, Sergio and Darrell, Trevor},
      Journal = {arXiv preprint arXiv:1408.5093},
      Title = {Caffe: Convolutional Architecture for Fast Feature Embedding},
      Year = {2014}
    }