; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@llvm.global.annotations = appending global [5 x { i8*, i8*, i8*, i32, i8* }] [{ i8*, i8*, i8*, i32, i8* } { i8* bitcast (double (double, double)* @calc_ewma to i8*), i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.1, i32 0, i32 0), i32 50, i8* null }, { i8*, i8*, i8*, i32, i8* } { i8* bitcast (double* @get_a.a to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.1, i32 0, i32 0), i32 62, i8* null }, { i8*, i8*, i8*, i32, i8* } { i8* bitcast (double* @get_b.b to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.1, i32 0, i32 0), i32 72, i8* null }, { i8*, i8*, i8*, i32, i8* } { i8* bitcast (double ()* @get_ewma to i8*), i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.1, i32 0, i32 0), i32 81, i8* null }, { i8*, i8*, i8*, i32, i8* } { i8* bitcast (i32 ()* @ewma_main to i8*), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.1.2, i32 0, i32 0), i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.2.3, i32 0, i32 0), i32 54, i8* null }], section "llvm.metadata"
@calc_ewma.c = internal global double 0.000000e+00, align 8, !dbg !0
@.str = private unnamed_addr constant [15 x i8] c"EWMA_SHAREABLE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [36 x i8] c"./divvied-working/orange/example3.c\00", section "llvm.metadata"
@get_a.a = internal global double 0.000000e+00, align 8, !dbg !10
@.str.2 = private unnamed_addr constant [7 x i8] c"ORANGE\00", section "llvm.metadata"
@get_b.b = internal global double 1.000000e+00, align 8, !dbg !16
@.str.3 = private unnamed_addr constant [19 x i8] c"XDLINKAGE_GET_EWMA\00", section "llvm.metadata"
@.str.4 = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1
@.str.1.2 = private unnamed_addr constant [10 x i8] c"EWMA_MAIN\00", section "llvm.metadata"
@.str.2.3 = private unnamed_addr constant [36 x i8] c"./divvied-working/purple/example3.c\00", section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @calc_ewma(double noundef %0, double noundef %1) #0 !dbg !2 {
  %3 = alloca double, align 8
  %4 = alloca double, align 8
  %5 = alloca double, align 8
  store double %0, double* %3, align 8
  call void @llvm.dbg.declare(metadata double* %3, metadata !29, metadata !DIExpression()), !dbg !30
  store double %1, double* %4, align 8
  call void @llvm.dbg.declare(metadata double* %4, metadata !31, metadata !DIExpression()), !dbg !32
  call void @llvm.dbg.declare(metadata double* %5, metadata !33, metadata !DIExpression()), !dbg !35
  store double 2.500000e-01, double* %5, align 8, !dbg !35
  %6 = load double, double* %3, align 8, !dbg !36
  %7 = load double, double* %4, align 8, !dbg !37
  %8 = fadd double %6, %7, !dbg !38
  %9 = load double, double* @calc_ewma.c, align 8, !dbg !39
  %10 = fmul double 7.500000e-01, %9, !dbg !40
  %11 = call double @llvm.fmuladd.f64(double 2.500000e-01, double %8, double %10), !dbg !41
  store double %11, double* @calc_ewma.c, align 8, !dbg !42
  %12 = load double, double* @calc_ewma.c, align 8, !dbg !43
  ret double %12, !dbg !44
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_ewma() #0 !dbg !45 {
  %1 = alloca double, align 8
  %2 = alloca double, align 8
  call void @llvm.dbg.declare(metadata double* %1, metadata !46, metadata !DIExpression()), !dbg !47
  %3 = call double @get_a() #3, !dbg !48
  store double %3, double* %1, align 8, !dbg !47
  call void @llvm.dbg.declare(metadata double* %2, metadata !49, metadata !DIExpression()), !dbg !50
  %4 = call double @get_b() #3, !dbg !51
  store double %4, double* %2, align 8, !dbg !50
  %5 = load double, double* %1, align 8, !dbg !52
  %6 = load double, double* %2, align 8, !dbg !53
  %7 = call double @calc_ewma(double noundef %5, double noundef %6) #3, !dbg !54
  ret double %7, !dbg !55
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_a() #0 !dbg !12 {
  %1 = load double, double* @get_a.a, align 8, !dbg !56
  %2 = fadd double %1, 1.000000e+00, !dbg !56
  store double %2, double* @get_a.a, align 8, !dbg !56
  %3 = load double, double* @get_a.a, align 8, !dbg !57
  ret double %3, !dbg !58
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_b() #0 !dbg !18 {
  %1 = load double, double* @get_b.b, align 8, !dbg !59
  %2 = load double, double* @get_b.b, align 8, !dbg !60
  %3 = fadd double %2, %1, !dbg !60
  store double %3, double* @get_b.b, align 8, !dbg !60
  %4 = load double, double* @get_b.b, align 8, !dbg !61
  ret double %4, !dbg !62
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare double @llvm.fmuladd.f64(double, double, double) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @ewma_main() #0 !dbg !63 {
  %1 = alloca double, align 8
  %2 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata double* %1, metadata !68, metadata !DIExpression()), !dbg !69
  call void @llvm.dbg.declare(metadata i32* %2, metadata !70, metadata !DIExpression()), !dbg !72
  store i32 0, i32* %2, align 4, !dbg !72
  br label %3, !dbg !73

3:                                                ; preds = %11, %0
  %4 = load i32, i32* %2, align 4, !dbg !74
  %5 = icmp slt i32 %4, 10, !dbg !76
  br i1 %5, label %6, label %14, !dbg !77

6:                                                ; preds = %3
  %7 = call i32 (...) bitcast (double ()* @get_ewma to i32 (...)*)() #3, !dbg !78
  %8 = sitofp i32 %7 to double, !dbg !78
  store double %8, double* %1, align 8, !dbg !80
  %9 = load double, double* %1, align 8, !dbg !81
  %10 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i64 0, i64 0), double noundef %9) #3, !dbg !82
  br label %11, !dbg !83

11:                                               ; preds = %6
  %12 = load i32, i32* %2, align 4, !dbg !84
  %13 = add nsw i32 %12, 1, !dbg !84
  store i32 %13, i32* %2, align 4, !dbg !84
  br label %3, !dbg !85, !llvm.loop !86

14:                                               ; preds = %3
  ret i32 0, !dbg !89
}

declare i32 @printf(i8* noundef, ...) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 noundef %0, i8** noundef %1) #0 !dbg !90 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !96, metadata !DIExpression()), !dbg !97
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !98, metadata !DIExpression()), !dbg !99
  %6 = call i32 @ewma_main() #3, !dbg !100
  ret i32 %6, !dbg !101
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nobuiltin "no-builtins" }

!llvm.dbg.cu = !{!7, !19}
!llvm.ident = !{!21, !21}
!llvm.module.flags = !{!22, !23, !24, !25, !26, !27, !28}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "c", scope: !2, file: !3, line: 54, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "calc_ewma", scope: !3, file: !3, line: 50, type: !4, scopeLine: 50, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !15)
!3 = !DIFile(filename: "./divvied-working/orange/example3.c", directory: "/workspaces/build/apps/examples/example3", checksumkind: CSK_MD5, checksum: "32610c8333df3dfa9627792fefe0a29b")
!4 = !DISubroutineType(types: !5)
!5 = !{!6, !6, !6}
!6 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !8, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !9, splitDebugInlining: false, nameTableKind: None)
!8 = !DIFile(filename: "divvied-working/orange/example3.c", directory: "/workspaces/build/apps/examples/example3", checksumkind: CSK_MD5, checksum: "32610c8333df3dfa9627792fefe0a29b")
!9 = !{!0, !10, !16}
!10 = !DIGlobalVariableExpression(var: !11, expr: !DIExpression())
!11 = distinct !DIGlobalVariable(name: "a", scope: !12, file: !3, line: 62, type: !6, isLocal: true, isDefinition: true)
!12 = distinct !DISubprogram(name: "get_a", scope: !3, file: !3, line: 59, type: !13, scopeLine: 59, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !15)
!13 = !DISubroutineType(types: !14)
!14 = !{!6}
!15 = !{}
!16 = !DIGlobalVariableExpression(var: !17, expr: !DIExpression())
!17 = distinct !DIGlobalVariable(name: "b", scope: !18, file: !3, line: 72, type: !6, isLocal: true, isDefinition: true)
!18 = distinct !DISubprogram(name: "get_b", scope: !3, file: !3, line: 69, type: !13, scopeLine: 69, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !15)
!19 = distinct !DICompileUnit(language: DW_LANG_C99, file: !20, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!20 = !DIFile(filename: "divvied-working/purple/example3.c", directory: "/workspaces/build/apps/examples/example3", checksumkind: CSK_MD5, checksum: "6dfb087c257713b633023d4633a615f0")
!21 = !{!"Ubuntu clang version 14.0.6"}
!22 = !{i32 7, !"Dwarf Version", i32 5}
!23 = !{i32 2, !"Debug Info Version", i32 3}
!24 = !{i32 1, !"wchar_size", i32 4}
!25 = !{i32 7, !"PIC Level", i32 2}
!26 = !{i32 7, !"PIE Level", i32 2}
!27 = !{i32 7, !"uwtable", i32 1}
!28 = !{i32 7, !"frame-pointer", i32 2}
!29 = !DILocalVariable(name: "a", arg: 1, scope: !2, file: !3, line: 50, type: !6)
!30 = !DILocation(line: 50, column: 25, scope: !2)
!31 = !DILocalVariable(name: "b", arg: 2, scope: !2, file: !3, line: 50, type: !6)
!32 = !DILocation(line: 50, column: 35, scope: !2)
!33 = !DILocalVariable(name: "alpha", scope: !2, file: !3, line: 53, type: !34)
!34 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !6)
!35 = !DILocation(line: 53, column: 17, scope: !2)
!36 = !DILocation(line: 55, column: 16, scope: !2)
!37 = !DILocation(line: 55, column: 20, scope: !2)
!38 = !DILocation(line: 55, column: 18, scope: !2)
!39 = !DILocation(line: 55, column: 39, scope: !2)
!40 = !DILocation(line: 55, column: 37, scope: !2)
!41 = !DILocation(line: 55, column: 23, scope: !2)
!42 = !DILocation(line: 55, column: 5, scope: !2)
!43 = !DILocation(line: 56, column: 10, scope: !2)
!44 = !DILocation(line: 56, column: 3, scope: !2)
!45 = distinct !DISubprogram(name: "get_ewma", scope: !3, file: !3, line: 81, type: !13, scopeLine: 81, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !15)
!46 = !DILocalVariable(name: "x", scope: !45, file: !3, line: 84, type: !6)
!47 = !DILocation(line: 84, column: 10, scope: !45)
!48 = !DILocation(line: 84, column: 14, scope: !45)
!49 = !DILocalVariable(name: "y", scope: !45, file: !3, line: 85, type: !6)
!50 = !DILocation(line: 85, column: 10, scope: !45)
!51 = !DILocation(line: 85, column: 14, scope: !45)
!52 = !DILocation(line: 86, column: 20, scope: !45)
!53 = !DILocation(line: 86, column: 22, scope: !45)
!54 = !DILocation(line: 86, column: 10, scope: !45)
!55 = !DILocation(line: 86, column: 3, scope: !45)
!56 = !DILocation(line: 65, column: 5, scope: !12)
!57 = !DILocation(line: 66, column: 10, scope: !12)
!58 = !DILocation(line: 66, column: 3, scope: !12)
!59 = !DILocation(line: 75, column: 8, scope: !18)
!60 = !DILocation(line: 75, column: 5, scope: !18)
!61 = !DILocation(line: 76, column: 10, scope: !18)
!62 = !DILocation(line: 76, column: 3, scope: !18)
!63 = distinct !DISubprogram(name: "ewma_main", scope: !64, file: !64, line: 54, type: !65, scopeLine: 54, spFlags: DISPFlagDefinition, unit: !19, retainedNodes: !15)
!64 = !DIFile(filename: "./divvied-working/purple/example3.c", directory: "/workspaces/build/apps/examples/example3", checksumkind: CSK_MD5, checksum: "6dfb087c257713b633023d4633a615f0")
!65 = !DISubroutineType(types: !66)
!66 = !{!67}
!67 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!68 = !DILocalVariable(name: "ewma", scope: !63, file: !64, line: 57, type: !6)
!69 = !DILocation(line: 57, column: 10, scope: !63)
!70 = !DILocalVariable(name: "i", scope: !71, file: !64, line: 58, type: !67)
!71 = distinct !DILexicalBlock(scope: !63, file: !64, line: 58, column: 3)
!72 = !DILocation(line: 58, column: 12, scope: !71)
!73 = !DILocation(line: 58, column: 8, scope: !71)
!74 = !DILocation(line: 58, column: 17, scope: !75)
!75 = distinct !DILexicalBlock(scope: !71, file: !64, line: 58, column: 3)
!76 = !DILocation(line: 58, column: 19, scope: !75)
!77 = !DILocation(line: 58, column: 3, scope: !71)
!78 = !DILocation(line: 59, column: 12, scope: !79)
!79 = distinct !DILexicalBlock(scope: !75, file: !64, line: 58, column: 30)
!80 = !DILocation(line: 59, column: 10, scope: !79)
!81 = !DILocation(line: 60, column: 20, scope: !79)
!82 = !DILocation(line: 60, column: 5, scope: !79)
!83 = !DILocation(line: 61, column: 3, scope: !79)
!84 = !DILocation(line: 58, column: 26, scope: !75)
!85 = !DILocation(line: 58, column: 3, scope: !75)
!86 = distinct !{!86, !77, !87, !88}
!87 = !DILocation(line: 61, column: 3, scope: !71)
!88 = !{!"llvm.loop.mustprogress"}
!89 = !DILocation(line: 62, column: 3, scope: !63)
!90 = distinct !DISubprogram(name: "main", scope: !64, file: !64, line: 65, type: !91, scopeLine: 65, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !19, retainedNodes: !15)
!91 = !DISubroutineType(types: !92)
!92 = !{!67, !67, !93}
!93 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !94, size: 64)
!94 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !95, size: 64)
!95 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!96 = !DILocalVariable(name: "argc", arg: 1, scope: !90, file: !64, line: 65, type: !67)
!97 = !DILocation(line: 65, column: 14, scope: !90)
!98 = !DILocalVariable(name: "argv", arg: 2, scope: !90, file: !64, line: 65, type: !93)
!99 = !DILocation(line: 65, column: 27, scope: !90)
!100 = !DILocation(line: 66, column: 10, scope: !90)
!101 = !DILocation(line: 66, column: 3, scope: !90)
