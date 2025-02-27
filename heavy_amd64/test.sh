## PROGRAMS FOR TESTING:

# PYTHON
echo ""; echo "Checking for python..."; echo ""
python --version

# R
echo ""; echo "Checking for R..."; echo ""
R --version | head -n 1

# JULIA
echo ""; echo "Checking for Julia..."; echo ""
julia --version | head -n 2

# REVBAYES
echo ""; echo "Checking for RevBayes..."
echo "print(1)" | rb | head -n 3

# TENSORPHYLO
echo ""; echo "Checking for TensorPhylo..."; echo ""
output=$(echo "loadPlugin(\"TensorPhylo\")" | rb | tail -n 2 | head -n 1)
if [ "$output" == "" ]; then echo "TensorPhylo installed!"; else echo "TensorPhylo not found"; fi

# PHYLOJUNCTION
echo ""; echo "Checking for PhyloJunction..."; echo ""
output=$(echo "pjcli" | tail -n 6)
if [ "$output" == "pjcli" ]; then echo "PhyloJunction installed!"; else echo "PhyloJunction not found"; fi

# PYTHON PACKAGES
echo ""; echo "Checking for Python packages..."; echo ""
for package in "PySide6" "Bio" "scipy" "seaborn" "tabulate" "matplotlib" "dendropy"
do
    test=$(cat <<EOF
try: import ${package}; print("${package} installed")
except: print("${package} not found")
EOF
    )
    python -c "$test"
done

# R PACKAGES
echo ""; echo "Testing for R packages..."; echo ""
UE="UE"; SE="SE"
for package in "Rcpp" "devtools" "rjson" "data.table" "reshape2" "dplyr" "Rmpfr" "sf" "distributions3" "HDInterval" "ratematrix" "diversitree" "TreeSim" "TreePar" "FossilSim" "corHMM" "hisse" "OUwie" "castor" "TESS" "RPANDA" "rphenoscape" "treeplyr" "rphenoscate" "paleobuddy" "CRABS" "cowplot" "tikzDevice" "ggtree" "RevGadgets"
do
    output=`echo $(R -e "\"${package}\" %in% rownames(installed.packages())") | tail -c 7 | head -c 2`
    if [ "$output" = "$UE" ]; then echo "$package installed"; else echo "$package not found"; fi
done
echo ""; echo "Full List:"; echo ""
echo $(R -e "cat(rownames(installed.packages()))") | cut -d ">" -f2- | cut -c 38- | rev | cut -c 4- | rev

# JULIA PACKAGES
echo ""; echo "Testing for Julia packages..."; echo ""

for package in "StatsBase" "Combinatorics" "PProf" "Distributions" "Phylo" "Optim" "RCall" "Tapestree" "Parameters" "StaticArrays" "BenchmarkTools" "SIMD" "Setfield" "KernelDensity" "PDMats" "SpecialFunctions" "ExponentialUtilities"
do
    julia -e "try import ${package} catch; println(\"${package} not found\") else println(\"${package} installed\") end"
done

# JAVA
echo "Checking for java..."; echo ""
java -version

# BEAST2
echo ""; echo "Checking for BEAST..."; echo ""
beast -version | head -n 1

# BEAGLE
echo ""; echo "Checking for Beagle..."; echo ""
beast -beagle_info | tail -n 5