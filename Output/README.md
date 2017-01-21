# Some example output files from the initial analysis
## Circular cord diagram of networks thresholded at 10% density
WPLI values for all between electrode connections that survive a threshold of 10% above the minimal spanning tree. Connections are shaded according to their strength with blue connections indication a negative relationship and red indicating a positive one. All right-hemisphere electrodes are marked in yellow whearas all left-hemisphere electrodes are marked in blue. Central or midline electrodes are marked grey. All nodes in the cicrular diagram are scaled according to the number of connections they have that survive the 10% threshold.

![Networks](https://raw.githubusercontent.com/rb643/fieldtrip_restingState/master/Figures/CircularNetwork.tif)



## Comparing pairwise connections within every band
Lower triangle shows p-values that resulting from a groupwise permutation test of each connection. The upper triangle indicates which connections survive FDR correction for multiple comparisons. Clicking on the figures opens an embeded file that can be navigated.


### Delta Band WPLI Connectivity
<div>
    <a href="https://plot.ly/~rb643/18/?share_key=Rf1zkStv5LjjHszQPrdpNm" target="_blank" title="Delta WPLI" style="display: block; text-align: center;"><img src="https://plot.ly/~rb643/18.png?share_key=Rf1zkStv5LjjHszQPrdpNm" alt="Delta WPLI" style="max-width: 100%;width: 1500px;"  width="1500" onerror="this.onerror=null;this.src='https://plot.ly/404.png';" /></a>
    <script data-plotly="rb643:18" sharekey-plotly="Rf1zkStv5LjjHszQPrdpNm" src="https://plot.ly/embed.js" async></script>    
</div>

### Theta Band WPLI Connectivity
<div>
    <a href="https://plot.ly/~rb643/23/?share_key=Rf1zkStv5LjjHszQPrdpNm" target="_blank" title="Theta WPLI" style="display: block; text-align: center;"><img src="https://plot.ly/~rb643/23.png?share_key=Rf1zkStv5LjjHszQPrdpNm" alt="Theta WPLI" style="max-width: 100%;width: 1500px;"  width="1500" onerror="this.onerror=null;this.src='https://plot.ly/404.png';" /></a>
    <script data-plotly="rb643:23" sharekey-plotly="Rf1zkStv5LjjHszQPrdpNm" src="https://plot.ly/embed.js" async></script>
</div>

### Alpha Band WPLI Connectivity
<div>
    <a href="https://plot.ly/~rb643/26/?share_key=Rf1zkStv5LjjHszQPrdpNm" target="_blank" title="Alpha WPLI" style="display: block; text-align: center;"><img src="https://plot.ly/~rb643/26.png?share_key=Rf1zkStv5LjjHszQPrdpNm" alt="Alpha WPLI" style="max-width: 100%;width: 1500px;"  width="1500" onerror="this.onerror=null;this.src='https://plot.ly/404.png';" /></a>
    <script data-plotly="rb643:26" sharekey-plotly="Rf1zkStv5LjjHszQPrdpNm" src="https://plot.ly/embed.js" async></script>
</div>

### Beta Band WPLI Connectivity
<div>
    <a href="https://plot.ly/~rb643/29/?share_key=Rf1zkStv5LjjHszQPrdpNm" target="_blank" title="Beta WPLI" style="display: block; text-align: center;"><img src="https://plot.ly/~rb643/29.png?share_key=Rf1zkStv5LjjHszQPrdpNm" alt="Beta WPLI" style="max-width: 100%;width: 1500px;"  width="1500" onerror="this.onerror=null;this.src='https://plot.ly/404.png';" /></a>
    <script data-plotly="rb643:29" sharekey-plotly="Rf1zkStv5LjjHszQPrdpNm" src="https://plot.ly/embed.js" async></script>
</div>

### Gamma Band WPLI Connectivity
<div>
    <a href="https://plot.ly/~rb643/32/?share_key=Rf1zkStv5LjjHszQPrdpNm" target="_blank" title="Gamma WPLI" style="display: block; text-align: center;"><img src="https://plot.ly/~rb643/32.png?share_key=Rf1zkStv5LjjHszQPrdpNm" alt="Gamma WPLI" style="max-width: 100%;width: 1500px;"  width="1500" onerror="this.onerror=null;this.src='https://plot.ly/404.png';" /></a>
    <script data-plotly="rb643:32" sharekey-plotly="Rf1zkStv5LjjHszQPrdpNm" src="https://plot.ly/embed.js" async></script>
</div>

## Graph theory analysis
The figure below presents the 4 main whole brain graph metrics that were investigated across a density of 0-30% above the minimal spanning tree for all the five frequency bands. Lines represent group means and shaded errors indicate the standard error of the mean. Permutations tests across groups revealed no consistent differences that survived multiple comparison correction (correcting for each cost point at which an analysis was conducted). 

![Graph Metrics](https://raw.githubusercontent.com/rb643/fieldtrip_restingState/master/Figures/Graphs.tif)


