# conda-tvm-env
TVM source version and dependency installation for mn pruning work in PD Lab.
This tutorial is for saving your time if you want to install specific version of some package.
Our target version: 
- TVM version=0.9.dev0
- LLVM version=11.0.0

## Install conda and llvm dependency

we use conda virtual environment to install dependent plugins.
So you need to install conda by yourself.


First, clone TVM from github.
```shell
git clone --recursive https://github.com/apache/tvm tvm
git clone https://github.com/RainYuGG/conda-tvm-env.git
```

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
#### Patch
Use the patch file from Prof. Hong if needed.
You should get the ```tvm.patch``` file from professor.
We use TVM commmit ```395e91ff54543864a90240d18c8efd8c277c758b```.
```shell
cd tvm
git checkout 395e91ff54543864a90240d18c8efd8c277c758b
patch -p1 < ../conda-tvm-env/tvm.patch
```

### Create virtual env
#### Method 1
Create the conda virtual environment with dependency.
```shell
cd /path/to/conda-tvm-env
conda create -- file build-environment.yaml
```

#### Method 2
Or just easily run the script at parent folder where you clone these two git package.
```shell
chmod +x conda-tvm-env/script.sh
bash conda-tvm-env/script.sh
```
- this script includes patch step, creating venv, and the following cmake llvm setting.
- So you need to place ```tvm.patch``` to ```conda-tvm-env``` folder.

Enter the venv.
```shell
conda activate tvm-env
```
After this command, all of works are in venv.


## Build TVM
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
