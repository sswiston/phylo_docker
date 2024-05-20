## PROGRAMS FOR TESTING:

# PYTHON
echo ""; echo "Checking for python..."; echo ""
python --version

# R
echo ""; echo "Checking for R..."; echo ""
R --version | head -n 2 | tail -n 1

# REVBAYES
echo ""; echo "Checking for RevBayes..."
echo "print(1)" | rb | head -n 3

# TENSORPHYLO
echo ""; echo "Checking for TensorPhylo..."; echo ""
output=$(echo "loadPlugin(\"TensorPhylo\")" | rb | tail -n 2 | head -n 1)
if [ "$output" == "" ]; then echo "TensorPhylo installed!"; else echo "TensorPhylo not found"; fi

# R PACKAGES
echo ""; echo "Testing for R packages..."; echo ""
UE="UE"; SE="SE"

output=`echo $(R -e "\"devtools\" %in% rownames(installed.packages())") | tail -c 7 | head -c 2`
if [ "$output" = "$UE" ]; then echo "devtools installed"; else echo "devtools not found"; fi

output=`echo $(R -e "\"ggplot2\" %in% rownames(installed.packages())") | tail -c 7 | head -c 2`
if [ "$output" = "$UE" ]; then echo "ggplot2 installed"; else echo "ggplot2 not found"; fi

output=`echo $(R -e "\"RevGadgets\" %in% rownames(installed.packages())") | tail -c 7 | head -c 2`
if [ "$output" = "$UE" ]; then echo "RevGadgets installed"; else echo "RevGadgets not found"; fi

output=`echo $(R -e "\"HDInterval\" %in% rownames(installed.packages())") | tail -c 7 | head -c 2`
if [ "$output" = "$UE" ]; then echo "HDInterval installed"; else echo "HDInterval not found"; fi

output=`echo $(R -e "\"rjson\" %in% rownames(installed.packages())") | tail -c 7 | head -c 2`
if [ "$output" = "$UE" ]; then echo "rjson installed"; else echo "rjson not found"; fi

output=`echo $(R -e "\"ape\" %in% rownames(installed.packages())") | tail -c 7 | head -c 2`
if [ "$output" = "$UE" ]; then echo "ape installed"; else echo "ape not found"; fi

output=`echo $(R -e "\"coda\" %in% rownames(installed.packages())") | tail -c 7 | head -c 2`
if [ "$output" = "$UE" ]; then echo "coda installed"; else echo "coda not found"; fi

output=`echo $(R -e "\"cowplot\" %in% rownames(installed.packages())") | tail -c 7 | head -c 2`
if [ "$output" = "$UE" ]; then echo "cowplot installed"; else echo "cowplot not found"; fi

output=`echo $(R -e "\"data.table\" %in% rownames(installed.packages())") | tail -c 7 | head -c 2`
if [ "$output" = "$UE" ]; then echo "data.table installed"; else echo "data.table not found"; fi

output=`echo $(R -e "\"ggtree\" %in% rownames(installed.packages())") | tail -c 7 | head -c 2`
if [ "$output" = "$UE" ]; then echo "ggtree installed"; else echo "ggtree not found"; fi

output=`echo $(R -e "\"grid\" %in% rownames(installed.packages())") | tail -c 7 | head -c 2`
if [ "$output" = "$UE" ]; then echo "grid installed"; else echo "grid not found"; fi

output=`echo $(R -e "\"gridExtra\" %in% rownames(installed.packages())") | tail -c 7 | head -c 2`
if [ "$output" = "$UE" ]; then echo "gridExtra installed"; else echo "gridExtra not found"; fi

output=`echo $(R -e "\"igraph\" %in% rownames(installed.packages())") | tail -c 7 | head -c 2`
if [ "$output" = "$UE" ]; then echo "igraph installed"; else echo "igraph not found"; fi

output=`echo $(R -e "\"reshape2\" %in% rownames(installed.packages())") | tail -c 7 | head -c 2`
if [ "$output" = "$UE" ]; then echo "reshape2 installed"; else echo "reshape2 not found"; fi

output=`echo $(R -e "\"BiocManager\" %in% rownames(installed.packages())") | tail -c 7 | head -c 2`
if [ "$output" = "$UE" ]; then echo "BiocManager installed"; else echo "BiocManager not found"; fi