#!/bin/bash
# 設定 nnU-Net v2 所需的三個路徑 
#請記得改成你的路徑

export nnUNet_raw=/Your_path/nnUnet/dataset/nnUNet_raw
export nnUNet_preprocessed=/Your_path/nnUnet/dataset/nnUNet_preprocessed
export nnUNet_results=/Your_path/nnUnet/dataset/nnUNet_results

echo "[Env] nnUNet_raw          = $nnUNet_raw"
echo "[Env] nnUNet_preprocessed = $nnUNet_preprocessed"
echo "[Env] nnUNet_results      = $nnUNet_results"
