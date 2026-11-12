#!/usr/bin/env bash
# run_experiments.sh - Automated benchmark script for Experiment 4
set -e

echo "=================================================="
echo "Phase 1: Compiling C Programs..."
echo "=================================================="
echo "Compiling false_sharing.c..."
gcc -O2 false_sharing.c -fopenmp -o false_sharing
echo "Compiling numa_sweep.c..."
gcc -O2 numa_sweep.c -fopenmp -o numa_sweep
echo "Compiling compare_numa.c..."
gcc -O2 compare_numa.c -fopenmp -o compare_numa
echo "Compilation complete."
echo ""

echo "=================================================="
echo "Phase 2: Running Part A - Protocol Simulator"
echo "=================================================="
python3 coherence_sim.py 1000
echo ""

echo "=================================================="
echo "Phase 3: Running Part B1 - False Sharing (2 Threads)"
echo "=================================================="
echo "Running adjacent layout (False Sharing)..."
OMP_NUM_THREADS=2 ./false_sharing adjacent
echo "Running padded layout (No False Sharing)..."
OMP_NUM_THREADS=2 ./false_sharing padded
echo ""

echo "=================================================="
echo "Phase 4: Running Part B2 - NUMA Comparison"
echo "=================================================="
echo "--> Test 1: Default Placement (Tables 1 & 2)"
./compare_numa
echo ""

echo "--> Test 2: Local Memory Allocation (Node 0 for CPU and Memory)"
if command -v numactl >/dev/null 2>&1; then
    numactl --cpunodebind=0 --membind=0 ./compare_numa
else
    echo "numactl not available; skipping local memory binding test."
fi
echo ""

echo "--> Test 3: Remote Memory Allocation (CPU on Node 0, Memory on Node 1)"
if command -v numactl >/dev/null 2>&1; then
    numactl --cpunodebind=0 --membind=1 ./compare_numa
else
    echo "numactl not available; skipping remote memory binding test."
fi
echo ""

echo "=================================================="
echo "Experiment execution complete!"
echo "Note: The lab manual recommends running each configuration three times and recording the median time for accurate results."
echo "=================================================="
