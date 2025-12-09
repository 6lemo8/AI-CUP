#!/bin/bash
set -e

source "$(dirname "$0")/01_set_env.sh"

echo "[Step] Train all folds for 2D / 3D_fullres / 3D_lowres"

# 2D 五折
for f in 0 1 2 3 4; do
  echo "[Train] Dataset 001, 2d, fold $f"
  nnUNetv2_train 001 2d $f
done

# 3D full resolution 五折
for f in 0 1 2 3 4; do
  echo "[Train] Dataset 001, 3d_fullres, fold $f"
  nnUNetv2_train 001 3d_fullres $f
done

# 3D low resolution 五折
for f in 0 1 2 3 4; do
  echo "[Train] Dataset 001, 3d_lowres, fold $f"
  nnUNetv2_train 001 3d_lowres $f
done
