Breast cancer
================
TF

- <a href="#describe-breast-cancer-cohort"
  id="toc-describe-breast-cancer-cohort">Describe Breast Cancer cohort</a>
- <a href="#breast-cancer-pathway-analysis"
  id="toc-breast-cancer-pathway-analysis">Breast cancer pathway
  analysis</a>
  - <a href="#description-of-pathways"
    id="toc-description-of-pathways">Description of pathways</a>
  - <a href="#methods-comparison" id="toc-methods-comparison">Methods
    comparison</a>

# Describe Breast Cancer cohort

<div id="mazygublqg" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#mazygublqg .gt_table {
  display: table;
  border-collapse: collapse;
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

#mazygublqg .gt_heading {
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

#mazygublqg .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#mazygublqg .gt_title {
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

#mazygublqg .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#mazygublqg .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#mazygublqg .gt_col_headings {
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

#mazygublqg .gt_col_heading {
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

#mazygublqg .gt_column_spanner_outer {
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

#mazygublqg .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#mazygublqg .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#mazygublqg .gt_column_spanner {
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

#mazygublqg .gt_group_heading {
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

#mazygublqg .gt_empty_group_heading {
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

#mazygublqg .gt_from_md > :first-child {
  margin-top: 0;
}

#mazygublqg .gt_from_md > :last-child {
  margin-bottom: 0;
}

#mazygublqg .gt_row {
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

#mazygublqg .gt_stub {
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

#mazygublqg .gt_stub_row_group {
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

#mazygublqg .gt_row_group_first td {
  border-top-width: 2px;
}

#mazygublqg .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#mazygublqg .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#mazygublqg .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#mazygublqg .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#mazygublqg .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#mazygublqg .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#mazygublqg .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#mazygublqg .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#mazygublqg .gt_footnotes {
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

#mazygublqg .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#mazygublqg .gt_sourcenotes {
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

#mazygublqg .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#mazygublqg .gt_left {
  text-align: left;
}

#mazygublqg .gt_center {
  text-align: center;
}

#mazygublqg .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#mazygublqg .gt_font_normal {
  font-weight: normal;
}

#mazygublqg .gt_font_bold {
  font-weight: bold;
}

#mazygublqg .gt_font_italic {
  font-style: italic;
}

#mazygublqg .gt_super {
  font-size: 65%;
}

#mazygublqg .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#mazygublqg .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#mazygublqg .gt_indent_1 {
  text-indent: 5px;
}

#mazygublqg .gt_indent_2 {
  text-indent: 10px;
}

#mazygublqg .gt_indent_3 {
  text-indent: 15px;
}

#mazygublqg .gt_indent_4 {
  text-indent: 20px;
}

#mazygublqg .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;Characteristic&lt;/strong&gt;"><strong>Characteristic</strong></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;N = 260&lt;/strong&gt;&lt;sup class=&quot;gt_footnote_marks&quot;&gt;1&lt;/sup&gt;"><strong>N = 260</strong><sup class="gt_footnote_marks">1</sup></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="label" class="gt_row gt_left">age</td>
<td headers="stat_0" class="gt_row gt_center">45.0 (41.0, 49.0)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">event</td>
<td headers="stat_0" class="gt_row gt_center">88 (34%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">time</td>
<td headers="stat_0" class="gt_row gt_center">7.0 (4.9, 10.1)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">grade</td>
<td headers="stat_0" class="gt_row gt_center"></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    1</td>
<td headers="stat_0" class="gt_row gt_center">70 (27%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    2</td>
<td headers="stat_0" class="gt_row gt_center">91 (35%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    3</td>
<td headers="stat_0" class="gt_row gt_center">99 (38%)</td></tr>
  </tbody>
  
  <tfoot class="gt_footnotes">
    <tr>
      <td class="gt_footnote" colspan="2"><sup class="gt_footnote_marks">1</sup> Median (IQR); n (%)</td>
    </tr>
  </tfoot>
</table>
</div>

<div class="figure">

<img src="breast_description_files/figure-gfm/genecount-1.png" alt="Breast cancer count per patient per tumor type"  />
<p class="caption">
Figure 1: Breast cancer count per patient per tumor type
</p>

</div>

<div class="figure">

<img src="breast_description_files/figure-gfm/breastcancerpca-1.png" alt="First two PCA factorial plans"  />
<p class="caption">
Figure 2: First two PCA factorial plans
</p>

</div>

Here are the kaplan meier curves for the two types of disease:

<div class="figure">

<img src="breast_description_files/figure-gfm/kmbreastcancer-1.png" alt="Kaplan meier curves for Astro, Oligo"  />
<p class="caption">
Figure 3: Kaplan meier curves for Astro, Oligo
</p>

</div>

# Breast cancer pathway analysis

## Description of pathways

<div class="figure">

<img src="breast_description_files/figure-gfm/ecdf-1.png" alt="Empirical Cumulative Distribution Function of number of genes by pathway. Breast cancer study."  />
<p class="caption">
Figure 4: Empirical Cumulative Distribution Function of number of genes
by pathway. Breast cancer study.
</p>

</div>

## Methods comparison

<div class="figure">

<img src="breast_description_files/figure-gfm/nbsign-1.png" alt="Number of significant pathways by method."  />
<p class="caption">
Figure 5: Number of significant pathways by method.
</p>

</div>

<div class="figure">

<img src="breast_description_files/figure-gfm/upsetplot-1.png" alt="Upset plot of the Benjamini-Hockberg p-value agreement according to the different methods"  />
<p class="caption">
Figure 6: Upset plot of the Benjamini-Hockberg p-value agreement
according to the different methods
</p>

</div>

<div class="figure">

<img src="breast_description_files/figure-gfm/figpvaluesmethodsbreastcancer-1.png" alt="Raw p-values in function of the ordered ranks of sGBJ for the 4 methods (sGBJ , global boost test, Wald test and global test), with the 5% threshold and the Benjamini Hochberg limit, computed for astrocytoma, oligodendroglioma and all patients. Nota Bene: The Benjamini Hochberg limit only applies for the sGBJ method, as the ranks are computed for sGBJ only."  />
<p class="caption">
Figure 7: Raw p-values in function of the ordered ranks of sGBJ for the
4 methods (sGBJ , global boost test, Wald test and global test), with
the 5% threshold and the Benjamini Hochberg limit, computed for
astrocytoma, oligodendroglioma and all patients. Nota Bene: The
Benjamini Hochberg limit only applies for the sGBJ method, as the ranks
are computed for sGBJ only.
</p>

</div>

NB about GT test :
<https://www.bioconductor.org/packages/release/bioc/vignettes/globaltest/inst/doc/GlobalTest.pdf>
: “Because permutations require an exchangeable null hypothesis, such a
permutation p-value is only available for the linear model and for the
exchangeable null hypotheses \~1 and \~0 in other models.”
