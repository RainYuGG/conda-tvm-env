cd tvm
git checkout 395e91ff54543864a90240d18c8efd8c277c758b
patch -p1 < ../conda-tvm-env/tvm.patch
conda env create --file ../conda-tvm-env/build-environment.yaml
conda activate tvm-env
mkdir build
cd build
cp ../../conda-tvm-env/config.cmake .
sed -i "s+set(USE_LLVM ON)+set(USE_LLVM $(which llvm-config))+g" config.cmake
cmake ..
make -j4
