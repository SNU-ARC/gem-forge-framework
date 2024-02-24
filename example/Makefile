SRC=${GEM_FORGE_TOP}/transform/benchmark/GemForgeMicroSuite/trusted_spmm_csr/trusted_spmm_csr.c
#SRC=${GEM_FORGE_TOP}/transform/benchmark/GemForgeMicroSuite/trusted_sddmm_csr/trusted_sddmm_csr.c
#SRC=${GEM_FORGE_TOP}/transform/benchmark/GemForgeMicroSuite/searchwithoptgraph/searchwithoptgraph.cpp

FLAGS=-O3 -DGEM_FORGE -DPTTIME -mavx -fopenmp -std=c11 -gline-tables-only
PSP_FLAGS=-O3 -DPSP -DGEM_FORGE -DPTTIME -mavx -fopenmp -std=c11 -gline-tables-only
SSP_FLAGS=-O3 -DSSP -DGEM_FORGE -DPTTIME -DDIM=128 -mavx -fopenmp -std=c11 -gline-tables-only
#SSP_FLAGS=-O3 -DSSP -DGEM_FORGE -DPTTIME -mavx -fopenmp -std=c11 -gline-tables-only
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

# Gem Forge requires the bitcode named.
ssp_raw.bc: ${SRC}
	${CC} $^ ${SSP_FLAGS} -c -emit-llvm -I${GEM5_INC} -o $@
	${OPT} -instnamer $@ -o $@

ssp_raw.ll: ssp_raw.bc
	${LLVM_DIS} $^ -o $@

# Generate assembly code from IR
ssp_raw.S: ssp_raw.ll
	${LLVM_ASM} $^ -o $@

INST_UID=inst.uid
PSP_INST_UID=psp_inst.uid
SSP_INST_UID=ssp_inst.uid
TRACE_FUNC=.omp_outlined.
TRACE_FILE=fake.trace

traced.bc: raw.bc
	${OPT} -load=${GEM_FORGE_TRANSFORM_SO} -trace-pass $^ -o $@ -trace-inst-uid-file ${INST_UID} -trace-function ${TRACE_FUNC}
	touch ${TRACE_FILE}

psp_traced.bc: psp_raw.bc
	${OPT} -load=${GEM_FORGE_TRANSFORM_SO} -trace-pass $^ -o $@ -trace-inst-uid-file ${PSP_INST_UID} -trace-function ${TRACE_FUNC}
	touch ${TRACE_FILE}

ssp_traced.bc: ssp_raw.bc
	${OPT} -load=${GEM_FORGE_TRANSFORM_SO} -trace-pass $^ -o $@ -trace-inst-uid-file ${SSP_INST_UID} -trace-function ${TRACE_FUNC}
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
stream.bc: ssp_traced.bc ssp_raw.bc
	mkdir -p ${STREAM_OUT}
	mkdir -p ${STREAM_EXTRA}
	${OPT} -load=${GEM_FORGE_TRANSFORM_SO} -stream-execution-static-pass \
		-stream-pass-choose-strategy=static-outer \
		-stream-pass-allow-aliased-stream \
		-stream-pass-enable-store \
		ssp_raw.bc -o $@ \
		-gem-forge-roi-function=${TRACE_FUNC} \
		-gem-forge-inst-uid-file=${SSP_INST_UID} \
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
	rm -f *.bc *.ll *.o *.exe ${INST_UID} ${SSP_INST_UID} ${PSP_INST_UID} *.txt  *.trace *.S

.PHONY: clean-all
clean-all: clean
	rm -rf valid stream psp ssp_proxy

GEM5=${GEM_FORGE_TOP}/gem5/build/X86/gem5.opt
GEM5_CONFIG=${GEM_FORGE_TOP}/gem5/configs/example/gem_forge/run.py

THREADS=16
ROWS=4
ARGUMENTS='${THREADS} ${GEM_FORGE_TOP}/dataset/graph/harvard'
#ARGUMENTS='${THREADS} ${GEM_FORGE_TOP}/dataset/graph/youtube'
#ARGUMENTS='${THREADS} ${GEM_FORGE_TOP}/dataset/graph/ogbn-mag'
#ARGUMENTS='${THREADS} ${GEM_FORGE_TOP}/dataset/graph/ogbn-products'
#ARGUMENTS='${THREADS} ${GEM_FORGE_TOP}/dataset/graph/reddit'
#ARGUMENTS='${THREADS} ${GEM_FORGE_TOP}/dataset/graph/yelp'
#ARGUMENTS='${THREADS} ${GEM_FORGE_TOP}/dataset/graph/reddit_feat_1024'
#ARGUMENTS='${THREADS} ${GEM_FORGE_TOP}/dataset/graph/reddit_feat_768'
#ARGUMENTS='${THREADS} ${GEM_FORGE_TOP}/dataset/graph/reddit_feat_512'
#ARGUMENTS='${THREADS} ${GEM_FORGE_TOP}/dataset/graph/reddit_feat_256'
#ARGUMENTS='${THREADS} ${GEM_FORGE_TOP}/dataset/graph/reddit_feat_128'
#ARGUMENTS='${THREADS} ${GEM_FORGE_TOP}/dataset/graph/reddit_feat_64'
#ARGUMENTS='${THREADS} ../dataset/graph/sift1M/sift1M_base ../dataset/graph/sift1M/sift1M_query ../dataset/graph/sift1M/sift1M_nsg 40 10'
#ARGUMENTS='${THREADS} ../dataset/graph/gist1M/gist1M_base ../dataset/graph/gist1M/gist1M_query ../dataset/graph/gist1M/gist1M_nsg 108 10'
#ARGUMENTS='${THREADS} ../dataset/graph/deep1M/deep1M_base ../dataset/graph/deep1M/deep1M_query ../dataset/graph/deep1M/deep1M_nsg 40 10'

LOCAL_WALK_SIM=--llvm-store-queue-size=4 \
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
	--llvm-issue-width=4 \
	--gem-forge-enable-func-acc-tick \
	--prog-interval=10000 \
	--tlb-timing-se \
	--l1tlb-size=64 \
	--l1tlb-assoc=4 \
	--l2tlb-size=512 \
	--l2tlb-assoc=16 \
	--l2tlb-hit-lat=8 \
	--walker-se-lat=110 \
	--walker-se-port=4 \
	--num-cpus=${THREADS} \
	--num-dirs=4 \
	--num-l2caches=${THREADS} \
	--mesh-rows=${ROWS} \
	--ruby \
	--access-backing-store \
	--network=garnet2.0 \
	--garnet-enable-multicast \
	--router-latency=2 \
	--link-latency=1 \
	--mem-type="DDR4_2400_16x4" \
	--mem-channels=4 \
	--mem-size=16GB \
	--topology=MeshDirCorners_XY \
	--routing-YX \
	--l1i_size=32kB \
	--l1i_assoc=8 \
	--l1d_size=32kB \
	--l1d_lat=2 \
	--l1d_mshrs=8 \
	--l1d_assoc=8 \
	--l2_size=256kB \
	--l2_assoc=16 \
	--l2_lat=20\
	--l2_mshrs=20 \
	--fast-forward=-1 \
	--options=${ARGUMENTS}

.PHONY: valid.local.sim
valid.local.sim: valid.exe
	${GEM5} \
		--outdir=${VALID_OUT}/local \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${LOCAL_WALK_SIM} \
		> valid.local.log

.PHONY: valid.local-stride-pf.sim
valid.local-stride-pf.sim: valid.exe
	${GEM5} \
		--outdir=${VALID_OUT}/local-stride-pf \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${LOCAL_WALK_SIM} \
		--gem-forge-prefetcher=stride \
		> valid.local-stride-pf.log

.PHONY: valid.local-bingo-pf.sim
valid.local-bingo-pf.sim: valid.exe
	${GEM5} \
		--outdir=${VALID_OUT}/local-bingo-pf \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${LOCAL_WALK_SIM} \
		--gem-forge-prefetcher=bingo \
		> valid.local-bingo-pf.log

.PHONY: valid.local-imp-pf.sim
valid.local-imp-pf.sim: valid.exe
	${GEM5} \
		--outdir=${VALID_OUT}/local-imp-pf \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${LOCAL_WALK_SIM} \
		--gem-forge-prefetch-on-access \
		--gem-forge-prefetcher=imp \
		> valid.local-imp-pf.log

.PHONY: psp.local-tlb.sim
psp.local-tlb.sim: psp.exe
	${GEM5} \
		--outdir=${PSP_OUT}/local-tlb \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${LOCAL_WALK_SIM} \
		--gem-forge-psp-frontend-enable \
		--gem-forge-psp-frontend-total-pattern-table-entries=4 \
		--gem-forge-psp-frontend-index-queue-capacity=64 \
		--gem-forge-psp-frontend-pa-queue-capacity=4 \
		--gem-forge-psp-tlb-prefetch-only \
		--gem-forge-psp-backend-enable \
		--gem-forge-psp-backend-num-stream-entry=8 \
		--gem-forge-psp-backend-prefetch-distance=8 \
		--gem-forge-psp-queue-size=2 \
		> psp.local-tlb.log

.PHONY: psp.local-pf.sim
psp.local-pf.sim: psp.exe
	${GEM5} \
		--outdir=${PSP_OUT}/local-pf \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${LOCAL_WALK_SIM} \
		--gem-forge-psp-frontend-enable \
		--gem-forge-psp-frontend-total-pattern-table-entries=4 \
		--gem-forge-psp-frontend-index-queue-capacity=64 \
		--gem-forge-psp-frontend-pa-queue-capacity=2 \
		--gem-forge-psp-data-prefetch-only \
		--gem-forge-psp-backend-enable \
		--gem-forge-psp-backend-num-stream-entry=8 \
		--gem-forge-psp-backend-prefetch-distance=8 \
		--gem-forge-psp-queue-size=2 \
		> psp.local-pf.log

.PHONY: psp.local-tlb-pf.sim
psp.local-tlb-pf.sim: psp.exe
	${GEM5} \
		--outdir=${PSP_OUT}/local-tlb-pf \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${LOCAL_WALK_SIM} \
		--gem-forge-psp-frontend-enable \
		--gem-forge-psp-frontend-total-pattern-table-entries=4 \
		--gem-forge-psp-frontend-index-queue-capacity=64 \
		--gem-forge-psp-frontend-pa-queue-capacity=4 \
		--gem-forge-psp-backend-enable \
		--gem-forge-psp-backend-num-stream-entry=8 \
		--gem-forge-psp-backend-prefetch-distance=8 \
		--gem-forge-psp-queue-size=2 \
		> psp.local-tlb-pf.log
#		--debug-flags=MinorCPU \
#		--debug-flags=MinorMem \
#		--debug-flags=Drain \
#		--debug-flags=Quiesce \

.PHONY: ssp_proxy.local-little-pf.sim
ssp_proxy.local-little-pf.sim: psp.exe
	${GEM5} \
		--outdir=ssp_proxy/local-little-pf \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${LOCAL_WALK_SIM} \
		--gem-forge-psp-frontend-enable \
		--gem-forge-psp-frontend-index-queue-capacity=64 \
		--gem-forge-psp-frontend-pa-queue-capacity=32 \
		--gem-forge-uve-proxy \
		--gem-forge-psp-backend-enable \
		--gem-forge-psp-backend-num-stream-entry=32 \
		--gem-forge-psp-backend-prefetch-distance=8 \
		--gem-forge-psp-queue-size=2 \
		> ssp_proxy.local-little-pf.log
#		--debug-flags=MinorCPU \
#		--debug-flags=MinorCPUDelegator \
#		--debug-flags=MinorMem \
#		--debug-flags=PSPFrontend \
#		--debug-flags=PSPBackend \

.PHONY: ssp_proxy.local-wide-pf.sim
ssp_proxy.local-wide-pf.sim: psp.exe
	${GEM5} \
		--outdir=ssp_proxy/local-wide-pf \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${LOCAL_WALK_SIM} \
		--gem-forge-psp-frontend-enable \
		--gem-forge-psp-frontend-index-queue-capacity=64 \
		--gem-forge-psp-frontend-pa-queue-capacity=32 \
		--gem-forge-uve-proxy \
		--gem-forge-psp-backend-enable \
		--gem-forge-psp-backend-num-stream-entry=32 \
		--gem-forge-psp-backend-prefetch-distance=8 \
		--gem-forge-psp-queue-size=6 \
		> ssp_proxy.local-wide-pf.log

.PHONY: stream.local-little.sim
stream.local-little.sim: stream.exe
	cp $^ ${STREAM_EXTRA}/
	${GEM5} \
		--outdir=${STREAM_OUT}/local-little \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		--debug-flags=StreamThrottle \
		${GEM5_CONFIG} \
		--cmd=${STREAM_EXTRA}/$^ \
		${LOCAL_WALK_SIM} \
		--gem-forge-stream-engine-enable \
		--gem-forge-stream-engine-total-run-ahead-bytes=65536 \
		--gem-forge-stream-engine-enable-lsq \
		--gem-forge-stream-engine-enable-coalesce \
		--gem-forge-psp-queue-size=2 \
		--gem-forge-stream-engine-throttling=global \
		> stream.local-little.log

.PHONY: stream.local-wide.sim
stream.local-wide.sim: stream.exe
	cp $^ ${STREAM_EXTRA}/
	${GEM5} \
		--outdir=${STREAM_OUT}/local-wide \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=${STREAM_EXTRA}/$^ \
		${LOCAL_WALK_SIM} \
		--gem-forge-stream-engine-enable \
		--gem-forge-stream-engine-total-run-ahead-bytes=65536 \
		--gem-forge-stream-engine-enable-lsq \
		--gem-forge-stream-engine-enable-coalesce \
		--gem-forge-psp-queue-size=6 \
		--gem-forge-stream-engine-throttling=global \
		> stream.local-wide.log
	

IOMMU_WALK_SIM=--llvm-store-queue-size=4 \
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
	--llvm-issue-width=4 \
	--gem-forge-enable-func-acc-tick \
	--prog-interval=10000 \
	--tlb-timing-se \
	--l1tlb-size=64 \
	--l1tlb-assoc=4 \
	--l2tlb-size=512 \
	--l2tlb-assoc=16 \
	--l2tlb-hit-lat=8 \
	--walker-se-lat=820 \
	--walker-se-port=4 \
	--num-cpus=${THREADS} \
	--num-dirs=4 \
	--num-l2caches=${THREADS} \
	--mesh-rows=${ROWS} \
	--ruby \
	--access-backing-store \
	--network=garnet2.0 \
	--garnet-enable-multicast \
	--router-latency=2 \
	--link-latency=1 \
	--mem-type="DDR4_2400_16x4" \
	--mem-channels=4 \
	--mem-size=16GB \
	--topology=MeshDirCorners_XY \
	--routing-YX \
	--l1i_size=32kB \
	--l1i_assoc=8 \
	--l1d_size=32kB \
	--l1d_lat=2 \
	--l1d_mshrs=8 \
	--l1d_assoc=8 \
	--l2_size=256kB \
	--l2_assoc=16 \
	--l2_lat=20 \
	--l2_mshrs=20 \
	--fast-forward=-1 \
	--options=${ARGUMENTS}

.PHONY: valid.iommu.sim
valid.iommu.sim: valid.exe
	${GEM5} \
		--outdir=${VALID_OUT}/iommu \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${IOMMU_WALK_SIM} \
		> valid.iommu.log

.PHONY: valid.iommu-stride-pf.sim
valid.iommu-stride-pf.sim: valid.exe
	${GEM5} \
		--outdir=${VALID_OUT}/iommu-stride-pf \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${IOMMU_WALK_SIM} \
		--gem-forge-prefetcher=stride \
		> valid.iommu-stride-pf.log

.PHONY: valid.iommu-bingo-pf.sim
valid.iommu-bingo-pf.sim: valid.exe
	${GEM5} \
		--outdir=${VALID_OUT}/iommu-bingo-pf \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${IOMMU_WALK_SIM} \
		--gem-forge-prefetcher=bingo \
		> valid.iommu-bingo-pf.log

.PHONY: valid.iommu-imp-pf.sim
valid.iommu-imp-pf.sim: valid.exe
	${GEM5} \
		--outdir=${VALID_OUT}/iommu-imp-pf \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${IOMMU_WALK_SIM} \
		--gem-forge-prefetch-on-access \
		--gem-forge-prefetcher=imp \
		> valid.iommu-imp-pf.log

.PHONY: psp.iommu-tlb.sim
psp.iommu-tlb.sim: psp.exe
	${GEM5} \
		--outdir=${PSP_OUT}/iommu-tlb \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${IOMMU_WALK_SIM} \
		--gem-forge-psp-frontend-enable \
		--gem-forge-psp-frontend-total-pattern-table-entries=4 \
		--gem-forge-psp-frontend-index-queue-capacity=64 \
		--gem-forge-psp-frontend-pa-queue-capacity=4 \
		--gem-forge-psp-tlb-prefetch-only \
		--gem-forge-psp-backend-enable \
		--gem-forge-psp-backend-num-stream-entry=8 \
		--gem-forge-psp-backend-prefetch-distance=8 \
		--gem-forge-psp-queue-size=2 \
		> psp.iommu-tlb.log

.PHONY: psp.iommu-pf.sim
psp.iommu-pf.sim: psp.exe
	${GEM5} \
		--outdir=${PSP_OUT}/iommu-pf \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${IOMMU_WALK_SIM} \
		--gem-forge-psp-frontend-enable \
		--gem-forge-psp-frontend-total-pattern-table-entries=4 \
		--gem-forge-psp-frontend-index-queue-capacity=64 \
		--gem-forge-psp-frontend-pa-queue-capacity=2 \
		--gem-forge-psp-data-prefetch-only \
		--gem-forge-psp-backend-enable \
		--gem-forge-psp-backend-num-stream-entry=8 \
		--gem-forge-psp-backend-prefetch-distance=8 \
		--gem-forge-psp-queue-size=2 \
		> psp.iommu-pf.log

.PHONY: psp.iommu-tlb-pf.sim
psp.iommu-tlb-pf.sim: psp.exe
	${GEM5} \
		--outdir=${PSP_OUT}/iommu-tlb-pf \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${IOMMU_WALK_SIM} \
		--gem-forge-psp-frontend-enable \
		--gem-forge-psp-frontend-total-pattern-table-entries=4 \
		--gem-forge-psp-frontend-index-queue-capacity=64 \
		--gem-forge-psp-frontend-pa-queue-capacity=4 \
		--gem-forge-psp-backend-enable \
		--gem-forge-psp-backend-num-stream-entry=8 \
		--gem-forge-psp-backend-prefetch-distance=8 \
		--gem-forge-psp-queue-size=2 \
		> psp.iommu-tlb-pf.log

.PHONY: ssp_proxy.iommu-little-pf.sim
ssp_proxy.iommu-little-pf.sim: psp.exe
	${GEM5} \
		--outdir=ssp_proxy/iommu-little-pf \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${IOMMU_WALK_SIM} \
		--gem-forge-psp-frontend-enable \
		--gem-forge-psp-frontend-index-queue-capacity=64 \
		--gem-forge-psp-frontend-pa-queue-capacity=32 \
		--gem-forge-uve-proxy \
		--gem-forge-psp-backend-enable \
		--gem-forge-psp-backend-num-stream-entry=32 \
		--gem-forge-psp-backend-prefetch-distance=8 \
		--gem-forge-psp-queue-size=2 \
		> ssp_proxy.iommu-little-pf.log

.PHONY: ssp_proxy.iommu-wide-pf.sim
ssp_proxy.iommu-wide-pf.sim: psp.exe
	${GEM5} \
		--outdir=ssp_proxy/iommu-wide-pf \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${IOMMU_WALK_SIM} \
		--gem-forge-psp-frontend-enable \
		--gem-forge-psp-frontend-index-queue-capacity=64 \
		--gem-forge-psp-frontend-pa-queue-capacity=32 \
		--gem-forge-uve-proxy \
		--gem-forge-psp-backend-enable \
		--gem-forge-psp-backend-num-stream-entry=32 \
		--gem-forge-psp-backend-prefetch-distance=8 \
		--gem-forge-psp-queue-size=6 \
		> ssp_proxy.iommu-wide-pf.log

.PHONY: stream.iommu-little.sim
stream.iommu-little.sim: stream.exe
	cp $^ ${STREAM_EXTRA}/
	${GEM5} \
		--outdir=${STREAM_OUT}/iommu-little \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=${STREAM_EXTRA}/$^ \
		${IOMMU_WALK_SIM} \
		--gem-forge-stream-engine-enable \
		--gem-forge-stream-engine-total-run-ahead-bytes=65536 \
		--gem-forge-stream-engine-enable-lsq \
		--gem-forge-stream-engine-enable-coalesce \
		--gem-forge-psp-queue-size=2 \
		--gem-forge-stream-engine-throttling=global \
		> stream.iommu-little.log

.PHONY: stream.iommu-wide.sim
stream.iommu-wide.sim: stream.exe
	cp $^ ${STREAM_EXTRA}/
	${GEM5} \
		--outdir=${STREAM_OUT}/iommu-wide \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=${STREAM_EXTRA}/$^ \
		${IOMMU_WALK_SIM} \
		--gem-forge-stream-engine-enable \
		--gem-forge-stream-engine-total-run-ahead-bytes=65536 \
		--gem-forge-stream-engine-enable-lsq \
		--gem-forge-stream-engine-enable-coalesce \
		--gem-forge-psp-queue-size=6 \
		--gem-forge-stream-engine-throttling=global \
		> stream.iommu-wide.log

.PHONY: sim-local-walk
sim-local-walk: valid.local.sim valid.local-stride-pf.sim valid.local-imp-pf.sim valid.local-bingo-pf.sim psp.local-tlb.sim psp.local-pf.sim psp.local-tlb-pf.sim stream.local-little.sim stream.local-wide.sim
#sim-local-walk: valid.local.sim valid.local-stride-pf.sim valid.local-imp-pf.sim valid.local-bingo-pf.sim psp.local-tlb.sim psp.local-pf.sim psp.local-tlb-pf.sim ssp_proxy.local-little-pf.sim ssp_proxy.local-wide-pf.sim stream.local-little.sim stream.local-wide.sim
	echo "Simulation IO core (Local Page Walk) all done!"

.PHONY: sim-iommu-walk
sim-iommu-walk: valid.iommu.sim valid.iommu-stride-pf.sim valid.iommu-imp-pf.sim valid.iommu-bingo-pf.sim psp.iommu-tlb.sim psp.iommu-pf.sim psp.iommu-tlb-pf.sim stream.iommu-little.sim stream.iommu-wide.sim
#sim-iommu-walk: valid.iommu.sim valid.iommu-stride-pf.sim valid.iommu-imp-pf.sim valid.iommu-bingo-pf.sim psp.iommu-tlb.sim psp.iommu-pf.sim psp.iommu-tlb-pf.sim ssp_proxy.iommu-little-pf.sim ssp_proxy.iommu-wide-pf.sim stream.iommu-little.sim stream.iommu-wide.sim
	echo "Simulation IO core (IOMMU Page Walk) all done!"

.PHONY: sim-all
sim-all: valid.iommu.sim valid.iommu-stride-pf.sim valid.iommu-imp-pf.sim valid.iommu-bingo-pf.sim psp.iommu-tlb.sim psp.iommu-pf.sim psp.iommu-tlb-pf.sim stream.iommu-little.sim stream.iommu-wide.sim valid.local.sim valid.local-stride-pf.sim valid.local-imp-pf.sim valid.local-bingo-pf.sim psp.local-tlb.sim psp.local-pf.sim psp.local-tlb-pf.sim stream.local-little.sim stream.local-wide.sim
#sim-all: valid.iommu.sim valid.iommu-stride-pf.sim valid.iommu-imp-pf.sim valid.iommu-bingo-pf.sim psp.iommu-tlb.sim psp.iommu-pf.sim psp.iommu-tlb-pf.sim ssp_proxy.iommu-little-pf.sim ssp_proxy.iommu-wide-pf.sim stream.iommu-little.sim stream.iommu-wide.sim valid.local.sim valid.local-stride-pf.sim valid.local-imp-pf.sim valid.local-bingo-pf.sim psp.local-tlb.sim psp.local-pf.sim psp.local-tlb-pf.sim ssp_proxy.local-little-pf.sim ssp_proxy.local-wide-pf.sim stream.local-little.sim stream.local-wide.sim
	echo "Simulation all done!"
