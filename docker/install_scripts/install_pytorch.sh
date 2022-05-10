#!/bin/bash

set -euxo pipefail

# install pytorch and torchvision
pip install torch==1.7.1+cu101 torchvision==0.8.2+cu101 torchaudio==0.7.2 -f https://download.pytorch.org/whl/torch_stable.html

# Download pre-trained models
python -c 'import torchvision.models as models; resnet34 = models.resnet34(pretrained=True)'
python -c 'import torchvision.models as models; resnet50 = models.resnet50(pretrained=True)'
python -c 'import torchvision.models as models; resnet101 = models.resnet101(pretrained=True)'