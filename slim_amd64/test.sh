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