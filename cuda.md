# Multi cuda + multi venv

## Install cuda
```
wget https://developer.download.nvidia.com/compute/cuda/11.7.0/local_installers/cuda_11.7.0_515.43.04_linux.run
bash cuda_11.7.0_515.43.04_linux.run --installpath=/opt/cuda_11.7  --no-man-page --silent
```
All cuda lib will be in `/opt/cuda_11.7/lib64`. You just now need to point `$LD_LIBRARY_PATH` there to use that specific version of cuda

## Install venv
```
python3.10 -m venv venv-cu117
echo "export LD_LIBRARY_PATH=/opt/cuda_11.7/lib64:$LD_LIBRARY_PATH" >> venv/cu117/bin/activate
echo "export PATH=/opt/cuda_11.7/bin:$PATH" >> venv/cu117/bin/activate
```
Now when you activate your venv, cuda 11.7 will be used. Independantly to your OS cuda and other venv cuda. 

