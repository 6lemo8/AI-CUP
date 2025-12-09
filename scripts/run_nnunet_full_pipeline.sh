#!/bin/bash
set -e

################################################################################
# ⚠️【重要提醒】請依照你的實際資料位置修改以下三個路徑！！
################################################################################

export nnUNet_raw=/NFS/Pinky/nnUnet/dataset/nnUNet_raw
export nnUNet_preprocessed=/NFS/Pinky/nnUnet/dataset/nnUNet_preprocessed
export nnUNet_results=/NFS/Pinky/nnUnet/dataset/nnUNet_results

echo "-----------------------------------------------------------"
echo " nnU-Net environment paths (請確認是否正確)"
echo " nnUNet_raw          = $nnUNet_raw"
echo " nnUNet_preprocessed = $nnUNet_preprocessed"
echo " nnUNet_results      = $nnUNet_results"
echo "-----------------------------------------------------------"

################################################################################
# Step 1–3: Dataset planning & preprocessing
################################################################################
echo "[Step 3] Running nnUNetv2_plan_and_preprocess..."
nnUNetv2_plan_and_preprocess -d 001 --verify_dataset_integrity

################################################################################
# Step 4: Train 2D (folds 0–4)
################################################################################
echo "[Step 4] Training 2D models..."
for f in 0 1 2 3 4; do
    nnUNetv2_train 001 2d $f
done

################################################################################
# Step 5: Train 3D_fullres + 3D_lowres (folds 0–4)
################################################################################
echo "[Step 5] Training 3d_fullres models..."
for f in 0 1 2 3 4; do
    nnUNetv2_train 001 3d_fullres $f
done

echo "[Step 5] Training 3d_lowres models..."
for f in 0 1 2 3 4; do
    nnUNetv2_train 001 3d_lowres $f
done

################################################################################
# Step 6: Validation --val --npz
################################################################################
echo "[Step 6] Validating 2D models..."
for f in 0 1 2 3 4; do
    nnUNetv2_train 001 2d $f --val --npz
done

echo "[Step 6] Validating 3d_fullres models..."
for f in 0 1 2 3 4; do
    nnUNetv2_train 001 3d_fullres $f --val --npz
done

echo "[Step 6] Validating 3d_lowres models..."
for f in 0 1 2 3 4; do
    nnUNetv2_train 001 3d_lowres $f --val --npz
done

################################################################################
# Step 7: AutoML–Find best configuration
################################################################################
echo "[Step 7] Finding best model configuration..."
nnUNetv2_find_best_configuration 001 -c 2d 3d_fullres 3d_lowres -f 0 1 2 3 4

################################################################################
# Step 8–10: Prediction
################################################################################
DATASET_NAME=Dataset001_AICUP
IMAGES_TS="$nnUNet_raw/$DATASET_NAME/imagesTs"

OUT_2D="$nnUNet_results/$DATASET_NAME/predictions_2d"
OUT_3D_FULL="$nnUNet_results/$DATASET_NAME/predictions_3d_fullres"
OUT_3D_LOW="$nnUNet_results/$DATASET_NAME/predictions_3d_lowres"

mkdir -p "$OUT_2D" "$OUT_3D_FULL" "$OUT_3D_LOW"

echo "[Step 8] Predicting using 2D model..."
nnUNetv2_predict -d $DATASET_NAME -i "$IMAGES_TS" -o "$OUT_2D" \
 -f 0 1 2 3 4 -tr nnUNetTrainer -c 2d -p nnUNetPlans --save_probabilities

echo "[Step 9] Predicting using 3d_fullres model..."
nnUNetv2_predict -d $DATASET_NAME -i "$IMAGES_TS" -o "$OUT_3D_FULL" \
 -f 0 1 2 3 4 -tr nnUNetTrainer -c 3d_fullres -p nnUNetPlans --save_probabilities

echo "[Step 10] Predicting using 3d_lowres model..."
nnUNetv2_predict -d $DATASET_NAME -i "$IMAGES_TS" -o "$OUT_3D_LOW" \
 -f 0 1 2 3 4 -tr nnUNetTrainer -c 3d_lowres -p nnUNetPlans --save_probabilities

################################################################################
# Step 11: Final Ensemble
################################################################################
ENSEMBLE_OUT="$nnUNet_results/$DATASET_NAME/ensemble_predictions"
mkdir -p "$ENSEMBLE_OUT"

echo "[Step 11] Running final ensemble..."
nnUNetv2_ensemble \
 -i "$OUT_2D" "$OUT_3D_FULL" "$OUT_3D_LOW" \
 -o "$ENSEMBLE_OUT" -np 8

echo "==========================================================="
echo " 🎉 完成！完整 nnU-Net pipeline 執行結束"
echo " 最終預測存放於：$ENSEMBLE_OUT"
echo "==========================================================="
