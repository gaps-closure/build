; ModuleID = './divvied/orange/example3.mod.c'
source_filename = "./divvied/orange/example3.mod.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [16 x i8] c"XDLINKAGE_GET_A\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [32 x i8] c"./divvied/orange/example3.mod.c\00", section "llvm.metadata"
@fib.mod = internal global i32 100000007, align 4, !dbg !0
@.str.2 = private unnamed_addr constant [7 x i8] c"ORANGE\00", section "llvm.metadata"
@llvm.global.annotations = appending global [2 x { i8*, i8*, i8*, i32 }] [{ i8*, i8*, i8*, i32 } { i8* bitcast (i32* @fib.mod to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.1, i32 0, i32 0), i32 29 }, { i8*, i8*, i8*, i32 } { i8* bitcast (double (i32)* @fib to i8*), i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.1, i32 0, i32 0), i32 24 }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @fib(i32 %0) #0 !dbg !2 {
  %2 = alloca double, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  call void @llvm.dbg.declare(metadata i32* %3, metadata !16, metadata !DIExpression()), !dbg !17
  %8 = bitcast i32* %3 to i8*
  call void @llvm.var.annotation(i8* %8, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.1, i32 0, i32 0), i32 24)
  %9 = load i32, i32* %3, align 4, !dbg !18
  %10 = add nsw i32 %9, 1, !dbg !18
  store i32 %10, i32* %3, align 4, !dbg !18
  %11 = load i32, i32* %3, align 4, !dbg !19
  %12 = icmp slt i32 %11, 2, !dbg !21
  br i1 %12, label %13, label %14, !dbg !22

13:                                               ; preds = %1
  store double 1.000000e+00, double* %2, align 8, !dbg !23
  br label %33, !dbg !23

14:                                               ; preds = %1
  call void @llvm.dbg.declare(metadata i32* %4, metadata !25, metadata !DIExpression()), !dbg !26
  store i32 1, i32* %4, align 4, !dbg !26
  call void @llvm.dbg.declare(metadata i32* %5, metadata !27, metadata !DIExpression()), !dbg !28
  store i32 1, i32* %5, align 4, !dbg !28
  call void @llvm.dbg.declare(metadata i32* %6, metadata !29, metadata !DIExpression()), !dbg !31
  store i32 2, i32* %6, align 4, !dbg !31
  br label %15, !dbg !32

15:                                               ; preds = %27, %14
  %16 = load i32, i32* %6, align 4, !dbg !33
  %17 = load i32, i32* %3, align 4, !dbg !35
  %18 = icmp slt i32 %16, %17, !dbg !36
  br i1 %18, label %19, label %30, !dbg !37

19:                                               ; preds = %15
  call void @llvm.dbg.declare(metadata i32* %7, metadata !38, metadata !DIExpression()), !dbg !40
  %20 = load i32, i32* %4, align 4, !dbg !41
  store i32 %20, i32* %7, align 4, !dbg !40
  %21 = load i32, i32* %4, align 4, !dbg !42
  %22 = load i32, i32* %5, align 4, !dbg !43
  %23 = add nsw i32 %21, %22, !dbg !44
  %24 = load i32, i32* @fib.mod, align 4, !dbg !45
  %25 = srem i32 %23, %24, !dbg !46
  store i32 %25, i32* %4, align 4, !dbg !47
  %26 = load i32, i32* %7, align 4, !dbg !48
  store i32 %26, i32* %5, align 4, !dbg !49
  br label %27, !dbg !50

27:                                               ; preds = %19
  %28 = load i32, i32* %6, align 4, !dbg !51
  %29 = add nsw i32 %28, 1, !dbg !51
  store i32 %29, i32* %6, align 4, !dbg !51
  br label %15, !dbg !52, !llvm.loop !53

30:                                               ; preds = %15
  %31 = load i32, i32* %4, align 4, !dbg !55
  %32 = sitofp i32 %31 to double, !dbg !55
  store double %32, double* %2, align 8, !dbg !56
  br label %33, !dbg !56

33:                                               ; preds = %30, %13
  %34 = load double, double* %2, align 8, !dbg !57
  ret double %34, !dbg !57
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind willreturn }

!llvm.dbg.cu = !{!8}
!llvm.module.flags = !{!12, !13, !14}
!llvm.ident = !{!15}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "mod", scope: !2, file: !3, line: 29, type: !7, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "fib", scope: !3, file: !3, line: 24, type: !4, scopeLine: 24, spFlags: DISPFlagDefinition, unit: !8, retainedNodes: !10)
!3 = !DIFile(filename: "./divvied/orange/example3.mod.c", directory: "/home/andrew/gaps/build/apps/examples/example3")
!4 = !DISubroutineType(types: !5)
!5 = !{!6, !7}
!6 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!7 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!8 = distinct !DICompileUnit(language: DW_LANG_C99, file: !9, producer: "clang version 10.0.1 (https://github.com/llvm/llvm-project.git d24d5c8e308e689dcd83cbafd2e8bd32aa845a15)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !10, globals: !11, splitDebugInlining: false, nameTableKind: None)
!9 = !DIFile(filename: "divvied/orange/example3.mod.c", directory: "/home/andrew/gaps/build/apps/examples/example3")
!10 = !{}
!11 = !{!0}
!12 = !{i32 7, !"Dwarf Version", i32 4}
!13 = !{i32 2, !"Debug Info Version", i32 3}
!14 = !{i32 1, !"wchar_size", i32 4}
!15 = !{!"clang version 10.0.1 (https://github.com/llvm/llvm-project.git d24d5c8e308e689dcd83cbafd2e8bd32aa845a15)"}
!16 = !DILocalVariable(name: "i", arg: 1, scope: !2, file: !3, line: 24, type: !7)
!17 = !DILocation(line: 24, column: 12, scope: !2)
!18 = !DILocation(line: 32, column: 4, scope: !2)
!19 = !DILocation(line: 33, column: 7, scope: !20)
!20 = distinct !DILexicalBlock(scope: !2, file: !3, line: 33, column: 7)
!21 = !DILocation(line: 33, column: 9, scope: !20)
!22 = !DILocation(line: 33, column: 7, scope: !2)
!23 = !DILocation(line: 34, column: 5, scope: !24)
!24 = distinct !DILexicalBlock(scope: !20, file: !3, line: 33, column: 14)
!25 = !DILocalVariable(name: "one", scope: !2, file: !3, line: 36, type: !7)
!26 = !DILocation(line: 36, column: 7, scope: !2)
!27 = !DILocalVariable(name: "two", scope: !2, file: !3, line: 37, type: !7)
!28 = !DILocation(line: 37, column: 7, scope: !2)
!29 = !DILocalVariable(name: "j", scope: !30, file: !3, line: 38, type: !7)
!30 = distinct !DILexicalBlock(scope: !2, file: !3, line: 38, column: 3)
!31 = !DILocation(line: 38, column: 11, scope: !30)
!32 = !DILocation(line: 38, column: 7, scope: !30)
!33 = !DILocation(line: 38, column: 18, scope: !34)
!34 = distinct !DILexicalBlock(scope: !30, file: !3, line: 38, column: 3)
!35 = !DILocation(line: 38, column: 22, scope: !34)
!36 = !DILocation(line: 38, column: 20, scope: !34)
!37 = !DILocation(line: 38, column: 3, scope: !30)
!38 = !DILocalVariable(name: "temp", scope: !39, file: !3, line: 39, type: !7)
!39 = distinct !DILexicalBlock(scope: !34, file: !3, line: 38, column: 30)
!40 = !DILocation(line: 39, column: 9, scope: !39)
!41 = !DILocation(line: 39, column: 16, scope: !39)
!42 = !DILocation(line: 40, column: 12, scope: !39)
!43 = !DILocation(line: 40, column: 18, scope: !39)
!44 = !DILocation(line: 40, column: 16, scope: !39)
!45 = !DILocation(line: 40, column: 25, scope: !39)
!46 = !DILocation(line: 40, column: 23, scope: !39)
!47 = !DILocation(line: 40, column: 9, scope: !39)
!48 = !DILocation(line: 41, column: 11, scope: !39)
!49 = !DILocation(line: 41, column: 9, scope: !39)
!50 = !DILocation(line: 42, column: 3, scope: !39)
!51 = !DILocation(line: 38, column: 26, scope: !34)
!52 = !DILocation(line: 38, column: 3, scope: !34)
!53 = distinct !{!53, !37, !54}
!54 = !DILocation(line: 42, column: 3, scope: !30)
!55 = !DILocation(line: 43, column: 10, scope: !2)
!56 = !DILocation(line: 43, column: 3, scope: !2)
!57 = !DILocation(line: 44, column: 1, scope: !2)
