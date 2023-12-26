
#SRC=${GEM_FORGE_TOP}/transform/benchmark/GemForgeMicroSuite/omp_dense_mv_blk/omp_dense_mv_blk.c
#SRC=${GEM_FORGE_TOP}/transform/benchmark/GemForgeMicroSuite/omp_va/omp_va.c
#SRC=${GEM_FORGE_TOP}/transform/benchmark/GemForgeMicroSuite/omp_indirect_va/omp_indirect_va.c
#SRC=${GEM_FORGE_TOP}/transform/benchmark/GemForgeMicroSuite/trusted_spmm_csr/trusted_spmm_csr.c
SRC=${GEM_FORGE_TOP}/transform/benchmark/GemForgeMicroSuite/trusted_sddmm_csr/trusted_sddmm_csr.c
#SRC=${GEM_FORGE_TOP}/transform/benchmark/GemForgeMicroSuite/searchwithoptgraph/searchwithoptgraph.cpp

FLAGS=-O3 -DGEM_FORGE -mavx -fopenmp -std=c11 -gline-tables-only
PSP_FLAGS=-O3 -DPSP -DGEM_FORGE -mavx -fopenmp -std=c11 -gline-tables-only
#FLAGS=-O3 -DGEM_FORGE -mavx -fopenmp -std=c++11 -gline-tables-only
#PSP_FLAGS=-O3 -DPSP -DGEM_FORGE -mavx -fopenmp -std=c++11 -gline-tables-only

LLVM_RELEASE=${GEM_FORGE_TOP}/llvm/install-release/bin
CC=${LLVM_RELEASE}/clang
#CC=${LLVM_RELEASE}/clang++
CXX=${LLVM_RELEASE}/clang++
LLVM_DIS=${LLVM_RELEASE}/llvm-dis
LLVM_ASM=${LLVM_RELEASE}/llc

GEM_FORGE_TRANSFORM_SO=${GEM_FORGE_TOP}/transform/build/src/libLLVMTDGPass.so

# We use debug version to enable the debug flags.
LLVM_DEBUG=${GEM_FORGE_TOP}/llvm/install-debug/bin
OPT=${LLVM_DEBUG}/opt

GEM5_INC=${GEM_FORGE_TOP}/gem5/include
GEM5_OPS=${GEM_FORGE_TOP}/gem5/util/m5/m5op_x86.S

# Gem Forge requires the bitcode named.
raw.bc: ${SRC}
	${CC} $^ ${FLAGS} -c -emit-llvm -I${GEM5_INC} -o $@
	${OPT} -instnamer $@ -o $@

raw.ll: raw.bc
	${LLVM_DIS} $^ -o $@

# Generate assembly code from IR
raw.S: raw.ll
	${LLVM_ASM} $^ -o $@

# Gem Forge requires the bitcode named.
psp_raw.bc: ${SRC}
	${CC} $^ ${PSP_FLAGS} -c -emit-llvm -I${GEM5_INC} -o $@
	${OPT} -instnamer $@ -o $@

psp_raw.ll: psp_raw.bc
	${LLVM_DIS} $^ -o $@

# Generate assembly code from IR
psp_raw.S: psp_raw.ll
	${LLVM_ASM} $^ -o $@

INST_UID=inst.uid
PSP_INST_UID=psp_inst.uid
TRACE_FUNC=.omp_outlined.
TRACE_FILE=fake.trace

traced.bc: raw.bc
	${OPT} -load=${GEM_FORGE_TRANSFORM_SO} -trace-pass $^ -o $@ -trace-inst-uid-file ${INST_UID} -trace-function ${TRACE_FUNC}
	touch ${TRACE_FILE}

psp_traced.bc: psp_raw.bc
	${OPT} -load=${GEM_FORGE_TRANSFORM_SO} -trace-pass $^ -o $@ -trace-inst-uid-file ${PSP_INST_UID} -trace-function ${TRACE_FUNC}
	touch ${TRACE_FILE}

VALID_OUT=valid
VALID_EXTRA=valid/extra
valid.bc: traced.bc raw.bc
	mkdir -p ${VALID_OUT}
	mkdir -p ${VALID_EXTRA}
	${OPT} -load=${GEM_FORGE_TRANSFORM_SO} -valid-execution-pass \
		raw.bc -o $@ \
		-gem-forge-roi-function=${TRACE_FUNC} \
		-gem-forge-inst-uid-file=${INST_UID} \
		-output-datagraph=${VALID_OUT}/fake.0.tdg \
		-output-extra-folder-path=${VALID_EXTRA}
	cp ${VALID_EXTRA}/ex.bc $@

STREAM_OUT=stream
STREAM_EXTRA=stream/extra
stream.bc: traced.bc raw.bc
	mkdir -p ${STREAM_OUT}
	mkdir -p ${STREAM_EXTRA}
	${OPT} -load=${GEM_FORGE_TRANSFORM_SO} -stream-execution-static-pass \
		-stream-pass-choose-strategy=static-outer \
		-stream-pass-allow-aliased-stream \
		-stream-pass-enable-store \
		raw.bc -o $@ \
		-gem-forge-roi-function=${TRACE_FUNC} \
		-gem-forge-inst-uid-file=${INST_UID} \
		-output-datagraph=${STREAM_OUT}/fake.0.tdg \
		-output-extra-folder-path=${STREAM_EXTRA}
	cp ${STREAM_EXTRA}/ex.bc $@

PSP_OUT=psp
PSP_EXTRA=psp/extra
psp.bc: psp_traced.bc psp_raw.bc
	mkdir -p ${PSP_OUT}
	mkdir -p ${PSP_EXTRA}
	${OPT} -load=${GEM_FORGE_TRANSFORM_SO} -valid-execution-pass \
		psp_raw.bc -o $@ \
		-gem-forge-roi-function=${TRACE_FUNC} \
		-gem-forge-inst-uid-file=${PSP_INST_UID} \
		-output-datagraph=${PSP_OUT}/fake.0.tdg \
		-output-extra-folder-path=${PSP_EXTRA}
	cp ${PSP_EXTRA}/ex.bc $@

%.o: %.bc
	${CC} -c -O3 -ffp-contract=off $^ -o $@

%.exe: %.o
	${CXX} -static -o $@ $^ -lomp -lpthread -Wl,--no-as-needed -ldl -I${GEM5_INC} ${GEM5_OPS} 

.PHONY: clean
clean:
	rm -f *.bc *.ll *.o *.exe ${INST_UID} *.txt  *.trace *.S

.PHONY: clean-all
clean-all: clean
	rm -rf valid stream psp uve_proxy

GEM5=${GEM_FORGE_TOP}/gem5/build/X86/gem5.opt
GEM5_CONFIG=${GEM_FORGE_TOP}/gem5/configs/example/gem_forge/run.py

#THREADS=1
THREADS=8
#ARGUMENTS='${THREADS}'
#ARGUMENTS='${THREADS} ${GEM_FORGE_TOP}/dataset/graph/harvard'
#ARGUMENTS='${THREADS} ${GEM_FORGE_TOP}/dataset/graph/youtube'
ARGUMENTS='${THREADS} ${GEM_FORGE_TOP}/dataset/graph/ogbn-mag'
#ARGUMENTS='${THREADS} ${GEM_FORGE_TOP}/dataset/graph/ogbn-products'
#ARGUMENTS='${THREADS} ${GEM_FORGE_TOP}/dataset/graph/reddit'
#ARGUMENTS='${THREADS} ${GEM_FORGE_TOP}/dataset/graph/yelp'
#ARGUMENTS='${THREADS} ${GEM_FORGE_TOP}/dataset/graph/igb_medium_split/igb_medium_0'
#ARGUMENTS='${THREADS} ${GEM_FORGE_TOP}/dataset/graph/igb_medium'
#ARGUMENTS='${THREADS} ${GEM_FORGE_TOP}/dataset/graph/ogbn-papers100M-split/ogbn-papers100M_1'
#ARGUMENTS='${THREADS} ${GEM_FORGE_TOP}/dataset/graph/ogbn-papers100M'
#ARGUMENTS='${THREADS} ${GEM_FORGE_TOP}/dataset/synth_10M_256dim.bin'
#ARGUMENTS='${THREADS} ../dataset/graph/sift1M/sift1M_base ../dataset/graph/sift1M/sift1M_query ../dataset/graph/sift1M/sift1M_nsg 40 10'
#ARGUMENTS='${THREADS} ../dataset/graph/gist1M/gist1M_base ../dataset/graph/gist1M/gist1M_query ../dataset/graph/gist1M/gist1M_nsg 108 10'
#ARGUMENTS='${THREADS} ../dataset/graph/deep1M/deep1M_base ../dataset/graph/deep1M/deep1M_query ../dataset/graph/deep1M/deep1M_nsg 40 10'

O8_SIM=--llvm-store-queue-size=50 \
	--llvm-load-queue-size=80 \
	--llvm-mcpat=0 \
	--caches \
	--l2cache \
	--gem-forge-num-active-cpus=1 \
	--gem-forge-cache-load-ports=6 \
	--gem-forge-cache-store-ports=4 \
	--link-width-bits=256 \
	--llc-select-low-bit=6 \
	--cpu-type=DerivO3CPU \
	--llvm-issue-width=8 \
	--gem-forge-enable-func-acc-tick \
	--prog-interval=10000 \
	--tlb-timing-se \
	--l1tlb-size=64 \
	--l1tlb-assoc=8 \
	--l2tlb-size=2048 \
	--l2tlb-assoc=16 \
	--l2tlb-hit-lat=8 \
	--walker-se-lat=180 \
	--walker-se-port=4 \
	--num-cpus=8 \
	--num-dirs=4 \
	--num-l2caches=8 \
	--mesh-rows=4 \
	--ruby \
	--access-backing-store \
	--network=garnet2.0 \
	--garnet-enable-multicast \
	--router-latency=2 \
	--link-latency=1 \
	--mem-type="DDR4_2400_16x4" \
	--mem-size=16GB \
	--mem-channels=2 \
	--topology=MeshDirCorners_XY \
	--routing-YX \
	--l1i_size=32kB \
	--l1i_assoc=8 \
	--l1d_size=32kB \
	--l1d_lat=8 \
	--l1d_mshrs=8 \
	--l1d_assoc=8 \
	--l1_5d_size=256kB \
	--l1_5d_assoc=16 \
	--l1_5d_mshrs=16 \
	--l2_lat=17 \
	--l2_size=1MB \
	--l2_assoc=16 \
	--l3_lat=74 \
	--fast-forward=-1 \
	--options=${ARGUMENTS}

.PHONY: valid.o8.sim
valid.o8.sim: valid.exe
	${GEM5} \
		--outdir=${VALID_OUT}/o8 \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${O8_SIM}

.PHONY: valid.o8-pf.sim
valid.o8-pf.sim: valid.exe
	${GEM5} \
		--outdir=${VALID_OUT}/o8-pf \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${O8_SIM} \
		--gem-forge-prefetcher=bingo \
		--gem-forge-l2-prefetcher=stride \
		--gem-forge-l2-prefetch-dist=16 \

.PHONY: psp.o8.sim
psp.o8.sim: psp.exe
	${GEM5} \
		--outdir=${PSP_OUT}/o8 \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${O8_SIM} \
		--gem-forge-psp-frontend-enable \
		--gem-forge-psp-frontend-index-queue-capacity=64 \
		--gem-forge-psp-frontend-pa-queue-capacity=4 \
		--gem-forge-psp-tlb-prefetch-only \
		--gem-forge-psp-backend-enable \
		--gem-forge-psp-backend-prefetch-distance=8 \
		--gem-forge-l2-prefetcher=stride \
		--gem-forge-l2-prefetch-dist=8 \

.PHONY: psp.o8-pf.sim
psp.o8-pf.sim: psp.exe
	${GEM5} \
		--outdir=${PSP_OUT}/o8-pf \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${O8_SIM} \
		--gem-forge-psp-frontend-enable \
		--gem-forge-psp-frontend-index-queue-capacity=64 \
		--gem-forge-psp-frontend-pa-queue-capacity=4 \
		--gem-forge-psp-backend-enable \
		--gem-forge-psp-backend-prefetch-distance=8 \
		--gem-forge-l2-prefetcher=stride \
		--gem-forge-l2-prefetch-dist=8 \

.PHONY: stream.o8.sim
stream.o8.sim: stream.exe
	cp $^ ${STREAM_EXTRA}/
	${GEM5} \
		--outdir=${STREAM_OUT}/o8 \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=${STREAM_EXTRA}/$^ \
		${O8_SIM} \
		--gem-forge-stream-engine-enable \
		--gem-forge-stream-engine-total-run-ahead-bytes=2048 \
		--gem-forge-stream-engine-enable-lsq \
		--gem-forge-stream-engine-enable-coalesce \
		--gem-forge-stream-engine-throttling=global 

.PHONY: stream.o8-float.sim
stream.o8-float.sim: stream.exe
	cp $^ ${STREAM_EXTRA}/
	${GEM5} \
		--outdir=${STREAM_OUT}/o8-float \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=${STREAM_EXTRA}/$^ \
		${O8_SIM} \
		--gem-forge-stream-engine-enable \
		--gem-forge-stream-engine-total-run-ahead-bytes=2048 \
		--gem-forge-stream-engine-enable-lsq \
		--gem-forge-stream-engine-enable-coalesce \
		--gem-forge-stream-engine-throttling=global \
		--gem-forge-stream-engine-enable-float \
		--gem-forge-stream-engine-mlc-stream-buffer-init-num-entries=32 \
		--gem-forge-stream-engine-float-policy=smart \
		--gem-forge-stream-engine-enable-float-indirect \
		--gem-forge-stream-engine-enable-float-subline \
		--gem-forge-stream-engine-enable-float-advance-migrate \
		--gem-forge-stream-engine-llc-stream-max-infly-request=16 \
		--llc-select-low-bit=10 \

IO_SIM=--llvm-store-queue-size=4 \
	--llvm-load-queue-size=4 \
	--llvm-mcpat=0 \
	--caches \
	--l2cache \
	--gem-forge-num-active-cpus=1 \
	--gem-forge-cache-load-ports=2 \
	--gem-forge-cache-store-ports=2 \
	--link-width-bits=256 \
	--llc-select-low-bit=6 \
	--cpu-type=MinorCPU \
	--llvm-issue-width=2 \
	--gem-forge-enable-func-acc-tick \
	--prog-interval=10000 \
	--tlb-timing-se \
	--l1tlb-size=64 \
	--l1tlb-assoc=4 \
	--l2tlb-size=2048 \
	--l2tlb-assoc=16 \
	--l2tlb-hit-lat=8 \
	--walker-se-lat=880 \
	--walker-se-port=1 \
	--num-cpus=8 \
	--num-dirs=4 \
	--num-l2caches=8 \
	--mesh-rows=4 \
	--ruby \
	--access-backing-store \
	--network=garnet2.0 \
	--garnet-enable-multicast \
	--router-latency=2 \
	--link-latency=1 \
	--mem-type="DDR4_2400_16x4" \
	--mem-channels=4 \
	--mem-size=128GB \
	--topology=MeshDirCorners_XY \
	--routing-YX \
	--l1i_size=32kB \
	--l1i_assoc=8 \
	--l1d_size=32kB \
	--l1d_lat=8 \
	--l1d_mshrs=4 \
	--l1d_assoc=8 \
	--l1_5d_size=256kB \
	--l1_5d_assoc=16 \
	--l1_5d_mshrs=8 \
	--l2_lat=17 \
	--l2_size=1MB \
	--l2_assoc=16 \
	--l3_lat=74 \
	--fast-forward=-1 \
	--options=${ARGUMENTS}

.PHONY: valid.io.sim
valid.io.sim: valid.exe
	${GEM5} \
		--outdir=${VALID_OUT}/io \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${IO_SIM} > valid.io.log

.PHONY: valid.io-pf.sim
valid.io-pf.sim: valid.exe
	${GEM5} \
		--outdir=${VALID_OUT}/io-pf \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${IO_SIM} \
		--gem-forge-prefetcher=stride > valid.io-pf.log
		
#		--gem-forge-l2-prefetcher=stride \
#		--gem-forge-l2-prefetch-dist=16 \

.PHONY: psp.io.sim
psp.io.sim: psp.exe
	${GEM5} \
		--outdir=${PSP_OUT}/io \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${IO_SIM} \
		--gem-forge-psp-frontend-enable \
		--gem-forge-psp-frontend-total-pattern-table-entries=4 \
		--gem-forge-psp-frontend-index-queue-capacity=64 \
		--gem-forge-psp-frontend-pa-queue-capacity=4 \
		--gem-forge-psp-tlb-prefetch-only \
		--gem-forge-psp-backend-enable \
		--gem-forge-psp-backend-num-stream-entry=4 \
		--gem-forge-psp-backend-prefetch-distance=4 \
		--gem-forge-prefetcher=stride > psp.io.log
		
#		--gem-forge-l2-prefetcher=stride \
#		--gem-forge-l2-prefetch-dist=16 \

#		--debug-flags=ISAPSPFrontend \
#		--debug-flags=PSPFrontend \
#		--debug-flags=PSPBackend \

.PHONY: psp.io-pf.sim
psp.io-pf.sim: psp.exe
	${GEM5} \
		--outdir=${PSP_OUT}/io-pf \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${IO_SIM} \
		--gem-forge-psp-frontend-enable \
		--gem-forge-psp-frontend-total-pattern-table-entries=4 \
		--gem-forge-psp-frontend-index-queue-capacity=64 \
		--gem-forge-psp-frontend-pa-queue-capacity=4 \
		--gem-forge-psp-backend-enable \
		--gem-forge-psp-backend-num-stream-entry=4 \
		--gem-forge-psp-backend-prefetch-distance=4 \
		--gem-forge-prefetcher=stride > psp.io-pf.log

#		--gem-forge-l2-prefetcher=stride \
#		--gem-forge-l2-prefetch-dist=16 \

.PHONY: uve_proxy.io-pf.sim
uve_proxy.io-pf.sim: psp.exe
	${GEM5} \
		--outdir=uve_proxy/io-pf \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${IO_SIM} \
		--gem-forge-psp-frontend-enable \
		--gem-forge-psp-frontend-index-queue-capacity=64 \
		--gem-forge-psp-frontend-pa-queue-capacity=8 \
		--gem-forge-psp-tlb-prefetch-only \
		--gem-forge-psp-data-prefetch-only \
		--gem-forge-psp-backend-enable \
		--gem-forge-psp-backend-num-stream-entry=8 \
		--gem-forge-psp-backend-prefetch-distance=4 \
		--gem-forge-prefetcher=stride > uve_proxy.io-pf.log

.PHONY: stream.io.sim
stream.io.sim: stream.exe
	cp $^ ${STREAM_EXTRA}/
	${GEM5} \
		--outdir=${STREAM_OUT}/io \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=${STREAM_EXTRA}/$^ \
		${IO_SIM} \
		--gem-forge-stream-engine-enable \
		--gem-forge-stream-engine-total-run-ahead-bytes=2048 \
		--gem-forge-stream-engine-enable-lsq \
		--gem-forge-stream-engine-enable-coalesce \
		--gem-forge-stream-engine-throttling=global > stream.io.log 

.PHONY: stream.io-float.sim
stream.io-float.sim: stream.exe
	cp $^ ${STREAM_EXTRA}/
	${GEM5} \
		--outdir=${STREAM_OUT}/io-float \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=${STREAM_EXTRA}/$^ \
		${IO_SIM} \
		--gem-forge-stream-engine-enable \
		--gem-forge-stream-engine-total-run-ahead-bytes=2048 \
		--gem-forge-stream-engine-enable-lsq \
		--gem-forge-stream-engine-enable-coalesce \
		--gem-forge-stream-engine-throttling=global \
		--gem-forge-stream-engine-enable-float \
		--gem-forge-stream-engine-mlc-stream-buffer-init-num-entries=32 \
		--gem-forge-stream-engine-float-policy=smart \
		--gem-forge-stream-engine-enable-float-indirect \
		--gem-forge-stream-engine-enable-float-subline \
		--gem-forge-stream-engine-enable-float-advance-migrate \
		--gem-forge-stream-engine-llc-stream-max-infly-request=16 \
		--llc-select-low-bit=10 > stream.io-float.log

.PHONY: sim-o3
sim-o3: valid.o8.sim valid.o8-pf.sim stream.o8.sim stream.o8-float.sim psp.o8.sim psp.o8-pf.sim # uve.proxy.sim
	echo "Simulation O3 core all done!"

.PHONY: sim-io
sim-io: valid.io.sim valid.io-pf.sim stream.io.sim stream.io-float.sim psp.io.sim psp.io-pf.sim uve_proxy.io-pf.sim
	echo "Simulation IO core all done!"

.PHONY: sim-all
sim-all: valid.o8.sim valid.o8-pf.sim stream.o8.sim stream.o8-float.sim valid.io.sim valid.io-pf.sim stream.io.sim stream.io-float.sim
	echo "Simulation all done!"
