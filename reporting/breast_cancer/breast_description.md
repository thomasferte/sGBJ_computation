Breast cancer
================
TF

- [Describe Breast Cancer cohort](#describe-breast-cancer-cohort)
- [Breast cancer pathway analysis](#breast-cancer-pathway-analysis)
  - [Description of pathways](#description-of-pathways)
  - [Methods comparison](#methods-comparison)

# Describe Breast Cancer cohort

<div id="hifrbpcgkp" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#hifrbpcgkp table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#hifrbpcgkp thead, #hifrbpcgkp tbody, #hifrbpcgkp tfoot, #hifrbpcgkp tr, #hifrbpcgkp td, #hifrbpcgkp th {
  border-style: none;
}
&#10;#hifrbpcgkp p {
  margin: 0;
  padding: 0;
}
&#10;#hifrbpcgkp .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}
&#10;#hifrbpcgkp .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#hifrbpcgkp .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#hifrbpcgkp .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}
&#10;#hifrbpcgkp .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#hifrbpcgkp .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#hifrbpcgkp .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#hifrbpcgkp .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#hifrbpcgkp .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#hifrbpcgkp .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#hifrbpcgkp .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#hifrbpcgkp .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#hifrbpcgkp .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#hifrbpcgkp .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#hifrbpcgkp .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}
&#10;#hifrbpcgkp .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#hifrbpcgkp .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#hifrbpcgkp .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#hifrbpcgkp .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#hifrbpcgkp .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}
&#10;#hifrbpcgkp .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#hifrbpcgkp .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#hifrbpcgkp .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#hifrbpcgkp .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}
&#10;#hifrbpcgkp .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#hifrbpcgkp .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#hifrbpcgkp .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#hifrbpcgkp .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}
&#10;#hifrbpcgkp .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}
&#10;#hifrbpcgkp .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}
&#10;#hifrbpcgkp .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#hifrbpcgkp .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#hifrbpcgkp .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#hifrbpcgkp .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#hifrbpcgkp .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#hifrbpcgkp .gt_left {
  text-align: left;
}
&#10;#hifrbpcgkp .gt_center {
  text-align: center;
}
&#10;#hifrbpcgkp .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#hifrbpcgkp .gt_font_normal {
  font-weight: normal;
}
&#10;#hifrbpcgkp .gt_font_bold {
  font-weight: bold;
}
&#10;#hifrbpcgkp .gt_font_italic {
  font-style: italic;
}
&#10;#hifrbpcgkp .gt_super {
  font-size: 65%;
}
&#10;#hifrbpcgkp .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#hifrbpcgkp .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#hifrbpcgkp .gt_indent_1 {
  text-indent: 5px;
}
&#10;#hifrbpcgkp .gt_indent_2 {
  text-indent: 10px;
}
&#10;#hifrbpcgkp .gt_indent_3 {
  text-indent: 15px;
}
&#10;#hifrbpcgkp .gt_indent_4 {
  text-indent: 20px;
}
&#10;#hifrbpcgkp .gt_indent_5 {
  text-indent: 25px;
}
&#10;#hifrbpcgkp .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}
&#10;#hifrbpcgkp div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="label"><span class='gt_from_md'><strong>Characteristic</strong></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_0"><span class='gt_from_md'><strong>N = 295</strong></span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="label" class="gt_row gt_left">age</td>
<td headers="stat_0" class="gt_row gt_center">44 (40, 49)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">event</td>
<td headers="stat_0" class="gt_row gt_center">106 (36%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">time</td>
<td headers="stat_0" class="gt_row gt_center">6.6 (3.4, 9.8)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">grade</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    1</td>
<td headers="stat_0" class="gt_row gt_center">75 (25%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    2</td>
<td headers="stat_0" class="gt_row gt_center">101 (34%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    3</td>
<td headers="stat_0" class="gt_row gt_center">119 (40%)</td></tr>
  </tbody>
  &#10;  <tfoot class="gt_footnotes">
    <tr>
      <td class="gt_footnote" colspan="2"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span> <span class='gt_from_md'>Median (Q1, Q3); n (%)</span></td>
    </tr>
  </tfoot>
</table>
</div>

<div class="figure">

<img src="breast_description_files/figure-gfm/genecount-1.png" alt="Breast cancer count per patient per tumor type"  />
<p class="caption">
<span id="fig:genecount"></span>Figure 1: Breast cancer count per
patient per tumor type
</p>

</div>

<div class="figure">

<img src="breast_description_files/figure-gfm/breastcancerpca-1.png" alt="First two PCA factorial plans"  />
<p class="caption">
<span id="fig:breastcancerpca"></span>Figure 2: First two PCA factorial
plans
</p>

</div>

Here are the kaplan meier curves for the two types of disease:

<div class="figure">

<img src="breast_description_files/figure-gfm/kmbreastcancer-1.png" alt="Kaplan meier curves for Astro, Oligo"  />
<p class="caption">
<span id="fig:kmbreastcancer"></span>Figure 3: Kaplan meier curves for
Astro, Oligo
</p>

</div>

# Breast cancer pathway analysis

## Description of pathways

<div class="figure">

<img src="breast_description_files/figure-gfm/ecdf-1.png" alt="Empirical Cumulative Distribution Function of number of genes by pathway. Breast cancer study."  />
<p class="caption">
<span id="fig:ecdf"></span>Figure 4: Empirical Cumulative Distribution
Function of number of genes by pathway. Breast cancer study.
</p>

</div>

## Methods comparison

<div class="figure">

<img src="breast_description_files/figure-gfm/nbsign-1.png" alt="Number of significant pathways by method."  />
<p class="caption">
<span id="fig:nbsign"></span>Figure 5: Number of significant pathways by
method.
</p>

</div>

<div class="figure">

<img src="breast_description_files/figure-gfm/upsetplot-1.png" alt="Upset plot of the Benjamini-Hockberg p-value agreement according to the different methods"  />
<p class="caption">
<span id="fig:upsetplot"></span>Figure 6: Upset plot of the
Benjamini-Hockberg p-value agreement according to the different methods
</p>

</div>

<div class="figure">

<img src="breast_description_files/figure-gfm/figpvaluesmethodsbreastcancer-1.png" alt="Raw p-values in function of the ordered ranks of sGBJ for the 4 methods (sGBJ , global boost test, Wald test and global test), with the 5% threshold and the Benjamini Hochberg limit, computed for astrocytoma, oligodendroglioma and all patients. Nota Bene: The Benjamini Hochberg limit only applies for the sGBJ method, as the ranks are computed for sGBJ only."  />
<p class="caption">
<span id="fig:figpvaluesmethodsbreastcancer"></span>Figure 7: Raw
p-values in function of the ordered ranks of sGBJ for the 4 methods
(sGBJ , global boost test, Wald test and global test), with the 5%
threshold and the Benjamini Hochberg limit, computed for astrocytoma,
oligodendroglioma and all patients. Nota Bene: The Benjamini Hochberg
limit only applies for the sGBJ method, as the ranks are computed for
sGBJ only.
</p>

</div>

NB about GT test :
<https://www.bioconductor.org/packages/release/bioc/vignettes/globaltest/inst/doc/GlobalTest.pdf>
: “Because permutations require an exchangeable null hypothesis, such a
permutation p-value is only available for the linear model and for the
exchangeable null hypotheses ~1 and ~0 in other models.”
