#!/bin/bash
set -e

source "$(dirname "$0")/01_set_env.sh"

DATASET_NAME="Dataset001_AICUP"
BASE_RES="$nnUNet_results/${DATASET_NAME}"

PRED_2D="${BASE_RES}/predictions_2d"
PRED_3D_FULL="${BASE_RES}/predictions_3d_fullres"
PRED_3D_LOW="${BASE_RES}/predictions_3d_lowres"
OUT_ENSEMBLE="${BASE_RES}/ensemble_predictions"

mkdir -p "$OUT_ENSEMBLE"

echo "[Ensemble] Inputs:"
echo "  2D         = $PRED_2D"
echo "  3D fullres = $PRED_3D_FULL"
echo "  3D lowres  = $PRED_3D_LOW"
echo "  Output     = $OUT_ENSEMBLE"

nnUNetv2_ensemble \
  -i "$PRED_2D" "$PRED_3D_FULL" "$PRED_3D_LOW" \
  -o "$OUT_ENSEMBLE" \
  -np 8
