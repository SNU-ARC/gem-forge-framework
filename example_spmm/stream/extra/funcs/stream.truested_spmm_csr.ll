; ModuleID = 'stream/extra/ex.bc'
source_filename = "/home2/youngook/research/01_NDP/01_ISCA_23/gem-forge-framework/transform/benchmark/GemForgeMicroSuite/trusted_spmm_csr/trusted_spmm_csr.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = external hidden unnamed_addr constant [9 x i8], align 1

; Function Attrs: nofree noinline nounwind uwtable
define dso_local void @truested_spmm_csr(i64 %arg, i64 %arg1, float* nocapture readonly %arg2, i64* nocapture readonly %arg3, i64* nocapture readonly %arg4, i64* nocapture readonly %arg5, float* nocapture readonly %arg6, i64 %arg7, float* nocapture %arg8, i64 %arg9) local_unnamed_addr #0 !dbg !7 {
bb:
  %i = icmp eq i64 %arg, 0, !dbg !10
  br i1 %i, label %bb157, label %bb10, !dbg !11

bb10:                                             ; preds = %bb
  %i11 = icmp eq i64 %arg1, 0, !dbg !12
  br i1 %i11, label %bb158, label %bb12, !dbg !11

bb12:                                             ; preds = %bb10
  %i13 = getelementptr float, float* %arg6, i64 %arg1, !dbg !11
  %i14 = icmp ult i64 %arg1, 64, !dbg !12
  %i15 = and i64 %arg1, -64, !dbg !12
  %i16 = icmp eq i64 %i15, %arg1, !dbg !12
  %i17 = and i64 %arg1, 1, !dbg !12
  %i18 = icmp eq i64 %i17, 0, !dbg !12
  %i19 = sub i64 0, %arg1, !dbg !12
  call void @llvm.ssp.stream.config(i64 0), !dbg !11
  call void @llvm.ssp.stream.input.i64(i64 3, i64 %arg), !dbg !11
  call void @llvm.ssp.stream.input.i64(i64 4, i64 %arg), !dbg !11
  call void @llvm.ssp.stream.input.p0i64(i64 4, i64* %arg4), !dbg !11
  call void @llvm.ssp.stream.input.i64(i64 5, i64 %arg), !dbg !11
  call void @llvm.ssp.stream.input.p0i64(i64 5, i64* %arg5), !dbg !11
  call void @llvm.ssp.stream.ready(), !dbg !11
  %0 = add i64 %i15, -64, !dbg !11
  %1 = lshr i64 %0, 6, !dbg !11
  %2 = add nuw nsw i64 %1, 1, !dbg !11
  br label %bb20, !dbg !11

bb20:                                             ; preds = %bb33, %bb12
  %i21 = phi i64 [ %i34, %bb33 ], [ 0, %bb12 ]
  %3 = mul i64 %arg9, %i21, !dbg !13
  %scevgep2 = getelementptr float, float* %arg8, i64 %3, !dbg !13
  %4 = add i64 %3, 16, !dbg !13
  %scevgep3 = getelementptr float, float* %arg8, i64 %4, !dbg !13
  %5 = add i64 %3, 32, !dbg !13
  %scevgep4 = getelementptr float, float* %arg8, i64 %5, !dbg !13
  %6 = add i64 %3, 48, !dbg !13
  %scevgep5 = getelementptr float, float* %arg8, i64 %6, !dbg !13
  %i22 = mul i64 %i21, %arg9, !dbg !13
  %i23 = getelementptr float, float* %arg8, i64 %i22, !dbg !13
  %i24 = bitcast float* %i23 to i8*
  %i25 = add i64 %i22, %arg1, !dbg !13
  %i26 = getelementptr float, float* %arg8, i64 %i25, !dbg !13
  %i27 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([9 x i8], [9 x i8]* @.str, i64 0, i64 0), i64 %i21), !dbg !13
  %7 = call i64 @llvm.ssp.stream.load.i64(i64 4), !dbg !14
  %8 = call i64 @llvm.ssp.stream.load.i64(i64 5), !dbg !15
  %i32 = icmp ult i64 %7, %8, !dbg !16
  br i1 %i32, label %bb36, label %bb33, !dbg !17

bb33.loopexit:                                    ; preds = %bb130
  call void @llvm.ssp.stream.end(i64 1), !dbg !18
  br label %bb33, !dbg !18

bb33:                                             ; preds = %bb33.loopexit, %bb20
  %i34 = add nuw i64 %i21, 1, !dbg !18
  %i35 = icmp eq i64 %i34, %arg, !dbg !10
  call void @llvm.ssp.stream.step(i64 3), !dbg !11
  br i1 %i35, label %bb157.loopexit, label %bb20, !dbg !11, !llvm.loop !19

bb36:                                             ; preds = %bb20
  %i37 = mul i64 %i21, %arg9, !dbg !12
  call void @llvm.ssp.stream.config(i64 1), !dbg !17
  %9 = sub i64 %8, %7, !dbg !17
  call void @llvm.ssp.stream.input.i64(i64 6, i64 %9), !dbg !17
  call void @llvm.ssp.stream.input.i64(i64 6, i64 %7), !dbg !17
  call void @llvm.ssp.stream.input.i64(i64 7, i64 %2), !dbg !17
  call void @llvm.ssp.stream.input.i64(i64 7, i64 %9), !dbg !17
  %scevgep = getelementptr i64, i64* %arg3, i64 %7, !dbg !17
  call void @llvm.ssp.stream.input.i64(i64 8, i64 %9), !dbg !17
  call void @llvm.ssp.stream.input.p0i64(i64 8, i64* %scevgep), !dbg !17
  %scevgep1 = getelementptr float, float* %arg2, i64 %7, !dbg !17
  call void @llvm.ssp.stream.input.i64(i64 9, i64 %9), !dbg !17
  call void @llvm.ssp.stream.input.p0f32(i64 9, float* %scevgep1), !dbg !17
  call void @llvm.ssp.stream.input.i64(i64 10, i64 %9), !dbg !17
  call void @llvm.ssp.stream.input.p0f32(i64 10, float* %scevgep1), !dbg !17
  call void @llvm.ssp.stream.input.i64(i64 11, i64 %2), !dbg !17
  call void @llvm.ssp.stream.input.i64(i64 11, i64 %9), !dbg !17
  call void @llvm.ssp.stream.input.p0f32(i64 11, float* %scevgep2), !dbg !17
  call void @llvm.ssp.stream.input.i64(i64 12, i64 %2), !dbg !17
  call void @llvm.ssp.stream.input.i64(i64 12, i64 %9), !dbg !17
  call void @llvm.ssp.stream.input.p0f32(i64 12, float* %scevgep3), !dbg !17
  call void @llvm.ssp.stream.input.i64(i64 13, i64 %2), !dbg !17
  call void @llvm.ssp.stream.input.i64(i64 13, i64 %9), !dbg !17
  call void @llvm.ssp.stream.input.p0f32(i64 13, float* %scevgep4), !dbg !17
  call void @llvm.ssp.stream.input.i64(i64 14, i64 %2), !dbg !17
  call void @llvm.ssp.stream.input.i64(i64 14, i64 %9), !dbg !17
  call void @llvm.ssp.stream.input.p0f32(i64 14, float* %scevgep5), !dbg !17
  call void @llvm.ssp.stream.input.i64(i64 15, i64 %2), !dbg !17
  call void @llvm.ssp.stream.input.i64(i64 15, i64 %9), !dbg !17
  call void @llvm.ssp.stream.input.p0f32(i64 15, float* %scevgep2), !dbg !17
  call void @llvm.ssp.stream.input.i64(i64 16, i64 %2), !dbg !17
  call void @llvm.ssp.stream.input.i64(i64 16, i64 %9), !dbg !17
  call void @llvm.ssp.stream.input.p0f32(i64 16, float* %scevgep3), !dbg !17
  call void @llvm.ssp.stream.input.i64(i64 17, i64 %2), !dbg !17
  call void @llvm.ssp.stream.input.i64(i64 17, i64 %9), !dbg !17
  call void @llvm.ssp.stream.input.p0f32(i64 17, float* %scevgep4), !dbg !17
  call void @llvm.ssp.stream.input.i64(i64 18, i64 %2), !dbg !17
  call void @llvm.ssp.stream.input.i64(i64 18, i64 %9), !dbg !17
  call void @llvm.ssp.stream.input.p0f32(i64 18, float* %scevgep5), !dbg !17
  call void @llvm.ssp.stream.input.i64(i64 19, i64 %9), !dbg !17
  call void @llvm.ssp.stream.input.p0f32(i64 19, float* %scevgep1), !dbg !17
  call void @llvm.ssp.stream.input.i64(i64 20, i64 %arg7), !dbg !17
  call void @llvm.ssp.stream.input.p0f32(i64 20, float* %arg6), !dbg !17
  call void @llvm.ssp.stream.input.i64(i64 21, i64 %arg7), !dbg !17
  call void @llvm.ssp.stream.input.p0f32(i64 21, float* %arg6), !dbg !17
  call void @llvm.ssp.stream.input.i64(i64 22, i64 %arg7), !dbg !17
  call void @llvm.ssp.stream.input.p0f32(i64 22, float* %arg6), !dbg !17
  call void @llvm.ssp.stream.input.i64(i64 23, i64 %arg7), !dbg !17
  call void @llvm.ssp.stream.input.p0f32(i64 23, float* %arg6), !dbg !17
  call void @llvm.ssp.stream.ready(), !dbg !17
  br label %bb38, !dbg !17

bb38:                                             ; preds = %bb130, %bb36
  %i39 = phi i64 [ 0, %bb36 ], [ %i133, %bb130 ]
  %i40 = phi i64 [ %7, %bb36 ], [ %i131, %bb130 ]
  %i41 = getelementptr inbounds float, float* %arg2, i64 %i40, !dbg !12
  %10 = call i64 @llvm.ssp.stream.load.i64(i64 8), !dbg !12
  %i44 = mul i64 %10, %arg7, !dbg !12
  br i1 %i14, label %bb45, label %bb62, !dbg !21

bb45:                                             ; preds = %bb129, %bb62, %bb38
  %i46 = phi i64 [ 0, %bb62 ], [ 0, %bb38 ], [ %i15, %bb129 ]
  %i47 = xor i64 %i46, -1, !dbg !21
  br i1 %i18, label %bb59, label %bb48, !dbg !21

bb48:                                             ; preds = %bb45
  %11 = call float @llvm.ssp.stream.load.f32(i64 19), !dbg !22
  %i50 = add i64 %i44, %i46, !dbg !23
  %i51 = getelementptr inbounds float, float* %arg6, i64 %i50, !dbg !24
  %i52 = load float, float* %i51, align 4, !dbg !24, !tbaa !25
  %i53 = fmul float %11, %i52, !dbg !29
  %i54 = add i64 %i46, %i37, !dbg !30
  %i55 = getelementptr inbounds float, float* %arg8, i64 %i54, !dbg !31
  %i56 = load float, float* %i55, align 4, !dbg !32, !tbaa !25
  %i57 = fadd float %i56, %i53, !dbg !32
  store float %i57, float* %i55, align 4, !dbg !32, !tbaa !25
  %i58 = or i64 %i46, 1, !dbg !33
  br label %bb59, !dbg !21

bb59:                                             ; preds = %bb48, %bb45
  %i60 = phi i64 [ %i58, %bb48 ], [ %i46, %bb45 ]
  %i61 = icmp eq i64 %i47, %i19, !dbg !21
  br i1 %i61, label %bb130, label %bb134, !dbg !21

bb62:                                             ; preds = %bb38
  %i63 = add i64 %7, %i39, !dbg !12
  %i64 = getelementptr float, float* %arg2, i64 %i63, !dbg !12
  %i65 = bitcast float* %i64 to i8*
  %i66 = getelementptr i8, i8* %i65, i64 1, !dbg !12
  %i67 = getelementptr float, float* %arg6, i64 %i44, !dbg !21
  %i68 = getelementptr float, float* %i13, i64 %i44, !dbg !21
  %i69 = icmp ugt i8* %i66, %i24, !dbg !21
  %i70 = icmp ult float* %i41, %i26, !dbg !21
  %i71 = and i1 %i69, %i70, !dbg !21
  %i72 = icmp ult float* %i23, %i68, !dbg !21
  %i73 = icmp ult float* %i67, %i26, !dbg !21
  %i74 = and i1 %i72, %i73, !dbg !21
  %i75 = or i1 %i71, %i74, !dbg !21
  br i1 %i75, label %bb45, label %bb76, !dbg !21

bb76:                                             ; preds = %bb62
  %12 = call float @llvm.ssp.stream.load.f32(i64 9), !dbg !12
  %i78 = insertelement <16 x float> undef, float %12, i32 0, !dbg !12
  %i79 = shufflevector <16 x float> %i78, <16 x float> undef, <16 x i32> zeroinitializer, !dbg !12
  %i80 = insertelement <16 x float> undef, float %12, i32 0, !dbg !12
  %i81 = shufflevector <16 x float> %i80, <16 x float> undef, <16 x i32> zeroinitializer, !dbg !12
  %i82 = insertelement <16 x float> undef, float %12, i32 0, !dbg !12
  %i83 = shufflevector <16 x float> %i82, <16 x float> undef, <16 x i32> zeroinitializer, !dbg !12
  %13 = call float @llvm.ssp.stream.load.f32(i64 10), !dbg !12
  %i85 = insertelement <16 x float> undef, float %13, i32 0, !dbg !12
  %i86 = shufflevector <16 x float> %i85, <16 x float> undef, <16 x i32> zeroinitializer, !dbg !12
  br label %bb87, !dbg !21

bb87:                                             ; preds = %bb87, %bb76
  %i88 = phi i64 [ 0, %bb76 ], [ %i127, %bb87 ], !dbg !33
  %14 = call <8 x double> @llvm.ssp.stream.load.v8f64(i64 20), !dbg !24
  %ssp.load.bitcast.i92 = bitcast <8 x double> %14 to <16 x float>, !dbg !24
  %15 = call <8 x double> @llvm.ssp.stream.load.v8f64(i64 21), !dbg !24
  %ssp.load.bitcast.i95 = bitcast <8 x double> %15 to <16 x float>, !dbg !24
  %16 = call <8 x double> @llvm.ssp.stream.load.v8f64(i64 22), !dbg !24
  %ssp.load.bitcast.i98 = bitcast <8 x double> %16 to <16 x float>, !dbg !24
  %17 = call <8 x double> @llvm.ssp.stream.load.v8f64(i64 23), !dbg !24
  %ssp.load.bitcast.i101 = bitcast <8 x double> %17 to <16 x float>, !dbg !24
  %i102 = fmul <16 x float> %i79, %ssp.load.bitcast.i92, !dbg !33
  %i103 = fmul <16 x float> %i81, %ssp.load.bitcast.i95, !dbg !33
  %i104 = fmul <16 x float> %i83, %ssp.load.bitcast.i98, !dbg !33
  %i105 = fmul <16 x float> %i86, %ssp.load.bitcast.i101, !dbg !33
  %i106 = add i64 %i88, %i37, !dbg !30
  %i107 = getelementptr inbounds float, float* %arg8, i64 %i106, !dbg !31
  %18 = call <8 x double> @llvm.ssp.stream.load.v8f64(i64 11), !dbg !32
  %ssp.load.bitcast.i109 = bitcast <8 x double> %18 to <16 x float>, !dbg !32
  %i110 = getelementptr inbounds float, float* %i107, i64 16, !dbg !32
  %19 = call <8 x double> @llvm.ssp.stream.load.v8f64(i64 12), !dbg !32
  %ssp.load.bitcast.i112 = bitcast <8 x double> %19 to <16 x float>, !dbg !32
  %i113 = getelementptr inbounds float, float* %i107, i64 32, !dbg !32
  %20 = call <8 x double> @llvm.ssp.stream.load.v8f64(i64 13), !dbg !32
  %ssp.load.bitcast.i115 = bitcast <8 x double> %20 to <16 x float>, !dbg !32
  %i116 = getelementptr inbounds float, float* %i107, i64 48, !dbg !32
  %21 = call <8 x double> @llvm.ssp.stream.load.v8f64(i64 14), !dbg !32
  %ssp.load.bitcast.i118 = bitcast <8 x double> %21 to <16 x float>, !dbg !32
  %i119 = fadd <16 x float> %ssp.load.bitcast.i109, %i102, !dbg !32
  %i120 = fadd <16 x float> %ssp.load.bitcast.i112, %i103, !dbg !32
  %i121 = fadd <16 x float> %ssp.load.bitcast.i115, %i104, !dbg !32
  %i122 = fadd <16 x float> %ssp.load.bitcast.i118, %i105, !dbg !32
  %i123 = bitcast float* %i107 to <16 x float>*, !dbg !32
  store <16 x float> %i119, <16 x float>* %i123, align 4, !dbg !32, !tbaa !25, !alias.scope !34, !noalias !37
  %i124 = bitcast float* %i110 to <16 x float>*, !dbg !32
  store <16 x float> %i120, <16 x float>* %i124, align 4, !dbg !32, !tbaa !25, !alias.scope !34, !noalias !37
  %i125 = bitcast float* %i113 to <16 x float>*, !dbg !32
  store <16 x float> %i121, <16 x float>* %i125, align 4, !dbg !32, !tbaa !25, !alias.scope !34, !noalias !37
  %i126 = bitcast float* %i116 to <16 x float>*, !dbg !32
  store <16 x float> %i122, <16 x float>* %i126, align 4, !dbg !32, !tbaa !25, !alias.scope !34, !noalias !37
  %i127 = add nuw nsw i64 %i88, 64, !dbg !33
  %i128 = icmp eq i64 %i127, %i15, !dbg !33
  call void @llvm.ssp.stream.step(i64 7), !dbg !33
  br i1 %i128, label %bb129, label %bb87, !dbg !33, !llvm.loop !40

bb129:                                            ; preds = %bb87
  br i1 %i16, label %bb130, label %bb45, !dbg !21

bb130:                                            ; preds = %bb134, %bb129, %bb59
  %i131 = add nuw i64 %i40, 1, !dbg !43
  %i132 = icmp ult i64 %i131, %8, !dbg !16
  %i133 = add i64 %i39, 1, !dbg !17
  call void @llvm.ssp.stream.step(i64 6), !dbg !17
  br i1 %i132, label %bb38, label %bb33.loopexit, !dbg !17, !llvm.loop !44

bb134:                                            ; preds = %bb134, %bb59
  %i135 = phi i64 [ %i155, %bb134 ], [ %i60, %bb59 ]
  %i136 = load float, float* %i41, align 4, !dbg !22, !tbaa !25
  %i137 = add i64 %i44, %i135, !dbg !23
  %i138 = getelementptr inbounds float, float* %arg6, i64 %i137, !dbg !24
  %i139 = load float, float* %i138, align 4, !dbg !24, !tbaa !25
  %i140 = fmul float %i136, %i139, !dbg !29
  %i141 = add i64 %i135, %i37, !dbg !30
  %i142 = getelementptr inbounds float, float* %arg8, i64 %i141, !dbg !31
  %i143 = load float, float* %i142, align 4, !dbg !32, !tbaa !25
  %i144 = fadd float %i143, %i140, !dbg !32
  store float %i144, float* %i142, align 4, !dbg !32, !tbaa !25
  %i145 = add nuw i64 %i135, 1, !dbg !33
  %i146 = load float, float* %i41, align 4, !dbg !22, !tbaa !25
  %i147 = add i64 %i44, %i145, !dbg !23
  %i148 = getelementptr inbounds float, float* %arg6, i64 %i147, !dbg !24
  %i149 = load float, float* %i148, align 4, !dbg !24, !tbaa !25
  %i150 = fmul float %i146, %i149, !dbg !29
  %i151 = add i64 %i145, %i37, !dbg !30
  %i152 = getelementptr inbounds float, float* %arg8, i64 %i151, !dbg !31
  %i153 = load float, float* %i152, align 4, !dbg !32, !tbaa !25
  %i154 = fadd float %i153, %i150, !dbg !32
  store float %i154, float* %i152, align 4, !dbg !32, !tbaa !25
  %i155 = add nuw i64 %i135, 2, !dbg !33
  %i156 = icmp eq i64 %i155, %arg1, !dbg !46
  br i1 %i156, label %bb130, label %bb134, !dbg !21, !llvm.loop !47

bb157.loopexit:                                   ; preds = %bb33
  call void @llvm.ssp.stream.end(i64 0), !dbg !49
  br label %bb157, !dbg !49

bb157:                                            ; preds = %bb158, %bb157.loopexit, %bb
  ret void, !dbg !49

bb158:                                            ; preds = %bb158, %bb10
  %i159 = phi i64 [ %i161, %bb158 ], [ 0, %bb10 ]
  %i160 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([9 x i8], [9 x i8]* @.str, i64 0, i64 0), i64 %i159), !dbg !13
  %i161 = add nuw i64 %i159, 1, !dbg !18
  %i162 = icmp eq i64 %i161, %arg, !dbg !10
  br i1 %i162, label %bb157, label %bb158, !dbg !11, !llvm.loop !19
}

; Function Attrs: nofree nounwind
declare dso_local noundef i32 @printf(i8* nocapture noundef readonly, ...) local_unnamed_addr #1

; Function Attrs: nounwind willreturn
declare i64 @llvm.ssp.stream.load.i64(i64) #2

; Function Attrs: nounwind willreturn
declare float @llvm.ssp.stream.load.f32(i64) #2

; Function Attrs: nounwind willreturn
declare <8 x double> @llvm.ssp.stream.load.v8f64(i64) #2

; Function Attrs: nounwind willreturn
declare void @llvm.ssp.stream.step(i64) #2

; Function Attrs: nounwind willreturn
declare void @llvm.ssp.stream.config(i64) #2

; Function Attrs: nounwind willreturn
declare void @llvm.ssp.stream.input.i64(i64, i64) #2

; Function Attrs: nounwind willreturn
declare void @llvm.ssp.stream.input.p0i64(i64, i64*) #2

; Function Attrs: nounwind willreturn
declare void @llvm.ssp.stream.ready() #2

; Function Attrs: nounwind willreturn
declare void @llvm.ssp.stream.end(i64) #2

; Function Attrs: nounwind willreturn
declare void @llvm.ssp.stream.input.p0f32(i64, float*) #2

attributes #0 = { nofree noinline nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+avx,+avx2,+avx512f,+cx8,+f16c,+fma,+fxsr,+mmx,+popcnt,+sse,+sse2,+sse3,+sse4.1,+sse4.2,+ssse3,+x87,+xsave" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nofree nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+avx,+avx2,+avx512f,+cx8,+f16c,+fma,+fxsr,+mmx,+popcnt,+sse,+sse2,+sse3,+sse4.1,+sse4.2,+ssse3,+x87,+xsave" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind willreturn }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}
!nvvm.annotations = !{}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 12.0.0 (https://github.com/SNU-ARC/gem-forge-llvm d6435b9f0e86f1259509ff1fa4f91f920ed1389e)", isOptimized: true, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home2/youngook/research/01_NDP/01_ISCA_23/gem-forge-framework/transform/benchmark/GemForgeMicroSuite/trusted_spmm_csr/trusted_spmm_csr.c", directory: "/home2/youngook/research/01_NDP/01_ISCA_23/gem-forge-framework/example_spmm")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"clang version 12.0.0 (https://github.com/SNU-ARC/gem-forge-llvm d6435b9f0e86f1259509ff1fa4f91f920ed1389e)"}
!7 = distinct !DISubprogram(name: "truested_spmm_csr", scope: !8, file: !8, line: 89, type: !9, scopeLine: 111, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!8 = !DIFile(filename: "transform/benchmark/GemForgeMicroSuite/trusted_spmm_csr/trusted_spmm_csr.c", directory: "/home2/youngook/research/01_NDP/01_ISCA_23/gem-forge-framework")
!9 = !DISubroutineType(types: !2)
!10 = !DILocation(line: 116, column: 28, scope: !7)
!11 = !DILocation(line: 116, column: 4, scope: !7)
!12 = !DILocation(line: 0, scope: !7)
!13 = !DILocation(line: 118, column: 4, scope: !7)
!14 = !DILocation(line: 119, column: 24, scope: !7)
!15 = !DILocation(line: 119, column: 38, scope: !7)
!16 = !DILocation(line: 119, column: 36, scope: !7)
!17 = !DILocation(line: 119, column: 7, scope: !7)
!18 = !DILocation(line: 116, column: 34, scope: !7)
!19 = distinct !{!19, !11, !20}
!20 = !DILocation(line: 129, column: 4, scope: !7)
!21 = !DILocation(line: 126, column: 10, scope: !7)
!22 = !DILocation(line: 127, column: 29, scope: !7)
!23 = !DILocation(line: 127, column: 49, scope: !7)
!24 = !DILocation(line: 127, column: 36, scope: !7)
!25 = !{!26, !26, i64 0}
!26 = !{!"float", !27, i64 0}
!27 = !{!"omnipotent char", !28, i64 0}
!28 = !{!"Simple C/C++ TBAA"}
!29 = !DILocation(line: 127, column: 35, scope: !7)
!30 = !DILocation(line: 127, column: 20, scope: !7)
!31 = !DILocation(line: 127, column: 13, scope: !7)
!32 = !DILocation(line: 127, column: 25, scope: !7)
!33 = !DILocation(line: 126, column: 41, scope: !7)
!34 = !{!35}
!35 = distinct !{!35, !36}
!36 = distinct !{!36, !"LVerDomain"}
!37 = !{!38, !39}
!38 = distinct !{!38, !36}
!39 = distinct !{!39, !36}
!40 = distinct !{!40, !21, !41, !42}
!41 = !DILocation(line: 127, column: 53, scope: !7)
!42 = !{!"llvm.loop.isvectorized", i32 1}
!43 = !DILocation(line: 119, column: 49, scope: !7)
!44 = distinct !{!44, !17, !45}
!45 = !DILocation(line: 128, column: 7, scope: !7)
!46 = !DILocation(line: 126, column: 34, scope: !7)
!47 = distinct !{!47, !21, !41, !42, !48}
!48 = !{!"llvm.loop.vectorize_is_epilogue", i32 0}
!49 = !DILocation(line: 131, column: 1, scope: !7)
