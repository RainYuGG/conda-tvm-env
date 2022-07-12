cd tvm
git checkout 395e91ff54543864a90240d18c8efd8c277c758b
patch -p1 < ../conda-tvm-env/tvm.patch
cp ../conda-tvm-env/build-environment.yaml conda/.
#cp ../conda-tvm-env/meta.yaml conda/recipe/.
conda env create --file conda/build-environment.yaml
conda activate tvm-env
mkdir build
cp ../conda-tvm-env/config.cmake build/.
sed -i "s+set(USE_LLVM ON)+set(USE_LLVM $(which llvm-config))+g" build/config.cmake
