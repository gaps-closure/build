; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@llvm.global.annotations = appending global [4 x { i8*, i8*, i8*, i32, i8* }] [{ i8*, i8*, i8*, i32, i8* } { i8* bitcast (double* @get_a.a to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.1, i32 0, i32 0), i32 49, i8* null }, { i8*, i8*, i8*, i32, i8* } { i8* bitcast (i32 ()* @ewma_main to i8*), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.1, i32 0, i32 0), i32 60, i8* null }, { i8*, i8*, i8*, i32, i8* } { i8* bitcast (double* @get_b.b to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i32 0, i32 0), i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.1.5, i32 0, i32 0), i32 56, i8* null }, { i8*, i8*, i8*, i32, i8* } { i8* bitcast (double (double)* @get_ewma to i8*), i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.3.8, i32 0, i32 0), i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.1.5, i32 0, i32 0), i32 65, i8* null }], section "llvm.metadata"
@get_a.a = internal global double 0.000000e+00, align 8, !dbg !0
@.str = private unnamed_addr constant [7 x i8] c"ORANGE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [36 x i8] c"./divvied-working/orange/example2.c\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1
@.str.3 = private unnamed_addr constant [10 x i8] c"EWMA_MAIN\00", section "llvm.metadata"
@calc_ewma.c = internal global double 0.000000e+00, align 8, !dbg !11
@get_b.b = internal global double 1.000000e+00, align 8, !dbg !20
@.str.4 = private unnamed_addr constant [7 x i8] c"PURPLE\00", section "llvm.metadata"
@.str.1.5 = private unnamed_addr constant [36 x i8] c"./divvied-working/purple/example2.c\00", section "llvm.metadata"
@.str.2.9 = private unnamed_addr constant [17 x i8] c"PURPLE_SHAREABLE\00", section "llvm.metadata"
@.str.3.8 = private unnamed_addr constant [19 x i8] c"XDLINKAGE_GET_EWMA\00", section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @ewma_main() #0 !dbg !31 {
  %1 = alloca double, align 8
  %2 = alloca double, align 8
  %3 = alloca double, align 8
  %4 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata double* %1, metadata !35, metadata !DIExpression()), !dbg !36
  call void @llvm.dbg.declare(metadata double* %2, metadata !37, metadata !DIExpression()), !dbg !38
  call void @llvm.dbg.declare(metadata double* %3, metadata !39, metadata !DIExpression()), !dbg !40
  call void @llvm.dbg.declare(metadata i32* %4, metadata !41, metadata !DIExpression()), !dbg !43
  store i32 0, i32* %4, align 4, !dbg !43
  br label %5, !dbg !44

5:                                                ; preds = %16, %0
  %6 = load i32, i32* %4, align 4, !dbg !45
  %7 = icmp slt i32 %6, 10, !dbg !47
  br i1 %7, label %8, label %19, !dbg !48

8:                                                ; preds = %5
  %9 = call double @get_a() #4, !dbg !49
  store double %9, double* %1, align 8, !dbg !51
  %10 = load double, double* %1, align 8, !dbg !52
  store double %10, double* %2, align 8, !dbg !53
  %11 = load double, double* %2, align 8, !dbg !54
  %12 = call i32 (double, ...) bitcast (double (double)* @get_ewma to i32 (double, ...)*)(double noundef %11) #4, !dbg !55
  %13 = sitofp i32 %12 to double, !dbg !55
  store double %13, double* %3, align 8, !dbg !56
  %14 = load double, double* %3, align 8, !dbg !57
  %15 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i64 0, i64 0), double noundef %14) #4, !dbg !58
  br label %16, !dbg !59

16:                                               ; preds = %8
  %17 = load i32, i32* %4, align 4, !dbg !60
  %18 = add nsw i32 %17, 1, !dbg !60
  store i32 %18, i32* %4, align 4, !dbg !60
  br label %5, !dbg !61, !llvm.loop !62

19:                                               ; preds = %5
  ret i32 0, !dbg !65
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_a() #0 !dbg !2 {
  %1 = load double, double* @get_a.a, align 8, !dbg !66
  %2 = fadd double %1, 1.000000e+00, !dbg !66
  store double %2, double* @get_a.a, align 8, !dbg !66
  %3 = load double, double* @get_a.a, align 8, !dbg !67
  ret double %3, !dbg !68
}

declare i32 @printf(i8* noundef, ...) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !69 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  %2 = call i32 @ewma_main() #4, !dbg !70
  ret i32 %2, !dbg !71
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_ewma(double noundef %0) #0 !dbg !72 {
  %2 = alloca double, align 8
  %3 = alloca double, align 8
  %4 = alloca double, align 8
  %5 = alloca double, align 8
  store double %0, double* %2, align 8
  call void @llvm.dbg.declare(metadata double* %2, metadata !75, metadata !DIExpression()), !dbg !76
  call void @llvm.dbg.declare(metadata double* %3, metadata !77, metadata !DIExpression()), !dbg !78
  %6 = bitcast double* %3 to i8*, !dbg !79
  call void @llvm.var.annotation(i8* %6, i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str.2.9, i32 0, i32 0), i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.1.5, i32 0, i32 0), i32 70, i8* null), !dbg !79
  call void @llvm.dbg.declare(metadata double* %4, metadata !80, metadata !DIExpression()), !dbg !81
  %7 = bitcast double* %4 to i8*, !dbg !79
  call void @llvm.var.annotation(i8* %7, i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str.2.9, i32 0, i32 0), i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.1.5, i32 0, i32 0), i32 70, i8* null), !dbg !79
  call void @llvm.dbg.declare(metadata double* %5, metadata !82, metadata !DIExpression()), !dbg !83
  %8 = bitcast double* %5 to i8*, !dbg !79
  call void @llvm.var.annotation(i8* %8, i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str.2.9, i32 0, i32 0), i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.1.5, i32 0, i32 0), i32 70, i8* null), !dbg !79
  %9 = load double, double* %2, align 8, !dbg !84
  store double %9, double* %3, align 8, !dbg !85
  %10 = call double @get_b() #4, !dbg !86
  store double %10, double* %4, align 8, !dbg !87
  %11 = load double, double* %3, align 8, !dbg !88
  %12 = load double, double* %4, align 8, !dbg !89
  %13 = call double @calc_ewma(double noundef %11, double noundef %12) #4, !dbg !90
  store double %13, double* %5, align 8, !dbg !91
  %14 = load double, double* %5, align 8, !dbg !92
  ret double %14, !dbg !93
}

; Function Attrs: inaccessiblememonly nofree nosync nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32, i8*) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_b() #0 !dbg !22 {
  %1 = load double, double* @get_b.b, align 8, !dbg !94
  %2 = load double, double* @get_b.b, align 8, !dbg !95
  %3 = fadd double %2, %1, !dbg !95
  store double %3, double* @get_b.b, align 8, !dbg !95
  %4 = load double, double* @get_b.b, align 8, !dbg !96
  ret double %4, !dbg !97
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @calc_ewma(double noundef %0, double noundef %1) #0 !dbg !13 {
  %3 = alloca double, align 8
  %4 = alloca double, align 8
  %5 = alloca double, align 8
  store double %0, double* %3, align 8
  call void @llvm.dbg.declare(metadata double* %3, metadata !98, metadata !DIExpression()), !dbg !99
  store double %1, double* %4, align 8
  call void @llvm.dbg.declare(metadata double* %4, metadata !100, metadata !DIExpression()), !dbg !101
  call void @llvm.dbg.declare(metadata double* %5, metadata !102, metadata !DIExpression()), !dbg !104
  store double 2.500000e-01, double* %5, align 8, !dbg !104
  %6 = load double, double* %3, align 8, !dbg !105
  %7 = load double, double* %4, align 8, !dbg !106
  %8 = fadd double %6, %7, !dbg !107
  %9 = load double, double* @calc_ewma.c, align 8, !dbg !108
  %10 = fmul double 7.500000e-01, %9, !dbg !109
  %11 = call double @llvm.fmuladd.f64(double 2.500000e-01, double %8, double %10), !dbg !110
  store double %11, double* @calc_ewma.c, align 8, !dbg !111
  %12 = load double, double* @calc_ewma.c, align 8, !dbg !112
  ret double %12, !dbg !113
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare double @llvm.fmuladd.f64(double, double, double) #1

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { inaccessiblememonly nofree nosync nounwind willreturn }
attributes #4 = { nobuiltin "no-builtins" }

!llvm.dbg.cu = !{!7, !17}
!llvm.ident = !{!23, !23}
!llvm.module.flags = !{!24, !25, !26, !27, !28, !29, !30}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 49, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "get_a", scope: !3, file: !3, line: 46, type: !4, scopeLine: 46, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !10)
!3 = !DIFile(filename: "./divvied-working/orange/example2.c", directory: "/workspaces/build/apps/examples/example2", checksumkind: CSK_MD5, checksum: "44a3a9c828cb1e7dbc5dba20b5de9822")
!4 = !DISubroutineType(types: !5)
!5 = !{!6}
!6 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !8, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !9, splitDebugInlining: false, nameTableKind: None)
!8 = !DIFile(filename: "divvied-working/orange/example2.c", directory: "/workspaces/build/apps/examples/example2", checksumkind: CSK_MD5, checksum: "44a3a9c828cb1e7dbc5dba20b5de9822")
!9 = !{!0}
!10 = !{}
!11 = !DIGlobalVariableExpression(var: !12, expr: !DIExpression())
!12 = distinct !DIGlobalVariable(name: "c", scope: !13, file: !14, line: 47, type: !6, isLocal: true, isDefinition: true)
!13 = distinct !DISubprogram(name: "calc_ewma", scope: !14, file: !14, line: 45, type: !15, scopeLine: 45, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !17, retainedNodes: !10)
!14 = !DIFile(filename: "./divvied-working/purple/example2.c", directory: "/workspaces/build/apps/examples/example2", checksumkind: CSK_MD5, checksum: "5f6e5da1ab7e5d77eaec93732951ed91")
!15 = !DISubroutineType(types: !16)
!16 = !{!6, !6, !6}
!17 = distinct !DICompileUnit(language: DW_LANG_C99, file: !18, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !19, splitDebugInlining: false, nameTableKind: None)
!18 = !DIFile(filename: "divvied-working/purple/example2.c", directory: "/workspaces/build/apps/examples/example2", checksumkind: CSK_MD5, checksum: "5f6e5da1ab7e5d77eaec93732951ed91")
!19 = !{!11, !20}
!20 = !DIGlobalVariableExpression(var: !21, expr: !DIExpression())
!21 = distinct !DIGlobalVariable(name: "b", scope: !22, file: !14, line: 56, type: !6, isLocal: true, isDefinition: true)
!22 = distinct !DISubprogram(name: "get_b", scope: !14, file: !14, line: 53, type: !4, scopeLine: 53, spFlags: DISPFlagDefinition, unit: !17, retainedNodes: !10)
!23 = !{!"Ubuntu clang version 14.0.6"}
!24 = !{i32 7, !"Dwarf Version", i32 5}
!25 = !{i32 2, !"Debug Info Version", i32 3}
!26 = !{i32 1, !"wchar_size", i32 4}
!27 = !{i32 7, !"PIC Level", i32 2}
!28 = !{i32 7, !"PIE Level", i32 2}
!29 = !{i32 7, !"uwtable", i32 1}
!30 = !{i32 7, !"frame-pointer", i32 2}
!31 = distinct !DISubprogram(name: "ewma_main", scope: !3, file: !3, line: 60, type: !32, scopeLine: 60, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !10)
!32 = !DISubroutineType(types: !33)
!33 = !{!34}
!34 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!35 = !DILocalVariable(name: "x", scope: !31, file: !3, line: 63, type: !6)
!36 = !DILocation(line: 63, column: 10, scope: !31)
!37 = !DILocalVariable(name: "y", scope: !31, file: !3, line: 64, type: !6)
!38 = !DILocation(line: 64, column: 10, scope: !31)
!39 = !DILocalVariable(name: "ewma", scope: !31, file: !3, line: 65, type: !6)
!40 = !DILocation(line: 65, column: 10, scope: !31)
!41 = !DILocalVariable(name: "i", scope: !42, file: !3, line: 66, type: !34)
!42 = distinct !DILexicalBlock(scope: !31, file: !3, line: 66, column: 3)
!43 = !DILocation(line: 66, column: 12, scope: !42)
!44 = !DILocation(line: 66, column: 8, scope: !42)
!45 = !DILocation(line: 66, column: 17, scope: !46)
!46 = distinct !DILexicalBlock(scope: !42, file: !3, line: 66, column: 3)
!47 = !DILocation(line: 66, column: 19, scope: !46)
!48 = !DILocation(line: 66, column: 3, scope: !42)
!49 = !DILocation(line: 67, column: 9, scope: !50)
!50 = distinct !DILexicalBlock(scope: !46, file: !3, line: 66, column: 30)
!51 = !DILocation(line: 67, column: 7, scope: !50)
!52 = !DILocation(line: 68, column: 9, scope: !50)
!53 = !DILocation(line: 68, column: 7, scope: !50)
!54 = !DILocation(line: 69, column: 21, scope: !50)
!55 = !DILocation(line: 69, column: 12, scope: !50)
!56 = !DILocation(line: 69, column: 10, scope: !50)
!57 = !DILocation(line: 70, column: 20, scope: !50)
!58 = !DILocation(line: 70, column: 5, scope: !50)
!59 = !DILocation(line: 71, column: 3, scope: !50)
!60 = !DILocation(line: 66, column: 26, scope: !46)
!61 = !DILocation(line: 66, column: 3, scope: !46)
!62 = distinct !{!62, !48, !63, !64}
!63 = !DILocation(line: 71, column: 3, scope: !42)
!64 = !{!"llvm.loop.mustprogress"}
!65 = !DILocation(line: 72, column: 3, scope: !31)
!66 = !DILocation(line: 52, column: 5, scope: !2)
!67 = !DILocation(line: 53, column: 10, scope: !2)
!68 = !DILocation(line: 53, column: 3, scope: !2)
!69 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 75, type: !32, scopeLine: 75, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !10)
!70 = !DILocation(line: 76, column: 10, scope: !69)
!71 = !DILocation(line: 76, column: 3, scope: !69)
!72 = distinct !DISubprogram(name: "get_ewma", scope: !14, file: !14, line: 65, type: !73, scopeLine: 65, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !17, retainedNodes: !10)
!73 = !DISubroutineType(types: !74)
!74 = !{!6, !6}
!75 = !DILocalVariable(name: "x", arg: 1, scope: !72, file: !14, line: 65, type: !6)
!76 = !DILocation(line: 65, column: 24, scope: !72)
!77 = !DILocalVariable(name: "x1", scope: !72, file: !14, line: 70, type: !6)
!78 = !DILocation(line: 70, column: 10, scope: !72)
!79 = !DILocation(line: 70, column: 3, scope: !72)
!80 = !DILocalVariable(name: "y1", scope: !72, file: !14, line: 70, type: !6)
!81 = !DILocation(line: 70, column: 14, scope: !72)
!82 = !DILocalVariable(name: "z1", scope: !72, file: !14, line: 70, type: !6)
!83 = !DILocation(line: 70, column: 18, scope: !72)
!84 = !DILocation(line: 73, column: 8, scope: !72)
!85 = !DILocation(line: 73, column: 6, scope: !72)
!86 = !DILocation(line: 74, column: 8, scope: !72)
!87 = !DILocation(line: 74, column: 6, scope: !72)
!88 = !DILocation(line: 75, column: 18, scope: !72)
!89 = !DILocation(line: 75, column: 22, scope: !72)
!90 = !DILocation(line: 75, column: 8, scope: !72)
!91 = !DILocation(line: 75, column: 6, scope: !72)
!92 = !DILocation(line: 76, column: 10, scope: !72)
!93 = !DILocation(line: 76, column: 3, scope: !72)
!94 = !DILocation(line: 59, column: 8, scope: !22)
!95 = !DILocation(line: 59, column: 5, scope: !22)
!96 = !DILocation(line: 60, column: 10, scope: !22)
!97 = !DILocation(line: 60, column: 3, scope: !22)
!98 = !DILocalVariable(name: "a", arg: 1, scope: !13, file: !14, line: 45, type: !6)
!99 = !DILocation(line: 45, column: 25, scope: !13)
!100 = !DILocalVariable(name: "b", arg: 2, scope: !13, file: !14, line: 45, type: !6)
!101 = !DILocation(line: 45, column: 35, scope: !13)
!102 = !DILocalVariable(name: "alpha", scope: !13, file: !14, line: 46, type: !103)
!103 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !6)
!104 = !DILocation(line: 46, column: 17, scope: !13)
!105 = !DILocation(line: 48, column: 16, scope: !13)
!106 = !DILocation(line: 48, column: 20, scope: !13)
!107 = !DILocation(line: 48, column: 18, scope: !13)
!108 = !DILocation(line: 48, column: 39, scope: !13)
!109 = !DILocation(line: 48, column: 37, scope: !13)
!110 = !DILocation(line: 48, column: 23, scope: !13)
!111 = !DILocation(line: 48, column: 5, scope: !13)
!112 = !DILocation(line: 49, column: 10, scope: !13)
!113 = !DILocation(line: 49, column: 3, scope: !13)
