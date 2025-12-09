#!/bin/bash
set -e

source "$(dirname "$0")/01_set_env.sh"

# 測試集影像路徑 & 結果輸出路徑
DATASET_NAME="Dataset001_AICUP"
IMAGES_TS="$nnUNet_raw/${DATASET_NAME}/imagesTs"

OUT_2D="$nnUNet_results/${DATASET_NAME}/predictions_2d"
OUT_3D_FULL="$nnUNet_results/${DATASET_NAME}/predictions_3d_fullres"
OUT_3D_LOW="$nnUNet_results/${DATASET_NAME}/predictions_3d_lowres"

echo "[Info] imagesTs = $IMAGES_TS"
echo "[Info] OUT_2D  = $OUT_2D"
echo "[Info] OUT_3D_FULL = $OUT_3D_FULL"
echo "[Info] OUT_3D_LOW  = $OUT_3D_LOW"

mkdir -p "$OUT_2D" "$OUT_3D_FULL" "$OUT_3D_LOW"

# 2D 預測
echo "[Predict] 2d, folds 0-4"
nnUNetv2_predict \
  -d $DATASET_NAME \
  -i "$IMAGES_TS" \
  -o "$OUT_2D" \
  -f 0 1 2 3 4 \
  -tr nnUNetTrainer \
  -c 2d \
  -p nnUNetPlans \
  --save_probabilities

# 3D fullres 預測
echo "[Predict] 3d_fullres, folds 0-4"
nnUNetv2_predict \
  -d $DATASET_NAME \
  -i "$IMAGES_TS" \
  -o "$OUT_3D_FULL" \
  -f 0 1 2 3 4 \
  -tr nnUNetTrainer \
  -c 3d_fullres \
  -p nnUNetPlans \
  --save_probabilities

# 3D lowres 預測
echo "[Predict] 3d_lowres, folds 0-4"
nnUNetv2_predict \
  -d $DATASET_NAME \
  -i "$IMAGES_TS" \
  -o "$OUT_3D_LOW" \
  -f 0 1 2 3 4 \
  -tr nnUNetTrainer \
  -c 3d_lowres \
  -p nnUNetPlans \
  --save_probabilities
