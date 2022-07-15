# conda-tvm-env
TVM source version and dependency installation for mn pruning work in PD Lab.
This tutorial is for saving your time if you want to install specific version of some package.
Our target version: 
- TVM version=0.9.dev0
- LLVM version=11.0.0

First, clone TVM from github.
```shell
git clone --recursive https://github.com/apache/tvm tvm
git clone https://github.com/RainYuGG/conda-tvm-env.git
```

we use conda virtual environment to install dependent plugins.
So you need to install [conda](https://docs.conda.io/projects/conda/en/latest/user-guide/install/linux.html) by yourself, or use the ```.sh``` file.
```shell
chmod +x conda-tvm-env/Miniconda3-latest-Linux-x86_64.sh
bash conda-tvm-env/Miniconda3-latest-Linux-x86_64.sh
```
- If your system are not linux, you should download current version instead of using this ```.sh``` file .
- If you're using the **csl server**, you have better install conda at ```/local/username/``` of **gpuXX server**.
- After install conda you should ```source ~/.bashrc``` first.

Now, you have this tree structure of the folders.
```shell
├── tvm
│   └── ... 
└── conda-tvm-env
    ├── script.sh
    ├── build-environment.yaml
    ├── meta.yaml
    └── config.cmake

```

## Method 1
Easily run the script at folder where you clone these two git packages.
```shell
chmod +x conda-tvm-env/script.sh
source conda-tvm-env/script.sh
```
- this script includes patch step, creating venv, and the following cmake llvm setting.
- So you need to place ```tvm.patch``` to ```conda-tvm-env``` folder.


## Method 2

Do everything by yourself.

### Create virtual env
Create the conda virtual environment with dependency.
```shell
cd conda-tvm-env
conda env create --file build-environment.yaml
```
- If you use your PC without installing **cuda**, use the deifferet ```.yaml``` file.
```shell
cd conda-tvm-env
conda env create --file local-build-environment.yaml
```


### Patch
Use the patch file from Prof. Hong if needed.
- You should get the ```tvm.patch``` file from the professor, and also need to place the file to ```conda-tvm-env``` folder.

Since we use TVM commmit ```395e91ff54543864a90240d18c8efd8c277c758b```.
```shell
cd tvm
git checkout 395e91ff54543864a90240d18c8efd8c277c758b
patch -p1 < ../conda-tvm-env/tvm.patch
```

Enter the venv.
```shell
conda activate tvm-env
```
After this command, all of works are in venv.
- Everytime you want to use TVM, you should type this first.


### Build TVM
Before you build TVM, you need to replace your llvm location in the line 136 of ```config.cmake``` file.
```shell
set(USE_LLVM /path/to/bin/llvm-config)
```
- If you don't know where it is, type the following command.
- ```which llvm-config ```

Or easily follow these command:
```shell
cd /path/to/tvm/build
cp ../../conda-tvm-env/config.cmake .
sed -i "s+set(USE_LLVM ON)+set(USE_LLVM $(which llvm-config))+g" config.cmake
```


After setting LLVM, build TVM in ```tvm/build``` folder.
```shell
cmake ..
make -j4
```

## 

## Post installation

Install some relative python packages of TVM.
```shell
python -m pip install  numpy decorator attrs tornado psutil 'xgboost<1.6.0' cloudpickle
```

Set the environment values in ``` ~/.bashrc ```. 
```shell
export TVM_HOME=/path/to/tvm
export PYTHONPATH=$TVM_HOME/python:${PYTHONPATH}
```

Check if TVM is well-done installation
```shell
python -m tvm.driver.tvmc --version
```
Now, you can start your work.

## Vector mask
If you use the patch, there is an environment value you can use for vector masking.
可以用環境變數 TVM_VECMASK 來控制vector masking的啟用和關閉.
在autotune或跑程式前用下面指令來啟用masking功能:
```shell
export TVM_VECMASK=1
```
如果要關掉vector masking功能, 使用下面unset指令:
```
unset TVM_VECMASK
```
