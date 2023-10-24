; ModuleID = 'stream/extra/ex.bc'
source_filename = "/home2/youngook/research/01_NDP/01_ISCA_23/gem-forge-framework/transform/benchmark/GemForgeMicroSuite/trusted_gcn_csr/trusted_gcn_csr.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: nofree noinline norecurse nounwind uwtable
define dso_local float @truested_gcn_csr(i64 %arg, i64 %arg1, i64* nocapture readonly %arg2, i64* nocapture readonly %arg3, i64* nocapture readonly %arg4, float* nocapture readonly %arg5, i64 %arg6, float* nocapture %arg7, i64 %arg8) local_unnamed_addr #0 !dbg !7 {
bb:
  %i = icmp eq i64 %arg, 0, !dbg !10
  %i9 = icmp eq i64 %arg1, 0
  %i10 = or i1 %i, %i9, !dbg !11
  br i1 %i10, label %bb122, label %bb11, !dbg !11

bb11:                                             ; preds = %bb
  %i12 = getelementptr float, float* %arg5, i64 %arg1, !dbg !11
  %i13 = icmp ult i64 %arg1, 64, !dbg !12
  %i14 = and i64 %arg1, -64, !dbg !12
  %i15 = icmp eq i64 %i14, %arg1, !dbg !12
  %i16 = and i64 %arg1, 1, !dbg !12
  %i17 = icmp eq i64 %i16, 0, !dbg !12
  %i18 = sub i64 0, %arg1, !dbg !12
  call void @llvm.ssp.stream.config(i64 0), !dbg !11
  call void @llvm.ssp.stream.input.i64(i64 3, i64 %arg), !dbg !11
  call void @llvm.ssp.stream.input.i64(i64 4, i64 %arg), !dbg !11
  call void @llvm.ssp.stream.input.p0i64(i64 4, i64* %arg3), !dbg !11
  call void @llvm.ssp.stream.input.i64(i64 5, i64 %arg), !dbg !11
  call void @llvm.ssp.stream.input.p0i64(i64 5, i64* %arg4), !dbg !11
  call void @llvm.ssp.stream.ready(), !dbg !11
  %0 = add i64 %i14, -64, !dbg !11
  %1 = lshr i64 %0, 6, !dbg !11
  %2 = add nuw nsw i64 %1, 1, !dbg !11
  br label %bb19, !dbg !11

bb19:                                             ; preds = %bb30, %bb11
  %i20 = phi i64 [ %i31, %bb30 ], [ 0, %bb11 ]
  %3 = mul i64 %arg8, %i20, !dbg !13
  %scevgep1 = getelementptr float, float* %arg7, i64 %3, !dbg !13
  %4 = add i64 %3, 16, !dbg !13
  %scevgep2 = getelementptr float, float* %arg7, i64 %4, !dbg !13
  %5 = add i64 %3, 32, !dbg !13
  %scevgep3 = getelementptr float, float* %arg7, i64 %5, !dbg !13
  %6 = add i64 %3, 48, !dbg !13
  %scevgep4 = getelementptr float, float* %arg7, i64 %6, !dbg !13
  %i21 = mul i64 %i20, %arg8, !dbg !13
  %i22 = getelementptr float, float* %arg7, i64 %i21, !dbg !13
  %i23 = add i64 %i21, %arg1, !dbg !13
  %i24 = getelementptr float, float* %arg7, i64 %i23, !dbg !13
  %7 = call i64 @llvm.ssp.stream.load.i64(i64 4), !dbg !13
  %8 = call i64 @llvm.ssp.stream.load.i64(i64 5), !dbg !14
  %i29 = icmp ult i64 %7, %8, !dbg !15
  br i1 %i29, label %bb33, label %bb30, !dbg !16

bb30.loopexit:                                    ; preds = %bb100
  call void @llvm.ssp.stream.end(i64 1), !dbg !17
  br label %bb30, !dbg !17

bb30:                                             ; preds = %bb30.loopexit, %bb19
  %i31 = add nuw i64 %i20, 1, !dbg !17
  %i32 = icmp eq i64 %i31, %arg, !dbg !10
  call void @llvm.ssp.stream.step(i64 3), !dbg !11
  br i1 %i32, label %bb122.loopexit, label %bb19, !dbg !11, !llvm.loop !18

bb33:                                             ; preds = %bb19
  %i34 = mul i64 %i20, %arg8, !dbg !12
  call void @llvm.ssp.stream.config(i64 1), !dbg !16
  %9 = sub i64 %8, %7, !dbg !16
  call void @llvm.ssp.stream.input.i64(i64 6, i64 %9), !dbg !16
  call void @llvm.ssp.stream.input.i64(i64 6, i64 %7), !dbg !16
  call void @llvm.ssp.stream.input.i64(i64 7, i64 %2), !dbg !16
  call void @llvm.ssp.stream.input.i64(i64 7, i64 %9), !dbg !16
  %scevgep = getelementptr i64, i64* %arg2, i64 %7, !dbg !16
  call void @llvm.ssp.stream.input.i64(i64 8, i64 %9), !dbg !16
  call void @llvm.ssp.stream.input.p0i64(i64 8, i64* %scevgep), !dbg !16
  call void @llvm.ssp.stream.input.i64(i64 9, i64 %2), !dbg !16
  call void @llvm.ssp.stream.input.i64(i64 9, i64 %9), !dbg !16
  call void @llvm.ssp.stream.input.p0f32(i64 9, float* %scevgep1), !dbg !16
  call void @llvm.ssp.stream.input.i64(i64 10, i64 %2), !dbg !16
  call void @llvm.ssp.stream.input.i64(i64 10, i64 %9), !dbg !16
  call void @llvm.ssp.stream.input.p0f32(i64 10, float* %scevgep2), !dbg !16
  call void @llvm.ssp.stream.input.i64(i64 11, i64 %2), !dbg !16
  call void @llvm.ssp.stream.input.i64(i64 11, i64 %9), !dbg !16
  call void @llvm.ssp.stream.input.p0f32(i64 11, float* %scevgep3), !dbg !16
  call void @llvm.ssp.stream.input.i64(i64 12, i64 %2), !dbg !16
  call void @llvm.ssp.stream.input.i64(i64 12, i64 %9), !dbg !16
  call void @llvm.ssp.stream.input.p0f32(i64 12, float* %scevgep4), !dbg !16
  call void @llvm.ssp.stream.input.i64(i64 13, i64 %2), !dbg !16
  call void @llvm.ssp.stream.input.i64(i64 13, i64 %9), !dbg !16
  call void @llvm.ssp.stream.input.p0f32(i64 13, float* %scevgep1), !dbg !16
  call void @llvm.ssp.stream.input.i64(i64 14, i64 %2), !dbg !16
  call void @llvm.ssp.stream.input.i64(i64 14, i64 %9), !dbg !16
  call void @llvm.ssp.stream.input.p0f32(i64 14, float* %scevgep2), !dbg !16
  call void @llvm.ssp.stream.input.i64(i64 15, i64 %2), !dbg !16
  call void @llvm.ssp.stream.input.i64(i64 15, i64 %9), !dbg !16
  call void @llvm.ssp.stream.input.p0f32(i64 15, float* %scevgep3), !dbg !16
  call void @llvm.ssp.stream.input.i64(i64 16, i64 %2), !dbg !16
  call void @llvm.ssp.stream.input.i64(i64 16, i64 %9), !dbg !16
  call void @llvm.ssp.stream.input.p0f32(i64 16, float* %scevgep4), !dbg !16
  call void @llvm.ssp.stream.input.i64(i64 17, i64 %arg6), !dbg !16
  call void @llvm.ssp.stream.input.p0f32(i64 17, float* %arg5), !dbg !16
  call void @llvm.ssp.stream.input.i64(i64 18, i64 %arg6), !dbg !16
  call void @llvm.ssp.stream.input.p0f32(i64 18, float* %arg5), !dbg !16
  call void @llvm.ssp.stream.input.i64(i64 19, i64 %arg6), !dbg !16
  call void @llvm.ssp.stream.input.p0f32(i64 19, float* %arg5), !dbg !16
  call void @llvm.ssp.stream.input.i64(i64 20, i64 %arg6), !dbg !16
  call void @llvm.ssp.stream.input.p0f32(i64 20, float* %arg5), !dbg !16
  call void @llvm.ssp.stream.ready(), !dbg !16
  br label %bb35, !dbg !16

bb35:                                             ; preds = %bb100, %bb33
  %i36 = phi i64 [ %7, %bb33 ], [ %i101, %bb100 ]
  %10 = call i64 @llvm.ssp.stream.load.i64(i64 8), !dbg !12
  %i39 = mul i64 %10, %arg6, !dbg !12
  br i1 %i13, label %bb40, label %bb55, !dbg !20

bb40:                                             ; preds = %bb99, %bb55, %bb35
  %i41 = phi i64 [ 0, %bb55 ], [ 0, %bb35 ], [ %i14, %bb99 ]
  %i42 = xor i64 %i41, -1, !dbg !20
  br i1 %i17, label %bb52, label %bb43, !dbg !20

bb43:                                             ; preds = %bb40
  %i44 = add i64 %i39, %i41, !dbg !21
  %i45 = getelementptr inbounds float, float* %arg5, i64 %i44, !dbg !22
  %i46 = load float, float* %i45, align 4, !dbg !22, !tbaa !23
  %i47 = add i64 %i41, %i34, !dbg !27
  %i48 = getelementptr inbounds float, float* %arg7, i64 %i47, !dbg !28
  %i49 = load float, float* %i48, align 4, !dbg !29, !tbaa !23
  %i50 = fadd float %i46, %i49, !dbg !29
  store float %i50, float* %i48, align 4, !dbg !29, !tbaa !23
  %i51 = or i64 %i41, 1, !dbg !30
  br label %bb52, !dbg !20

bb52:                                             ; preds = %bb43, %bb40
  %i53 = phi i64 [ %i51, %bb43 ], [ %i41, %bb40 ]
  %i54 = icmp eq i64 %i42, %i18, !dbg !20
  br i1 %i54, label %bb100, label %bb103, !dbg !20

bb55:                                             ; preds = %bb35
  %i56 = getelementptr float, float* %arg5, i64 %i39, !dbg !20
  %i57 = getelementptr float, float* %i12, i64 %i39, !dbg !20
  %i58 = icmp ult float* %i22, %i57, !dbg !20
  %i59 = icmp ult float* %i56, %i24, !dbg !20
  %i60 = and i1 %i58, %i59, !dbg !20
  br i1 %i60, label %bb40, label %bb61, !dbg !20

bb61:                                             ; preds = %bb61, %bb55
  %i62 = phi i64 [ %i97, %bb61 ], [ 0, %bb55 ], !dbg !30
  %11 = call <8 x double> @llvm.ssp.stream.load.v8f64(i64 17), !dbg !22
  %ssp.load.bitcast.i66 = bitcast <8 x double> %11 to <16 x float>, !dbg !22
  %12 = call <8 x double> @llvm.ssp.stream.load.v8f64(i64 18), !dbg !22
  %ssp.load.bitcast.i69 = bitcast <8 x double> %12 to <16 x float>, !dbg !22
  %13 = call <8 x double> @llvm.ssp.stream.load.v8f64(i64 19), !dbg !22
  %ssp.load.bitcast.i72 = bitcast <8 x double> %13 to <16 x float>, !dbg !22
  %14 = call <8 x double> @llvm.ssp.stream.load.v8f64(i64 20), !dbg !22
  %ssp.load.bitcast.i75 = bitcast <8 x double> %14 to <16 x float>, !dbg !22
  %i76 = add i64 %i62, %i34, !dbg !27
  %i77 = getelementptr inbounds float, float* %arg7, i64 %i76, !dbg !28
  %15 = call <8 x double> @llvm.ssp.stream.load.v8f64(i64 9), !dbg !29
  %ssp.load.bitcast.i79 = bitcast <8 x double> %15 to <16 x float>, !dbg !29
  %i80 = getelementptr inbounds float, float* %i77, i64 16, !dbg !29
  %16 = call <8 x double> @llvm.ssp.stream.load.v8f64(i64 10), !dbg !29
  %ssp.load.bitcast.i82 = bitcast <8 x double> %16 to <16 x float>, !dbg !29
  %i83 = getelementptr inbounds float, float* %i77, i64 32, !dbg !29
  %17 = call <8 x double> @llvm.ssp.stream.load.v8f64(i64 11), !dbg !29
  %ssp.load.bitcast.i85 = bitcast <8 x double> %17 to <16 x float>, !dbg !29
  %i86 = getelementptr inbounds float, float* %i77, i64 48, !dbg !29
  %18 = call <8 x double> @llvm.ssp.stream.load.v8f64(i64 12), !dbg !29
  %ssp.load.bitcast.i88 = bitcast <8 x double> %18 to <16 x float>, !dbg !29
  %i89 = fadd <16 x float> %ssp.load.bitcast.i66, %ssp.load.bitcast.i79, !dbg !29
  %i90 = fadd <16 x float> %ssp.load.bitcast.i69, %ssp.load.bitcast.i82, !dbg !29
  %i91 = fadd <16 x float> %ssp.load.bitcast.i72, %ssp.load.bitcast.i85, !dbg !29
  %i92 = fadd <16 x float> %ssp.load.bitcast.i75, %ssp.load.bitcast.i88, !dbg !29
  %i93 = bitcast float* %i77 to <16 x float>*, !dbg !29
  store <16 x float> %i89, <16 x float>* %i93, align 4, !dbg !29, !tbaa !23, !alias.scope !31, !noalias !34
  %i94 = bitcast float* %i80 to <16 x float>*, !dbg !29
  store <16 x float> %i90, <16 x float>* %i94, align 4, !dbg !29, !tbaa !23, !alias.scope !31, !noalias !34
  %i95 = bitcast float* %i83 to <16 x float>*, !dbg !29
  store <16 x float> %i91, <16 x float>* %i95, align 4, !dbg !29, !tbaa !23, !alias.scope !31, !noalias !34
  %i96 = bitcast float* %i86 to <16 x float>*, !dbg !29
  store <16 x float> %i92, <16 x float>* %i96, align 4, !dbg !29, !tbaa !23, !alias.scope !31, !noalias !34
  %i97 = add nuw nsw i64 %i62, 64, !dbg !30
  %i98 = icmp eq i64 %i97, %i14, !dbg !30
  call void @llvm.ssp.stream.step(i64 7), !dbg !30
  br i1 %i98, label %bb99, label %bb61, !dbg !30, !llvm.loop !36

bb99:                                             ; preds = %bb61
  br i1 %i15, label %bb100, label %bb40, !dbg !20

bb100:                                            ; preds = %bb103, %bb99, %bb52
  %i101 = add nuw i64 %i36, 1, !dbg !39
  %i102 = icmp ult i64 %i101, %8, !dbg !15
  call void @llvm.ssp.stream.step(i64 6), !dbg !16
  br i1 %i102, label %bb35, label %bb30.loopexit, !dbg !16, !llvm.loop !40

bb103:                                            ; preds = %bb103, %bb52
  %i104 = phi i64 [ %i120, %bb103 ], [ %i53, %bb52 ]
  %i105 = add i64 %i39, %i104, !dbg !21
  %i106 = getelementptr inbounds float, float* %arg5, i64 %i105, !dbg !22
  %i107 = load float, float* %i106, align 4, !dbg !22, !tbaa !23
  %i108 = add i64 %i104, %i34, !dbg !27
  %i109 = getelementptr inbounds float, float* %arg7, i64 %i108, !dbg !28
  %i110 = load float, float* %i109, align 4, !dbg !29, !tbaa !23
  %i111 = fadd float %i107, %i110, !dbg !29
  store float %i111, float* %i109, align 4, !dbg !29, !tbaa !23
  %i112 = add nuw i64 %i104, 1, !dbg !30
  %i113 = add i64 %i39, %i112, !dbg !21
  %i114 = getelementptr inbounds float, float* %arg5, i64 %i113, !dbg !22
  %i115 = load float, float* %i114, align 4, !dbg !22, !tbaa !23
  %i116 = add i64 %i112, %i34, !dbg !27
  %i117 = getelementptr inbounds float, float* %arg7, i64 %i116, !dbg !28
  %i118 = load float, float* %i117, align 4, !dbg !29, !tbaa !23
  %i119 = fadd float %i115, %i118, !dbg !29
  store float %i119, float* %i117, align 4, !dbg !29, !tbaa !23
  %i120 = add nuw i64 %i104, 2, !dbg !30
  %i121 = icmp eq i64 %i120, %arg1, !dbg !42
  br i1 %i121, label %bb100, label %bb103, !dbg !20, !llvm.loop !43

bb122.loopexit:                                   ; preds = %bb30
  call void @llvm.ssp.stream.end(i64 0), !dbg !45
  br label %bb122, !dbg !45

bb122:                                            ; preds = %bb122.loopexit, %bb
  ret float 0.000000e+00, !dbg !45
}

; Function Attrs: nounwind willreturn
declare i64 @llvm.ssp.stream.load.i64(i64) #1

; Function Attrs: nounwind willreturn
declare <8 x double> @llvm.ssp.stream.load.v8f64(i64) #1

; Function Attrs: nounwind willreturn
declare void @llvm.ssp.stream.step(i64) #1

; Function Attrs: nounwind willreturn
declare void @llvm.ssp.stream.config(i64) #1

; Function Attrs: nounwind willreturn
declare void @llvm.ssp.stream.input.i64(i64, i64) #1

; Function Attrs: nounwind willreturn
declare void @llvm.ssp.stream.input.p0i64(i64, i64*) #1

; Function Attrs: nounwind willreturn
declare void @llvm.ssp.stream.ready() #1

; Function Attrs: nounwind willreturn
declare void @llvm.ssp.stream.end(i64) #1

; Function Attrs: nounwind willreturn
declare void @llvm.ssp.stream.input.p0f32(i64, float*) #1

attributes #0 = { nofree noinline norecurse nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+avx,+avx2,+avx512f,+cx8,+f16c,+fma,+fxsr,+mmx,+popcnt,+sse,+sse2,+sse3,+sse4.1,+sse4.2,+ssse3,+x87,+xsave" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind willreturn }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}
!nvvm.annotations = !{}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 12.0.0 (https://github.com/SNU-ARC/gem-forge-llvm d6435b9f0e86f1259509ff1fa4f91f920ed1389e)", isOptimized: true, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home2/youngook/research/01_NDP/01_ISCA_23/gem-forge-framework/transform/benchmark/GemForgeMicroSuite/trusted_gcn_csr/trusted_gcn_csr.c", directory: "/home2/youngook/research/01_NDP/01_ISCA_23/gem-forge-framework/example_gcn")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"clang version 12.0.0 (https://github.com/SNU-ARC/gem-forge-llvm d6435b9f0e86f1259509ff1fa4f91f920ed1389e)"}
!7 = distinct !DISubprogram(name: "truested_gcn_csr", scope: !8, file: !8, line: 75, type: !9, scopeLine: 97, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!8 = !DIFile(filename: "transform/benchmark/GemForgeMicroSuite/trusted_gcn_csr/trusted_gcn_csr.c", directory: "/home2/youngook/research/01_NDP/01_ISCA_23/gem-forge-framework")
!9 = !DISubroutineType(types: !2)
!10 = !DILocation(line: 102, column: 28, scope: !7)
!11 = !DILocation(line: 102, column: 4, scope: !7)
!12 = !DILocation(line: 0, scope: !7)
!13 = !DILocation(line: 104, column: 24, scope: !7)
!14 = !DILocation(line: 104, column: 38, scope: !7)
!15 = !DILocation(line: 104, column: 36, scope: !7)
!16 = !DILocation(line: 104, column: 7, scope: !7)
!17 = !DILocation(line: 102, column: 34, scope: !7)
!18 = distinct !{!18, !11, !19}
!19 = !DILocation(line: 109, column: 4, scope: !7)
!20 = !DILocation(line: 106, column: 10, scope: !7)
!21 = !DILocation(line: 107, column: 41, scope: !7)
!22 = !DILocation(line: 107, column: 28, scope: !7)
!23 = !{!24, !24, i64 0}
!24 = !{!"float", !25, i64 0}
!25 = !{!"omnipotent char", !26, i64 0}
!26 = !{!"Simple C/C++ TBAA"}
!27 = !DILocation(line: 107, column: 20, scope: !7)
!28 = !DILocation(line: 107, column: 13, scope: !7)
!29 = !DILocation(line: 107, column: 25, scope: !7)
!30 = !DILocation(line: 106, column: 41, scope: !7)
!31 = !{!32}
!32 = distinct !{!32, !33}
!33 = distinct !{!33, !"LVerDomain"}
!34 = !{!35}
!35 = distinct !{!35, !33}
!36 = distinct !{!36, !20, !37, !38}
!37 = !DILocation(line: 107, column: 44, scope: !7)
!38 = !{!"llvm.loop.isvectorized", i32 1}
!39 = !DILocation(line: 104, column: 49, scope: !7)
!40 = distinct !{!40, !16, !41}
!41 = !DILocation(line: 108, column: 7, scope: !7)
!42 = !DILocation(line: 106, column: 34, scope: !7)
!43 = distinct !{!43, !20, !37, !38, !44}
!44 = !{!"llvm.loop.vectorize_is_epilogue", i32 0}
!45 = !DILocation(line: 111, column: 4, scope: !7)
