cd tvm
git checkout 395e91ff54543864a90240d18c8efd8c277c758b
cp ../conda-tvm-env/build-environment.yaml conda/.
#cp ../conda-tvm-env/meta.yaml conda/recipe/.
mkdir build
cp ../conda-tvm-env/config.cmake build/.
patch -p1 < ../conda-tvm-env/tvm.patch
conda env create --file conda/build-environment.yaml
