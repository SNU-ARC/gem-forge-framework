SRC=${GEM_FORGE_TOP}/transform/benchmark/GemForgeMicroSuite/trusted_spmm_csr/trusted_spmm_csr.c
#SRC=${GEM_FORGE_TOP}/transform/benchmark/GemForgeMicroSuite/trusted_sddmm_csr/trusted_sddmm_csr.c
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

THREADS=1
#ARGUMENTS='${THREADS} ${GEM_FORGE_TOP}/dataset/graph/harvard'
#ARGUMENTS='${THREADS} ${GEM_FORGE_TOP}/dataset/graph/youtube'
ARGUMENTS='${THREADS} ${GEM_FORGE_TOP}/dataset/graph/ogbn-mag'
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
	--llvm-issue-width=2 \
	--gem-forge-enable-func-acc-tick \
	--prog-interval=10000 \
	--tlb-timing-se \
	--l1tlb-size=64 \
	--l1tlb-assoc=4 \
	--l2tlb-size=1024 \
	--l2tlb-assoc=16 \
	--l2tlb-hit-lat=8 \
	--walker-se-lat=640 \
	--walker-se-port=2 \
	--num-cpus=${THREADS} \
	--num-dirs=4 \
	--num-l2caches=${THREADS} \
	--mesh-rows=1 \
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
	--l1d_mshrs=4 \
	--l1d_assoc=8 \
	--l2_size=256kB \
	--l2_assoc=16 \
	--l2_lat=20 \
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
		${LOCAL_WALK_SIM} > valid.local.log

.PHONY: valid.local-pf.sim
valid.local-pf.sim: valid.exe
	${GEM5} \
		--outdir=${VALID_OUT}/local-pf \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${LOCAL_WALK_SIM} \
		--gem-forge-prefetcher=stride > valid.local-pf.log

.PHONY: psp.local-tlb.sim
psp.local-tlb.sim: psp.exe
	${GEM5} \
		--outdir=${PSP_OUT}/local-tlb \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		--debug-flags=PSPFrontend \
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
		--gem-forge-prefetcher=stride > psp.local-tlb.log

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
		--gem-forge-psp-tlb-prefetch-only \
		--gem-forge-psp-data-prefetch-only \
		--gem-forge-psp-backend-enable \
		--gem-forge-psp-backend-num-stream-entry=8 \
		--gem-forge-psp-backend-prefetch-distance=8 \
		--gem-forge-prefetcher=stride > psp.local-pf.log

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
		--gem-forge-prefetcher=stride > psp.local-tlb-pf.log

.PHONY: uve_proxy.local-pf8.sim
uve_proxy.local-pf8.sim: psp.exe
	${GEM5} \
		--outdir=uve_proxy/local-pf8 \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${LOCAL_WALK_SIM} \
		--gem-forge-psp-frontend-enable \
		--gem-forge-psp-frontend-index-queue-capacity=64 \
		--gem-forge-psp-frontend-pa-queue-capacity=8 \
		--gem-forge-uve-proxy \
		--gem-forge-psp-backend-enable \
		--gem-forge-psp-backend-num-stream-entry=8 \
		--gem-forge-psp-backend-prefetch-distance=8 \
		--gem-forge-prefetcher=stride > uve_proxy.local-pf8.log

.PHONY: uve_proxy.local-pf16.sim
uve_proxy.local-pf16.sim: psp.exe
	${GEM5} \
		--outdir=uve_proxy/local-pf16 \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${LOCAL_WALK_SIM} \
		--gem-forge-psp-frontend-enable \
		--gem-forge-psp-frontend-index-queue-capacity=64 \
		--gem-forge-psp-frontend-pa-queue-capacity=16 \
		--gem-forge-uve-proxy \
		--gem-forge-psp-backend-enable \
		--gem-forge-psp-backend-num-stream-entry=16 \
		--gem-forge-psp-backend-prefetch-distance=16 \
		--gem-forge-prefetcher=stride > uve_proxy.local-pf16.log

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
	--llvm-issue-width=2 \
	--gem-forge-enable-func-acc-tick \
	--prog-interval=10000 \
	--tlb-timing-se \
	--l1tlb-size=64 \
	--l1tlb-assoc=4 \
	--l2tlb-size=1024 \
	--l2tlb-assoc=16 \
	--l2tlb-hit-lat=8 \
	--walker-se-lat=820 \
	--walker-se-port=2 \
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
	--mem-size=16GB \
	--topology=MeshDirCorners_XY \
	--routing-YX \
	--l1i_size=32kB \
	--l1i_assoc=8 \
	--l1d_size=32kB \
	--l1d_lat=2 \
	--l1d_mshrs=4 \
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
		${IOMMU_WALK_SIM} > valid.iommu.log

.PHONY: valid.iommu-pf.sim
valid.iommu-pf.sim: valid.exe
	${GEM5} \
		--outdir=${VALID_OUT}/iommu-pf \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${IOMMU_WALK_SIM} \
		--gem-forge-prefetcher=stride > valid.iommu-pf.log

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
		--gem-forge-prefetcher=stride > psp.iommu-tlb.log

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
		--gem-forge-psp-frontend-pa-queue-capacity=4 \
		--gem-forge-psp-tlb-prefetch-only \
		--gem-forge-psp-data-prefetch-only \
		--gem-forge-psp-backend-enable \
		--gem-forge-psp-backend-num-stream-entry=8 \
		--gem-forge-psp-backend-prefetch-distance=8 \
		--gem-forge-prefetcher=stride > psp.iommu-pf.log

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
		--gem-forge-prefetcher=stride > psp.iommu-tlb-pf.log

.PHONY: uve_proxy.iommu-pf8.sim
uve_proxy.iommu-pf8.sim: psp.exe
	${GEM5} \
		--outdir=uve_proxy/iommu-pf8 \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${IOMMU_WALK_SIM} \
		--gem-forge-psp-frontend-enable \
		--gem-forge-psp-frontend-index-queue-capacity=64 \
		--gem-forge-psp-frontend-pa-queue-capacity=8 \
		--gem-forge-psp-tlb-prefetch-only \
		--gem-forge-psp-data-prefetch-only \
		--gem-forge-psp-backend-enable \
		--gem-forge-psp-backend-num-stream-entry=8 \
		--gem-forge-psp-backend-prefetch-distance=8 \
		--gem-forge-prefetcher=stride > uve_proxy.iommu-pf8.log

.PHONY: uve_proxy.iommu-pf16.sim
uve_proxy.iommu-pf16.sim: psp.exe
	${GEM5} \
		--outdir=uve_proxy/iommu-pf16 \
		--stats-file=text://stats.txt?dumpAll=False \
		--listener-mode=off \
		${GEM5_CONFIG} \
		--cmd=$^ \
		${IOMMU_WALK_SIM} \
		--gem-forge-psp-frontend-enable \
		--gem-forge-psp-frontend-index-queue-capacity=64 \
		--gem-forge-psp-frontend-pa-queue-capacity=16 \
		--gem-forge-psp-tlb-prefetch-only \
		--gem-forge-psp-data-prefetch-only \
		--gem-forge-psp-backend-enable \
		--gem-forge-psp-backend-num-stream-entry=16 \
		--gem-forge-psp-backend-prefetch-distance=16 \
		--gem-forge-prefetcher=stride > uve_proxy.iommu-pf16.log

.PHONY: sim-local-walk
sim-local-walk: valid.local.sim valid.local-pf.sim psp.local-tlb.sim psp.local-pf.sim psp.local-tlb-pf.sim uve_proxy.local-pf8.sim uve_proxy.local-pf16.sim
	echo "Simulation IO core (Local Page Walk) all done!"

.PHONY: sim-iommu-walk
sim-iommu-walk: valid.iommu.sim valid.iommu-pf.sim psp.iommu-tlb.sim psp.iommu-pf.sim psp.iommu-tlb-pf.sim uve_proxy.iommu-pf8.sim uve_proxy.iommu-pf16.sim
	echo "Simulation IO core (IOMMU Page Walk) all done!"

.PHONY: sim-all
sim-all: valid.iommu.sim valid.iommu-pf.sim psp.iommu-tlb.sim psp.iommu-pf.sim psp.iommu-tlb-pf.sim uve_proxy.iommu-pf8.sim uve_proxy.iommu-pf16.sim valid.local.sim valid.local-pf.sim psp.local-tlb.sim psp.local-pf.sim psp.local-tlb-pf.sim uve_proxy.local-pf8.sim uve_proxy.local-pf16.sim
	echo "Simulation all done!"
