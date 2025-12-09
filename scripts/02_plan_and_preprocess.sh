#!/bin/bash
set -e

# 載入環境變數
source "$(dirname "$0")/01_set_env.sh"

# 對資料集 001 進行資料規劃與預處理
# --verify_dataset_integrity 會檢查資料格式是否正確
echo "[Step] nnUNetv2_plan_and_preprocess for dataset 001"
nnUNetv2_plan_and_preprocess -d 001 --verify_dataset_integrity
