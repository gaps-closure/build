; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@llvm.global.annotations = appending global [2 x { i8*, i8*, i8*, i32 }] [{ i8*, i8*, i8*, i32 } { i8* bitcast (double* @fib.p to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.1, i32 0, i32 0), i32 30 }, { i8*, i8*, i8*, i32 } { i8* bitcast (double (i32)* @fib to i8*), i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.1, i32 0, i32 0), i32 25 }], section "llvm.metadata"
@fib.p = internal global double 2.000000e+00, align 8, !dbg !0
@.str.2 = private unnamed_addr constant [7 x i8] c"ORANGE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [32 x i8] c"./divvied/orange/example2.mod.c\00", section "llvm.metadata"
@.str = private unnamed_addr constant [16 x i8] c"XDLINKAGE_GET_A\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [7 x i8] c"PURPLE\00", section "llvm.metadata"
@.str.1.4 = private unnamed_addr constant [32 x i8] c"./divvied/purple/example2.mod.c\00", section "llvm.metadata"
@.str.2.5 = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @fib(i32 %0) #0 !dbg !2 {
  %2 = alloca double, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  call void @llvm.dbg.declare(metadata i32* %3, metadata !18, metadata !DIExpression()), !dbg !19
  %8 = bitcast i32* %3 to i8*
  call void @llvm.var.annotation(i8* %8, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.1, i32 0, i32 0), i32 25)
  %9 = load i32, i32* %3, align 4, !dbg !20
  %10 = add nsw i32 %9, 1, !dbg !20
  store i32 %10, i32* %3, align 4, !dbg !20
  %11 = load i32, i32* %3, align 4, !dbg !21
  %12 = icmp slt i32 %11, 2, !dbg !23
  br i1 %12, label %13, label %14, !dbg !24

13:                                               ; preds = %1
  store double 1.000000e+00, double* %2, align 8, !dbg !25
  br label %31, !dbg !25

14:                                               ; preds = %1
  call void @llvm.dbg.declare(metadata i32* %4, metadata !27, metadata !DIExpression()), !dbg !28
  store i32 1, i32* %4, align 4, !dbg !28
  call void @llvm.dbg.declare(metadata i32* %5, metadata !29, metadata !DIExpression()), !dbg !30
  store i32 1, i32* %5, align 4, !dbg !30
  call void @llvm.dbg.declare(metadata i32* %6, metadata !31, metadata !DIExpression()), !dbg !33
  store i32 2, i32* %6, align 4, !dbg !33
  br label %15, !dbg !34

15:                                               ; preds = %25, %14
  %16 = load i32, i32* %6, align 4, !dbg !35
  %17 = load i32, i32* %3, align 4, !dbg !37
  %18 = icmp slt i32 %16, %17, !dbg !38
  br i1 %18, label %19, label %28, !dbg !39

19:                                               ; preds = %15
  call void @llvm.dbg.declare(metadata i32* %7, metadata !40, metadata !DIExpression()), !dbg !42
  %20 = load i32, i32* %4, align 4, !dbg !43
  store i32 %20, i32* %7, align 4, !dbg !42
  %21 = load i32, i32* %4, align 4, !dbg !44
  %22 = load i32, i32* %5, align 4, !dbg !45
  %23 = add nsw i32 %21, %22, !dbg !46
  store i32 %23, i32* %4, align 4, !dbg !47
  %24 = load i32, i32* %7, align 4, !dbg !48
  store i32 %24, i32* %5, align 4, !dbg !49
  br label %25, !dbg !50

25:                                               ; preds = %19
  %26 = load i32, i32* %6, align 4, !dbg !51
  %27 = add nsw i32 %26, 1, !dbg !51
  store i32 %27, i32* %6, align 4, !dbg !51
  br label %15, !dbg !52, !llvm.loop !53

28:                                               ; preds = %15
  %29 = load i32, i32* %4, align 4, !dbg !55
  %30 = sitofp i32 %29 to double, !dbg !55
  store double %30, double* %2, align 8, !dbg !56
  br label %31, !dbg !56

31:                                               ; preds = %28, %13
  %32 = load double, double* %2, align 8, !dbg !57
  ret double %32, !dbg !57
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @fib_main() #0 !dbg !58 {
  %1 = alloca double, align 8
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata double* %1, metadata !62, metadata !DIExpression()), !dbg !63
  %4 = bitcast double* %1 to i8*, !dbg !64
  call void @llvm.var.annotation(i8* %4, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.1.4, i32 0, i32 0), i32 26), !dbg !64
  call void @llvm.dbg.declare(metadata i32* %2, metadata !65, metadata !DIExpression()), !dbg !67
  store i32 0, i32* %2, align 4, !dbg !67
  br label %5, !dbg !68

5:                                                ; preds = %14, %0
  %6 = load i32, i32* %2, align 4, !dbg !69
  %7 = icmp slt i32 %6, 20, !dbg !71
  br i1 %7, label %8, label %17, !dbg !72

8:                                                ; preds = %5
  %9 = load i32, i32* %2, align 4, !dbg !73
  %10 = call i32 (i32, ...) bitcast (double (i32)* @fib to i32 (i32, ...)*)(i32 %9), !dbg !75
  %11 = sitofp i32 %10 to double, !dbg !75
  store double %11, double* %1, align 8, !dbg !76
  %12 = load double, double* %1, align 8, !dbg !77
  %13 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2.5, i64 0, i64 0), double %12), !dbg !78
  br label %14, !dbg !79

14:                                               ; preds = %8
  %15 = load i32, i32* %2, align 4, !dbg !80
  %16 = add nsw i32 %15, 1, !dbg !80
  store i32 %16, i32* %2, align 4, !dbg !80
  br label %5, !dbg !81, !llvm.loop !82

17:                                               ; preds = %5
  call void @llvm.dbg.declare(metadata i32* %3, metadata !84, metadata !DIExpression()), !dbg !86
  store i32 0, i32* %3, align 4, !dbg !86
  br label %18, !dbg !87

18:                                               ; preds = %27, %17
  %19 = load i32, i32* %3, align 4, !dbg !88
  %20 = icmp slt i32 %19, 30, !dbg !90
  br i1 %20, label %21, label %30, !dbg !91

21:                                               ; preds = %18
  %22 = load i32, i32* %3, align 4, !dbg !92
  %23 = call i32 (i32, ...) bitcast (double (i32)* @fib to i32 (i32, ...)*)(i32 %22), !dbg !94
  %24 = sitofp i32 %23 to double, !dbg !94
  store double %24, double* %1, align 8, !dbg !95
  %25 = load double, double* %1, align 8, !dbg !96
  %26 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2.5, i64 0, i64 0), double %25), !dbg !97
  br label %27, !dbg !98

27:                                               ; preds = %21
  %28 = load i32, i32* %3, align 4, !dbg !99
  %29 = add nsw i32 %28, 1, !dbg !99
  store i32 %29, i32* %3, align 4, !dbg !99
  br label %18, !dbg !100, !llvm.loop !101

30:                                               ; preds = %18
  ret i32 0, !dbg !103
}

declare dso_local i32 @printf(i8*, ...) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !104 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  %2 = call i32 @fib_main(), !dbg !105
  ret i32 %2, !dbg !106
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind willreturn }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!8, !12}
!llvm.ident = !{!14, !14}
!llvm.module.flags = !{!15, !16, !17}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "p", scope: !2, file: !3, line: 30, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "fib", scope: !3, file: !3, line: 25, type: !4, scopeLine: 25, spFlags: DISPFlagDefinition, unit: !8, retainedNodes: !10)
!3 = !DIFile(filename: "./divvied/orange/example2.mod.c", directory: "/home/andrew/gaps/build/apps/examples/example2")
!4 = !DISubroutineType(types: !5)
!5 = !{!6, !7}
!6 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!7 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!8 = distinct !DICompileUnit(language: DW_LANG_C99, file: !9, producer: "clang version 10.0.1 (https://github.com/llvm/llvm-project.git d24d5c8e308e689dcd83cbafd2e8bd32aa845a15)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !10, globals: !11, splitDebugInlining: false, nameTableKind: None)
!9 = !DIFile(filename: "divvied/orange/example2.mod.c", directory: "/home/andrew/gaps/build/apps/examples/example2")
!10 = !{}
!11 = !{!0}
!12 = distinct !DICompileUnit(language: DW_LANG_C99, file: !13, producer: "clang version 10.0.1 (https://github.com/llvm/llvm-project.git d24d5c8e308e689dcd83cbafd2e8bd32aa845a15)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !10, splitDebugInlining: false, nameTableKind: None)
!13 = !DIFile(filename: "divvied/purple/example2.mod.c", directory: "/home/andrew/gaps/build/apps/examples/example2")
!14 = !{!"clang version 10.0.1 (https://github.com/llvm/llvm-project.git d24d5c8e308e689dcd83cbafd2e8bd32aa845a15)"}
!15 = !{i32 7, !"Dwarf Version", i32 4}
!16 = !{i32 2, !"Debug Info Version", i32 3}
!17 = !{i32 1, !"wchar_size", i32 4}
!18 = !DILocalVariable(name: "i", arg: 1, scope: !2, file: !3, line: 25, type: !7)
!19 = !DILocation(line: 25, column: 12, scope: !2)
!20 = !DILocation(line: 33, column: 4, scope: !2)
!21 = !DILocation(line: 34, column: 7, scope: !22)
!22 = distinct !DILexicalBlock(scope: !2, file: !3, line: 34, column: 7)
!23 = !DILocation(line: 34, column: 9, scope: !22)
!24 = !DILocation(line: 34, column: 7, scope: !2)
!25 = !DILocation(line: 35, column: 5, scope: !26)
!26 = distinct !DILexicalBlock(scope: !22, file: !3, line: 34, column: 14)
!27 = !DILocalVariable(name: "one", scope: !2, file: !3, line: 37, type: !7)
!28 = !DILocation(line: 37, column: 7, scope: !2)
!29 = !DILocalVariable(name: "two", scope: !2, file: !3, line: 38, type: !7)
!30 = !DILocation(line: 38, column: 7, scope: !2)
!31 = !DILocalVariable(name: "j", scope: !32, file: !3, line: 39, type: !7)
!32 = distinct !DILexicalBlock(scope: !2, file: !3, line: 39, column: 3)
!33 = !DILocation(line: 39, column: 11, scope: !32)
!34 = !DILocation(line: 39, column: 7, scope: !32)
!35 = !DILocation(line: 39, column: 18, scope: !36)
!36 = distinct !DILexicalBlock(scope: !32, file: !3, line: 39, column: 3)
!37 = !DILocation(line: 39, column: 22, scope: !36)
!38 = !DILocation(line: 39, column: 20, scope: !36)
!39 = !DILocation(line: 39, column: 3, scope: !32)
!40 = !DILocalVariable(name: "temp", scope: !41, file: !3, line: 40, type: !7)
!41 = distinct !DILexicalBlock(scope: !36, file: !3, line: 39, column: 30)
!42 = !DILocation(line: 40, column: 9, scope: !41)
!43 = !DILocation(line: 40, column: 16, scope: !41)
!44 = !DILocation(line: 41, column: 11, scope: !41)
!45 = !DILocation(line: 41, column: 17, scope: !41)
!46 = !DILocation(line: 41, column: 15, scope: !41)
!47 = !DILocation(line: 41, column: 9, scope: !41)
!48 = !DILocation(line: 42, column: 11, scope: !41)
!49 = !DILocation(line: 42, column: 9, scope: !41)
!50 = !DILocation(line: 43, column: 3, scope: !41)
!51 = !DILocation(line: 39, column: 26, scope: !36)
!52 = !DILocation(line: 39, column: 3, scope: !36)
!53 = distinct !{!53, !39, !54}
!54 = !DILocation(line: 43, column: 3, scope: !32)
!55 = !DILocation(line: 44, column: 10, scope: !2)
!56 = !DILocation(line: 44, column: 3, scope: !2)
!57 = !DILocation(line: 45, column: 1, scope: !2)
!58 = distinct !DISubprogram(name: "fib_main", scope: !59, file: !59, line: 23, type: !60, scopeLine: 23, spFlags: DISPFlagDefinition, unit: !12, retainedNodes: !10)
!59 = !DIFile(filename: "./divvied/purple/example2.mod.c", directory: "/home/andrew/gaps/build/apps/examples/example2")
!60 = !DISubroutineType(types: !61)
!61 = !{!7}
!62 = !DILocalVariable(name: "x", scope: !58, file: !59, line: 26, type: !6)
!63 = !DILocation(line: 26, column: 10, scope: !58)
!64 = !DILocation(line: 26, column: 3, scope: !58)
!65 = !DILocalVariable(name: "i", scope: !66, file: !59, line: 29, type: !7)
!66 = distinct !DILexicalBlock(scope: !58, file: !59, line: 29, column: 3)
!67 = !DILocation(line: 29, column: 12, scope: !66)
!68 = !DILocation(line: 29, column: 8, scope: !66)
!69 = !DILocation(line: 29, column: 18, scope: !70)
!70 = distinct !DILexicalBlock(scope: !66, file: !59, line: 29, column: 3)
!71 = !DILocation(line: 29, column: 20, scope: !70)
!72 = !DILocation(line: 29, column: 3, scope: !66)
!73 = !DILocation(line: 30, column: 14, scope: !74)
!74 = distinct !DILexicalBlock(scope: !70, file: !59, line: 29, column: 31)
!75 = !DILocation(line: 30, column: 10, scope: !74)
!76 = !DILocation(line: 30, column: 8, scope: !74)
!77 = !DILocation(line: 31, column: 20, scope: !74)
!78 = !DILocation(line: 31, column: 5, scope: !74)
!79 = !DILocation(line: 32, column: 3, scope: !74)
!80 = !DILocation(line: 29, column: 27, scope: !70)
!81 = !DILocation(line: 29, column: 3, scope: !70)
!82 = distinct !{!82, !72, !83}
!83 = !DILocation(line: 32, column: 3, scope: !66)
!84 = !DILocalVariable(name: "i", scope: !85, file: !59, line: 33, type: !7)
!85 = distinct !DILexicalBlock(scope: !58, file: !59, line: 33, column: 3)
!86 = !DILocation(line: 33, column: 12, scope: !85)
!87 = !DILocation(line: 33, column: 8, scope: !85)
!88 = !DILocation(line: 33, column: 18, scope: !89)
!89 = distinct !DILexicalBlock(scope: !85, file: !59, line: 33, column: 3)
!90 = !DILocation(line: 33, column: 20, scope: !89)
!91 = !DILocation(line: 33, column: 3, scope: !85)
!92 = !DILocation(line: 34, column: 14, scope: !93)
!93 = distinct !DILexicalBlock(scope: !89, file: !59, line: 33, column: 31)
!94 = !DILocation(line: 34, column: 10, scope: !93)
!95 = !DILocation(line: 34, column: 8, scope: !93)
!96 = !DILocation(line: 35, column: 20, scope: !93)
!97 = !DILocation(line: 35, column: 5, scope: !93)
!98 = !DILocation(line: 36, column: 3, scope: !93)
!99 = !DILocation(line: 33, column: 27, scope: !89)
!100 = !DILocation(line: 33, column: 3, scope: !89)
!101 = distinct !{!101, !91, !102}
!102 = !DILocation(line: 36, column: 3, scope: !85)
!103 = !DILocation(line: 38, column: 3, scope: !58)
!104 = distinct !DISubprogram(name: "main", scope: !59, file: !59, line: 42, type: !60, scopeLine: 42, spFlags: DISPFlagDefinition, unit: !12, retainedNodes: !10)
!105 = !DILocation(line: 43, column: 10, scope: !104)
!106 = !DILocation(line: 43, column: 3, scope: !104)
