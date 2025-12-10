AI CUP 2025 — Cardiac Muscle Segmentation
Using nnU-Net v2 (2D + 3D FullRes + 3D LowRes Ensemble)
=======================================================================================================================
本專案為 AI CUP 2025「心臟肌肉影像分割」競賽使用的完整模型流程。
我們採用 nnU-Net v2 作為主要的自動化（AutoML）影像分割框架，並訓練以下三種模型設定：

2D U-Net

3D Full-Resolution U-Net

3D Low-Resolution U-Net

最終預測結果由上述三個模型進行 ensemble（集成推論），並在 leaderboard 上獲得了我們隊伍的最佳成績。

##  🚀 Overview of Our Pipeline  

本研究依照 nnU-Net v2 的標準訓練流程執行，包含：

1.設定環境變數
2.資料規劃與前處理（planning & preprocessing）
3.模型訓練
4.5折交叉驗證
    2D（5 折）
    3D FullRes（5 折）
    3D LowRes（5 折）
5.模型驗證（--val --npz）
6.自動化最佳模型設定搜尋（Auto configuration selection）
7.在 imagesTs 上進行推論
8.三模型集成（2D + 3D_fullres + 3D_lowres ensemble）

## ! 務必記得修該路徑 !
所有步驟皆整合於單一可執行腳本：run_nnunet_full_pipeline.sh 
也可拆成單一步驟執行 : 分別執行 01~06.sh（依需求拆分）

## 📁 Dataset Structure (nnU-Net v2 Format)  

在執行 pipeline 之前，請確認資料集已放置於以下位置：

$nnUNet_raw/Dataset001_AICUP/
    ├── imagesTr/
    ├── labelsTr/
    ├── imagesTs/
    └── dataset.json

這是 nnU-Net v2 官方規定的資料結構。

## 🔧 Environment Requirements  

1.	作業系統（OS）：Ubuntu 22.04.4 LTS
2.	開發介面：JupyterLab（conda 建立虛擬環境）
3.	程式語言版本：Python 3.10
4.	主要套件與工具：
o	PyTorc版本：2.6.0
o	CUDA : 12.4
o	nnU-Net v2
o	NumPy:1.26.4、SciPy: 1.15.3
o	nibabel: 5.2.1、SimpleITK: 2.4.0
5.	硬體設備：NVIDIA RTX A6000（48GB）


##  📄 File Explanation 
run_nnunet_full_pipeline.sh
此檔案包含以下內容：

環境變數設定
nnU-Net 全部訓練指令
驗證流程
推論流程
模型集成（ensemble）流程
此腳本可重現我們提交的模型推論結果。

##  ⚠️ Important Notes  
請務必修改腳本開頭的三個環境變數，使其符合你自己的資料路徑：
export nnUNet_raw=...
export nnUNet_preprocessed=...
export nnUNet_results=...

另外：
nnU-Net v2 由 pip 安裝，因此本 repository 不包含 nnUNetv2 的原始程式碼
本提交檔僅包含我們隊伍自行撰寫的流程腳本、前處理與 ensemble 相關邏輯
