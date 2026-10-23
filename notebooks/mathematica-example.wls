(* Mathematica（Wolfram Language）の例

   実行（リポジトリ直下で）: wolframscript -file notebooks\mathematica-example.wls

   Quarto の原稿（.qmd）の計算は Python だけで行うので、Mathematica の結果は
   図やデータのファイルに書き出し、原稿から読み込む。
   - 図: manuscript/figures/ に PDF（論文用）と PNG（Web 用）
   - 数値: manuscript/data/ に CSV

   画面に出す文字（Print など）は英語にする。
   wolframscript は日本語の文字列を正しく読めないことがある。コメントは日本語でよい。 *)

(* リポジトリ直下のフォルダ。このファイルの場所から決める *)
root = If[StringQ[$InputFileName] && $InputFileName =!= "",
  ParentDirectory[DirectoryName[$InputFileName]],
  Directory[]];

(* 図を作る *)
plot = Plot[{Sin[x], Cos[x]}, {x, 0, 2 Pi},
  PlotLegends -> {"sin x", "cos x"},
  AxesLabel -> {"x", None},
  ImageSize -> 400];

(* 図を書き出す *)
figDir = FileNameJoin[{root, "manuscript", "figures"}];
Quiet[CreateDirectory[figDir]];
Export[FileNameJoin[{figDir, "mma-trig.pdf"}], plot];
Export[FileNameJoin[{figDir, "mma-trig.png"}], plot, ImageResolution -> 200];

(* 数値結果を CSV で書き出す *)
dataDir = FileNameJoin[{root, "manuscript", "data"}];
Quiet[CreateDirectory[dataDir]];
data = Table[{x, N[Sin[x]]}, {x, 0, 2 Pi, Pi/8}];
Export[FileNameJoin[{dataDir, "mma-sin.csv"}], Prepend[data, {"x", "sin_x"}]];

Print["Exported: ", FileNames["mma-trig.*", figDir]];
Print["Exported: ", FileNameJoin[{dataDir, "mma-sin.csv"}]];
