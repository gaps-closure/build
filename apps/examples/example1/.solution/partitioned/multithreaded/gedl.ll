; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@llvm.global.annotations = appending global [4 x { i8*, i8*, i8*, i32, i8* }] [{ i8*, i8*, i8*, i32, i8* } { i8* bitcast (double* @get_a.a to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.1, i32 0, i32 0), i32 46, i8* null }, { i8*, i8*, i8*, i32, i8* } { i8* bitcast (double ()* @get_a to i8*), i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.1, i32 0, i32 0), i32 41, i8* null }, { i8*, i8*, i8*, i32, i8* } { i8* bitcast (double* @get_b.b to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.1.4, i32 0, i32 0), i32 48, i8* null }, { i8*, i8*, i8*, i32, i8* } { i8* bitcast (i32 ()* @ewma_main to i8*), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.3.5, i32 0, i32 0), i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.1.4, i32 0, i32 0), i32 56, i8* null }], section "llvm.metadata"
@get_a.a = internal global double 0.000000e+00, align 8, !dbg !0
@.str = private unnamed_addr constant [7 x i8] c"ORANGE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [36 x i8] c"./divvied-working/orange/example1.c\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [16 x i8] c"XDLINKAGE_GET_A\00", section "llvm.metadata"
@calc_ewma.c = internal global double 0.000000e+00, align 8, !dbg !11
@get_b.b = internal global double 1.000000e+00, align 8, !dbg !20
@.str.3 = private unnamed_addr constant [7 x i8] c"PURPLE\00", section "llvm.metadata"
@.str.1.4 = private unnamed_addr constant [36 x i8] c"./divvied-working/purple/example1.c\00", section "llvm.metadata"
@.str.2.6 = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1
@.str.3.5 = private unnamed_addr constant [10 x i8] c"EWMA_MAIN\00", section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_a() #0 !dbg !2 {
  %1 = load double, double* @get_a.a, align 8, !dbg !31
  %2 = fadd double %1, 1.000000e+00, !dbg !31
  store double %2, double* @get_a.a, align 8, !dbg !31
  %3 = load double, double* @get_a.a, align 8, !dbg !32
  ret double %3, !dbg !33
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @ewma_main() #0 !dbg !34 {
  %1 = alloca double, align 8
  %2 = alloca double, align 8
  %3 = alloca double, align 8
  %4 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata double* %1, metadata !38, metadata !DIExpression()), !dbg !39
  call void @llvm.dbg.declare(metadata double* %2, metadata !40, metadata !DIExpression()), !dbg !41
  call void @llvm.dbg.declare(metadata double* %3, metadata !42, metadata !DIExpression()), !dbg !43
  %5 = bitcast double* %3 to i8*, !dbg !44
  call void @llvm.var.annotation(i8* %5, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.1.4, i32 0, i32 0), i32 63, i8* null), !dbg !44
  call void @llvm.dbg.declare(metadata i32* %4, metadata !45, metadata !DIExpression()), !dbg !47
  store i32 0, i32* %4, align 4, !dbg !47
  br label %6, !dbg !48

6:                                                ; preds = %18, %0
  %7 = load i32, i32* %4, align 4, !dbg !49
  %8 = icmp slt i32 %7, 10, !dbg !51
  br i1 %8, label %9, label %21, !dbg !52

9:                                                ; preds = %6
  %10 = call i32 (...) bitcast (double ()* @get_a to i32 (...)*)() #4, !dbg !53
  %11 = sitofp i32 %10 to double, !dbg !53
  store double %11, double* %1, align 8, !dbg !55
  %12 = call double @get_b() #4, !dbg !56
  store double %12, double* %2, align 8, !dbg !57
  %13 = load double, double* %1, align 8, !dbg !58
  %14 = load double, double* %2, align 8, !dbg !59
  %15 = call double @calc_ewma(double noundef %13, double noundef %14) #4, !dbg !60
  store double %15, double* %3, align 8, !dbg !61
  %16 = load double, double* %3, align 8, !dbg !62
  %17 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2.6, i64 0, i64 0), double noundef %16) #4, !dbg !63
  br label %18, !dbg !64

18:                                               ; preds = %9
  %19 = load i32, i32* %4, align 4, !dbg !65
  %20 = add nsw i32 %19, 1, !dbg !65
  store i32 %20, i32* %4, align 4, !dbg !65
  br label %6, !dbg !66, !llvm.loop !67

21:                                               ; preds = %6
  ret i32 0, !dbg !70
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: inaccessiblememonly nofree nosync nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32, i8*) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_b() #0 !dbg !22 {
  %1 = load double, double* @get_b.b, align 8, !dbg !71
  %2 = load double, double* @get_b.b, align 8, !dbg !72
  %3 = fadd double %2, %1, !dbg !72
  store double %3, double* @get_b.b, align 8, !dbg !72
  %4 = load double, double* @get_b.b, align 8, !dbg !73
  ret double %4, !dbg !74
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @calc_ewma(double noundef %0, double noundef %1) #0 !dbg !13 {
  %3 = alloca double, align 8
  %4 = alloca double, align 8
  %5 = alloca double, align 8
  store double %0, double* %3, align 8
  call void @llvm.dbg.declare(metadata double* %3, metadata !75, metadata !DIExpression()), !dbg !76
  store double %1, double* %4, align 8
  call void @llvm.dbg.declare(metadata double* %4, metadata !77, metadata !DIExpression()), !dbg !78
  call void @llvm.dbg.declare(metadata double* %5, metadata !79, metadata !DIExpression()), !dbg !81
  store double 2.500000e-01, double* %5, align 8, !dbg !81
  %6 = load double, double* %3, align 8, !dbg !82
  %7 = load double, double* %4, align 8, !dbg !83
  %8 = fadd double %6, %7, !dbg !84
  %9 = load double, double* @calc_ewma.c, align 8, !dbg !85
  %10 = fmul double 7.500000e-01, %9, !dbg !86
  %11 = call double @llvm.fmuladd.f64(double 2.500000e-01, double %8, double %10), !dbg !87
  store double %11, double* @calc_ewma.c, align 8, !dbg !88
  %12 = load double, double* @calc_ewma.c, align 8, !dbg !89
  ret double %12, !dbg !90
}

declare i32 @printf(i8* noundef, ...) #3

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare double @llvm.fmuladd.f64(double, double, double) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 noundef %0, i8** noundef %1) #0 !dbg !91 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !97, metadata !DIExpression()), !dbg !98
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !99, metadata !DIExpression()), !dbg !100
  %6 = call i32 @ewma_main() #4, !dbg !101
  ret i32 %6, !dbg !102
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { inaccessiblememonly nofree nosync nounwind willreturn }
attributes #3 = { "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nobuiltin "no-builtins" }

!llvm.dbg.cu = !{!7, !17}
!llvm.ident = !{!23, !23}
!llvm.module.flags = !{!24, !25, !26, !27, !28, !29, !30}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 46, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "get_a", scope: !3, file: !3, line: 41, type: !4, scopeLine: 41, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !10)
!3 = !DIFile(filename: "./divvied-working/orange/example1.c", directory: "/workspaces/build/apps/examples/example1", checksumkind: CSK_MD5, checksum: "600f7e18c1e5124e8932bc4ca7c92008")
!4 = !DISubroutineType(types: !5)
!5 = !{!6}
!6 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !8, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !9, splitDebugInlining: false, nameTableKind: None)
!8 = !DIFile(filename: "divvied-working/orange/example1.c", directory: "/workspaces/build/apps/examples/example1", checksumkind: CSK_MD5, checksum: "600f7e18c1e5124e8932bc4ca7c92008")
!9 = !{!0}
!10 = !{}
!11 = !DIGlobalVariableExpression(var: !12, expr: !DIExpression())
!12 = distinct !DIGlobalVariable(name: "c", scope: !13, file: !14, line: 41, type: !6, isLocal: true, isDefinition: true)
!13 = distinct !DISubprogram(name: "calc_ewma", scope: !14, file: !14, line: 39, type: !15, scopeLine: 39, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !17, retainedNodes: !10)
!14 = !DIFile(filename: "./divvied-working/purple/example1.c", directory: "/workspaces/build/apps/examples/example1", checksumkind: CSK_MD5, checksum: "086ee4de073c0b3acc6e65486dec4e7e")
!15 = !DISubroutineType(types: !16)
!16 = !{!6, !6, !6}
!17 = distinct !DICompileUnit(language: DW_LANG_C99, file: !18, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !19, splitDebugInlining: false, nameTableKind: None)
!18 = !DIFile(filename: "divvied-working/purple/example1.c", directory: "/workspaces/build/apps/examples/example1", checksumkind: CSK_MD5, checksum: "086ee4de073c0b3acc6e65486dec4e7e")
!19 = !{!11, !20}
!20 = !DIGlobalVariableExpression(var: !21, expr: !DIExpression())
!21 = distinct !DIGlobalVariable(name: "b", scope: !22, file: !14, line: 48, type: !6, isLocal: true, isDefinition: true)
!22 = distinct !DISubprogram(name: "get_b", scope: !14, file: !14, line: 45, type: !4, scopeLine: 45, spFlags: DISPFlagDefinition, unit: !17, retainedNodes: !10)
!23 = !{!"Ubuntu clang version 14.0.6"}
!24 = !{i32 7, !"Dwarf Version", i32 5}
!25 = !{i32 2, !"Debug Info Version", i32 3}
!26 = !{i32 1, !"wchar_size", i32 4}
!27 = !{i32 7, !"PIC Level", i32 2}
!28 = !{i32 7, !"PIE Level", i32 2}
!29 = !{i32 7, !"uwtable", i32 1}
!30 = !{i32 7, !"frame-pointer", i32 2}
!31 = !DILocation(line: 49, column: 5, scope: !2)
!32 = !DILocation(line: 50, column: 10, scope: !2)
!33 = !DILocation(line: 50, column: 3, scope: !2)
!34 = distinct !DISubprogram(name: "ewma_main", scope: !14, file: !14, line: 56, type: !35, scopeLine: 56, spFlags: DISPFlagDefinition, unit: !17, retainedNodes: !10)
!35 = !DISubroutineType(types: !36)
!36 = !{!37}
!37 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!38 = !DILocalVariable(name: "x", scope: !34, file: !14, line: 59, type: !6)
!39 = !DILocation(line: 59, column: 10, scope: !34)
!40 = !DILocalVariable(name: "y", scope: !34, file: !14, line: 60, type: !6)
!41 = !DILocation(line: 60, column: 10, scope: !34)
!42 = !DILocalVariable(name: "ewma", scope: !34, file: !14, line: 63, type: !6)
!43 = !DILocation(line: 63, column: 10, scope: !34)
!44 = !DILocation(line: 63, column: 3, scope: !34)
!45 = !DILocalVariable(name: "i", scope: !46, file: !14, line: 66, type: !37)
!46 = distinct !DILexicalBlock(scope: !34, file: !14, line: 66, column: 3)
!47 = !DILocation(line: 66, column: 12, scope: !46)
!48 = !DILocation(line: 66, column: 8, scope: !46)
!49 = !DILocation(line: 66, column: 17, scope: !50)
!50 = distinct !DILexicalBlock(scope: !46, file: !14, line: 66, column: 3)
!51 = !DILocation(line: 66, column: 19, scope: !50)
!52 = !DILocation(line: 66, column: 3, scope: !46)
!53 = !DILocation(line: 67, column: 9, scope: !54)
!54 = distinct !DILexicalBlock(scope: !50, file: !14, line: 66, column: 30)
!55 = !DILocation(line: 67, column: 7, scope: !54)
!56 = !DILocation(line: 68, column: 9, scope: !54)
!57 = !DILocation(line: 68, column: 7, scope: !54)
!58 = !DILocation(line: 69, column: 22, scope: !54)
!59 = !DILocation(line: 69, column: 24, scope: !54)
!60 = !DILocation(line: 69, column: 12, scope: !54)
!61 = !DILocation(line: 69, column: 10, scope: !54)
!62 = !DILocation(line: 70, column: 20, scope: !54)
!63 = !DILocation(line: 70, column: 5, scope: !54)
!64 = !DILocation(line: 71, column: 3, scope: !54)
!65 = !DILocation(line: 66, column: 26, scope: !50)
!66 = !DILocation(line: 66, column: 3, scope: !50)
!67 = distinct !{!67, !52, !68, !69}
!68 = !DILocation(line: 71, column: 3, scope: !46)
!69 = !{!"llvm.loop.mustprogress"}
!70 = !DILocation(line: 72, column: 3, scope: !34)
!71 = !DILocation(line: 51, column: 8, scope: !22)
!72 = !DILocation(line: 51, column: 5, scope: !22)
!73 = !DILocation(line: 52, column: 10, scope: !22)
!74 = !DILocation(line: 52, column: 3, scope: !22)
!75 = !DILocalVariable(name: "a", arg: 1, scope: !13, file: !14, line: 39, type: !6)
!76 = !DILocation(line: 39, column: 25, scope: !13)
!77 = !DILocalVariable(name: "b", arg: 2, scope: !13, file: !14, line: 39, type: !6)
!78 = !DILocation(line: 39, column: 35, scope: !13)
!79 = !DILocalVariable(name: "alpha", scope: !13, file: !14, line: 40, type: !80)
!80 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !6)
!81 = !DILocation(line: 40, column: 17, scope: !13)
!82 = !DILocation(line: 42, column: 16, scope: !13)
!83 = !DILocation(line: 42, column: 20, scope: !13)
!84 = !DILocation(line: 42, column: 18, scope: !13)
!85 = !DILocation(line: 42, column: 39, scope: !13)
!86 = !DILocation(line: 42, column: 37, scope: !13)
!87 = !DILocation(line: 42, column: 23, scope: !13)
!88 = !DILocation(line: 42, column: 5, scope: !13)
!89 = !DILocation(line: 43, column: 10, scope: !13)
!90 = !DILocation(line: 43, column: 3, scope: !13)
!91 = distinct !DISubprogram(name: "main", scope: !14, file: !14, line: 74, type: !92, scopeLine: 74, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !17, retainedNodes: !10)
!92 = !DISubroutineType(types: !93)
!93 = !{!37, !37, !94}
!94 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !95, size: 64)
!95 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !96, size: 64)
!96 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!97 = !DILocalVariable(name: "argc", arg: 1, scope: !91, file: !14, line: 74, type: !37)
!98 = !DILocation(line: 74, column: 14, scope: !91)
!99 = !DILocalVariable(name: "argv", arg: 2, scope: !91, file: !14, line: 74, type: !94)
!100 = !DILocation(line: 74, column: 27, scope: !91)
!101 = !DILocation(line: 75, column: 10, scope: !91)
!102 = !DILocation(line: 75, column: 3, scope: !91)
