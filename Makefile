CC ?= gcc
CFLAGS ?= -O2 -fopenmp -Wall -Wextra
PYTHON ?= python3

TARGETS = false_sharing numa_sweep compare_numa

.PHONY: all clean run run-sim run-bench

all: $(TARGETS)

false_sharing: false_sharing.c
	$(CC) $(CFLAGS) $< -o $@

numa_sweep: numa_sweep.c
	$(CC) $(CFLAGS) $< -o $@

compare_numa: compare_numa.c
	$(CC) $(CFLAGS) $< -o $@

run-sim:
	$(PYTHON) coherence_sim.py 1000

run-bench: all
	./run_experiments.sh

run: run-bench

clean:
	rm -f $(TARGETS)
