#!/usr/bin/env python3
"""
rename_to_nnunet.py
---------------------------------
在 nnU-Net dataset 資料夾內（imagesTr / labelsTr / imagesTs）
統一改成 nnU-Net v2 標準命名格式：

imagesTr / imagesTs:  patientXXXX_0000.nii.gz
labelsTr:             patientXXXX.nii.gz
"""

import os
import re
from pathlib import Path

ROOT = Path("/home/jupyter/Pinky/nnUnet/dataset/nnUNet_raw/Dataset001_AICUP")
FOLDERS = ["imagesTr", "imagesTs", "labelsTr"]
PREFIX = "patient"
MOD_ID = "0000"

def find_last_digits(s: str):
    """抓檔名中最後一串數字"""
    m = list(re.finditer(r"(\d+)", s))
    return m[-1].group(1) if m else None

def rename_folder(folder: Path, need_mod_suffix: bool):
    for f in sorted(folder.glob("*.nii*")):
        stem = f.name
        digits = find_last_digits(stem)
        if not digits:
            print(f"[SKIP] 無數字: {f.name}")
            continue
        cid = digits.zfill(4)
        new_name = f"{PREFIX}{cid}_{MOD_ID}.nii.gz" if need_mod_suffix else f"{PREFIX}{cid}.nii.gz"
        new_path = folder / new_name
        if f.name == new_name:
            continue  # already correct
        print(f"[RENAME] {f.name} -> {new_name}")
        f.rename(new_path)

def main():
    for folder_name in FOLDERS:
        folder = ROOT / folder_name
        if not folder.exists():
            print(f"[WARN] 找不到資料夾: {folder}")
            continue
        print(f"=== 處理 {folder_name} ===")
        if folder_name in ("imagesTr", "imagesTs"):
            rename_folder(folder, need_mod_suffix=True)
        else:  # labelsTr
            rename_folder(folder, need_mod_suffix=False)

if __name__ == "__main__":
    main()
