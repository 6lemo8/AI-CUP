#!/bin/bash
set -e

source "$(dirname "$0")/01_set_env.sh"

echo "[Step] Run validation + save npz for all configurations"

# 2D
for f in 0 1 2 3 4; do
  echo "[Val] Dataset 001, 2d, fold $f"
  nnUNetv2_train 001 2d $f --val --npz
done

# 3D fullres
for f in 0 1 2 3 4; do
  echo "[Val] Dataset 001, 3d_fullres, fold $f"
  nnUNetv2_train 001 3d_fullres $f --val --npz
done

# 3D lowres
for f in 0 1 2 3 4; do
  echo "[Val] Dataset 001, 3d_lowres, fold $f"
  nnUNetv2_train 001 3d_lowres $f --val --npz
done

echo "[Step] Find best configuration across 2d / 3d_fullres / 3d_lowres"
nnUNetv2_find_best_configuration 001 -c 2d 3d_fullres 3d_lowres -f 0 1 2 3 4
