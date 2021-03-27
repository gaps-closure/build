; ModuleID = './divvied/orange/cache.mod.c'
source_filename = "./divvied/orange/cache.mod.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@fib.i = internal global double 2.000000e+00, align 8, !dbg !0
@.str = private unnamed_addr constant [7 x i8] c"ORANGE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [29 x i8] c"./divvied/orange/cache.mod.c\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [16 x i8] c"XDLINKAGE_GET_A\00", section "llvm.metadata"
@llvm.global.annotations = appending global [2 x { i8*, i8*, i8*, i32 }] [{ i8*, i8*, i8*, i32 } { i8* bitcast (double* @fib.i to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([29 x i8], [29 x i8]* @.str.1, i32 0, i32 0), i32 30 }, { i8*, i8*, i8*, i32 } { i8* bitcast (double ()* @fib to i8*), i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([29 x i8], [29 x i8]* @.str.1, i32 0, i32 0), i32 25 }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @fib() #0 !dbg !2 {
  %1 = alloca double, align 8
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = load double, double* @fib.i, align 8, !dbg !15
  %7 = fadd double %6, 1.000000e+00, !dbg !15
  store double %7, double* @fib.i, align 8, !dbg !15
  %8 = load double, double* @fib.i, align 8, !dbg !16
  %9 = fcmp olt double %8, 2.000000e+00, !dbg !18
  br i1 %9, label %10, label %11, !dbg !19

10:                                               ; preds = %0
  store double 1.000000e+00, double* %1, align 8, !dbg !20
  br label %29, !dbg !20

11:                                               ; preds = %0
  call void @llvm.dbg.declare(metadata i32* %2, metadata !22, metadata !DIExpression()), !dbg !24
  store i32 1, i32* %2, align 4, !dbg !24
  call void @llvm.dbg.declare(metadata i32* %3, metadata !25, metadata !DIExpression()), !dbg !26
  store i32 1, i32* %3, align 4, !dbg !26
  call void @llvm.dbg.declare(metadata i32* %4, metadata !27, metadata !DIExpression()), !dbg !29
  store i32 2, i32* %4, align 4, !dbg !29
  br label %12, !dbg !30

12:                                               ; preds = %23, %11
  %13 = load i32, i32* %4, align 4, !dbg !31
  %14 = sitofp i32 %13 to double, !dbg !31
  %15 = load double, double* @fib.i, align 8, !dbg !33
  %16 = fcmp olt double %14, %15, !dbg !34
  br i1 %16, label %17, label %26, !dbg !35

17:                                               ; preds = %12
  call void @llvm.dbg.declare(metadata i32* %5, metadata !36, metadata !DIExpression()), !dbg !38
  %18 = load i32, i32* %2, align 4, !dbg !39
  store i32 %18, i32* %5, align 4, !dbg !38
  %19 = load i32, i32* %2, align 4, !dbg !40
  %20 = load i32, i32* %3, align 4, !dbg !41
  %21 = add nsw i32 %19, %20, !dbg !42
  store i32 %21, i32* %2, align 4, !dbg !43
  %22 = load i32, i32* %5, align 4, !dbg !44
  store i32 %22, i32* %3, align 4, !dbg !45
  br label %23, !dbg !46

23:                                               ; preds = %17
  %24 = load i32, i32* %4, align 4, !dbg !47
  %25 = add nsw i32 %24, 1, !dbg !47
  store i32 %25, i32* %4, align 4, !dbg !47
  br label %12, !dbg !48, !llvm.loop !49

26:                                               ; preds = %12
  %27 = load i32, i32* %2, align 4, !dbg !51
  %28 = sitofp i32 %27 to double, !dbg !51
  store double %28, double* %1, align 8, !dbg !52
  br label %29, !dbg !52

29:                                               ; preds = %26, %10
  %30 = load double, double* %1, align 8, !dbg !53
  ret double %30, !dbg !53
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }

!llvm.dbg.cu = !{!7}
!llvm.module.flags = !{!11, !12, !13}
!llvm.ident = !{!14}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "i", scope: !2, file: !3, line: 30, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "fib", scope: !3, file: !3, line: 25, type: !4, scopeLine: 25, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !9)
!3 = !DIFile(filename: "./divvied/orange/cache.mod.c", directory: "/home/andrew/gaps/build/apps/examples/cache")
!4 = !DISubroutineType(types: !5)
!5 = !{!6}
!6 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !8, producer: "clang version 10.0.1 (https://github.com/llvm/llvm-project.git d24d5c8e308e689dcd83cbafd2e8bd32aa845a15)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !9, globals: !10, splitDebugInlining: false, nameTableKind: None)
!8 = !DIFile(filename: "divvied/orange/cache.mod.c", directory: "/home/andrew/gaps/build/apps/examples/cache")
!9 = !{}
!10 = !{!0}
!11 = !{i32 7, !"Dwarf Version", i32 4}
!12 = !{i32 2, !"Debug Info Version", i32 3}
!13 = !{i32 1, !"wchar_size", i32 4}
!14 = !{!"clang version 10.0.1 (https://github.com/llvm/llvm-project.git d24d5c8e308e689dcd83cbafd2e8bd32aa845a15)"}
!15 = !DILocation(line: 33, column: 4, scope: !2)
!16 = !DILocation(line: 34, column: 7, scope: !17)
!17 = distinct !DILexicalBlock(scope: !2, file: !3, line: 34, column: 7)
!18 = !DILocation(line: 34, column: 9, scope: !17)
!19 = !DILocation(line: 34, column: 7, scope: !2)
!20 = !DILocation(line: 35, column: 5, scope: !21)
!21 = distinct !DILexicalBlock(scope: !17, file: !3, line: 34, column: 14)
!22 = !DILocalVariable(name: "one", scope: !2, file: !3, line: 37, type: !23)
!23 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!24 = !DILocation(line: 37, column: 7, scope: !2)
!25 = !DILocalVariable(name: "two", scope: !2, file: !3, line: 38, type: !23)
!26 = !DILocation(line: 38, column: 7, scope: !2)
!27 = !DILocalVariable(name: "j", scope: !28, file: !3, line: 39, type: !23)
!28 = distinct !DILexicalBlock(scope: !2, file: !3, line: 39, column: 3)
!29 = !DILocation(line: 39, column: 11, scope: !28)
!30 = !DILocation(line: 39, column: 7, scope: !28)
!31 = !DILocation(line: 39, column: 18, scope: !32)
!32 = distinct !DILexicalBlock(scope: !28, file: !3, line: 39, column: 3)
!33 = !DILocation(line: 39, column: 22, scope: !32)
!34 = !DILocation(line: 39, column: 20, scope: !32)
!35 = !DILocation(line: 39, column: 3, scope: !28)
!36 = !DILocalVariable(name: "temp", scope: !37, file: !3, line: 40, type: !23)
!37 = distinct !DILexicalBlock(scope: !32, file: !3, line: 39, column: 30)
!38 = !DILocation(line: 40, column: 9, scope: !37)
!39 = !DILocation(line: 40, column: 16, scope: !37)
!40 = !DILocation(line: 41, column: 11, scope: !37)
!41 = !DILocation(line: 41, column: 17, scope: !37)
!42 = !DILocation(line: 41, column: 15, scope: !37)
!43 = !DILocation(line: 41, column: 9, scope: !37)
!44 = !DILocation(line: 42, column: 11, scope: !37)
!45 = !DILocation(line: 42, column: 9, scope: !37)
!46 = !DILocation(line: 43, column: 3, scope: !37)
!47 = !DILocation(line: 39, column: 26, scope: !32)
!48 = !DILocation(line: 39, column: 3, scope: !32)
!49 = distinct !{!49, !35, !50}
!50 = !DILocation(line: 43, column: 3, scope: !28)
!51 = !DILocation(line: 44, column: 10, scope: !2)
!52 = !DILocation(line: 44, column: 3, scope: !2)
!53 = !DILocation(line: 45, column: 1, scope: !2)
