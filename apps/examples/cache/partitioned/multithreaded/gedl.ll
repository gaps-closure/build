; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@llvm.global.annotations = appending global [2 x { i8*, i8*, i8*, i32 }] [{ i8*, i8*, i8*, i32 } { i8* bitcast (double* @fib.i to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([29 x i8], [29 x i8]* @.str.1, i32 0, i32 0), i32 30 }, { i8*, i8*, i8*, i32 } { i8* bitcast (double ()* @fib to i8*), i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([29 x i8], [29 x i8]* @.str.1, i32 0, i32 0), i32 25 }], section "llvm.metadata"
@fib.i = internal global double 2.000000e+00, align 8, !dbg !0
@.str = private unnamed_addr constant [7 x i8] c"ORANGE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [29 x i8] c"./divvied/orange/cache.mod.c\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [16 x i8] c"XDLINKAGE_GET_A\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [7 x i8] c"PURPLE\00", section "llvm.metadata"
@.str.1.4 = private unnamed_addr constant [29 x i8] c"./divvied/purple/cache.mod.c\00", section "llvm.metadata"
@.str.2.5 = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @fib() #0 !dbg !2 {
  %1 = alloca double, align 8
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = load double, double* @fib.i, align 8, !dbg !17
  %7 = fadd double %6, 1.000000e+00, !dbg !17
  store double %7, double* @fib.i, align 8, !dbg !17
  %8 = load double, double* @fib.i, align 8, !dbg !18
  %9 = fcmp olt double %8, 2.000000e+00, !dbg !20
  br i1 %9, label %10, label %11, !dbg !21

10:                                               ; preds = %0
  store double 1.000000e+00, double* %1, align 8, !dbg !22
  br label %29, !dbg !22

11:                                               ; preds = %0
  call void @llvm.dbg.declare(metadata i32* %2, metadata !24, metadata !DIExpression()), !dbg !26
  store i32 1, i32* %2, align 4, !dbg !26
  call void @llvm.dbg.declare(metadata i32* %3, metadata !27, metadata !DIExpression()), !dbg !28
  store i32 1, i32* %3, align 4, !dbg !28
  call void @llvm.dbg.declare(metadata i32* %4, metadata !29, metadata !DIExpression()), !dbg !31
  store i32 2, i32* %4, align 4, !dbg !31
  br label %12, !dbg !32

12:                                               ; preds = %23, %11
  %13 = load i32, i32* %4, align 4, !dbg !33
  %14 = sitofp i32 %13 to double, !dbg !33
  %15 = load double, double* @fib.i, align 8, !dbg !35
  %16 = fcmp olt double %14, %15, !dbg !36
  br i1 %16, label %17, label %26, !dbg !37

17:                                               ; preds = %12
  call void @llvm.dbg.declare(metadata i32* %5, metadata !38, metadata !DIExpression()), !dbg !40
  %18 = load i32, i32* %2, align 4, !dbg !41
  store i32 %18, i32* %5, align 4, !dbg !40
  %19 = load i32, i32* %2, align 4, !dbg !42
  %20 = load i32, i32* %3, align 4, !dbg !43
  %21 = add nsw i32 %19, %20, !dbg !44
  store i32 %21, i32* %2, align 4, !dbg !45
  %22 = load i32, i32* %5, align 4, !dbg !46
  store i32 %22, i32* %3, align 4, !dbg !47
  br label %23, !dbg !48

23:                                               ; preds = %17
  %24 = load i32, i32* %4, align 4, !dbg !49
  %25 = add nsw i32 %24, 1, !dbg !49
  store i32 %25, i32* %4, align 4, !dbg !49
  br label %12, !dbg !50, !llvm.loop !51

26:                                               ; preds = %12
  %27 = load i32, i32* %2, align 4, !dbg !53
  %28 = sitofp i32 %27 to double, !dbg !53
  store double %28, double* %1, align 8, !dbg !54
  br label %29, !dbg !54

29:                                               ; preds = %26, %10
  %30 = load double, double* %1, align 8, !dbg !55
  ret double %30, !dbg !55
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @fib_main() #0 !dbg !56 {
  %1 = alloca double, align 8
  %2 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata double* %1, metadata !60, metadata !DIExpression()), !dbg !61
  %3 = bitcast double* %1 to i8*, !dbg !62
  call void @llvm.var.annotation(i8* %3, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([29 x i8], [29 x i8]* @.str.1.4, i32 0, i32 0), i32 26), !dbg !62
  call void @llvm.dbg.declare(metadata i32* %2, metadata !63, metadata !DIExpression()), !dbg !65
  store i32 0, i32* %2, align 4, !dbg !65
  br label %4, !dbg !66

4:                                                ; preds = %12, %0
  %5 = load i32, i32* %2, align 4, !dbg !67
  %6 = icmp slt i32 %5, 10, !dbg !69
  br i1 %6, label %7, label %15, !dbg !70

7:                                                ; preds = %4
  %8 = call i32 (...) bitcast (double ()* @fib to i32 (...)*)(), !dbg !71
  %9 = sitofp i32 %8 to double, !dbg !71
  store double %9, double* %1, align 8, !dbg !73
  %10 = load double, double* %1, align 8, !dbg !74
  %11 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2.5, i64 0, i64 0), double %10), !dbg !75
  br label %12, !dbg !76

12:                                               ; preds = %7
  %13 = load i32, i32* %2, align 4, !dbg !77
  %14 = add nsw i32 %13, 1, !dbg !77
  store i32 %14, i32* %2, align 4, !dbg !77
  br label %4, !dbg !78, !llvm.loop !79

15:                                               ; preds = %4
  ret i32 0, !dbg !81
}

; Function Attrs: nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #2

declare dso_local i32 @printf(i8*, ...) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !82 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  %2 = call i32 @fib_main(), !dbg !83
  ret i32 %2, !dbg !84
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind willreturn }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!7, !11}
!llvm.ident = !{!13, !13}
!llvm.module.flags = !{!14, !15, !16}

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
!11 = distinct !DICompileUnit(language: DW_LANG_C99, file: !12, producer: "clang version 10.0.1 (https://github.com/llvm/llvm-project.git d24d5c8e308e689dcd83cbafd2e8bd32aa845a15)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !9, splitDebugInlining: false, nameTableKind: None)
!12 = !DIFile(filename: "divvied/purple/cache.mod.c", directory: "/home/andrew/gaps/build/apps/examples/cache")
!13 = !{!"clang version 10.0.1 (https://github.com/llvm/llvm-project.git d24d5c8e308e689dcd83cbafd2e8bd32aa845a15)"}
!14 = !{i32 7, !"Dwarf Version", i32 4}
!15 = !{i32 2, !"Debug Info Version", i32 3}
!16 = !{i32 1, !"wchar_size", i32 4}
!17 = !DILocation(line: 33, column: 4, scope: !2)
!18 = !DILocation(line: 34, column: 7, scope: !19)
!19 = distinct !DILexicalBlock(scope: !2, file: !3, line: 34, column: 7)
!20 = !DILocation(line: 34, column: 9, scope: !19)
!21 = !DILocation(line: 34, column: 7, scope: !2)
!22 = !DILocation(line: 35, column: 5, scope: !23)
!23 = distinct !DILexicalBlock(scope: !19, file: !3, line: 34, column: 14)
!24 = !DILocalVariable(name: "one", scope: !2, file: !3, line: 37, type: !25)
!25 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!26 = !DILocation(line: 37, column: 7, scope: !2)
!27 = !DILocalVariable(name: "two", scope: !2, file: !3, line: 38, type: !25)
!28 = !DILocation(line: 38, column: 7, scope: !2)
!29 = !DILocalVariable(name: "j", scope: !30, file: !3, line: 39, type: !25)
!30 = distinct !DILexicalBlock(scope: !2, file: !3, line: 39, column: 3)
!31 = !DILocation(line: 39, column: 11, scope: !30)
!32 = !DILocation(line: 39, column: 7, scope: !30)
!33 = !DILocation(line: 39, column: 18, scope: !34)
!34 = distinct !DILexicalBlock(scope: !30, file: !3, line: 39, column: 3)
!35 = !DILocation(line: 39, column: 22, scope: !34)
!36 = !DILocation(line: 39, column: 20, scope: !34)
!37 = !DILocation(line: 39, column: 3, scope: !30)
!38 = !DILocalVariable(name: "temp", scope: !39, file: !3, line: 40, type: !25)
!39 = distinct !DILexicalBlock(scope: !34, file: !3, line: 39, column: 30)
!40 = !DILocation(line: 40, column: 9, scope: !39)
!41 = !DILocation(line: 40, column: 16, scope: !39)
!42 = !DILocation(line: 41, column: 11, scope: !39)
!43 = !DILocation(line: 41, column: 17, scope: !39)
!44 = !DILocation(line: 41, column: 15, scope: !39)
!45 = !DILocation(line: 41, column: 9, scope: !39)
!46 = !DILocation(line: 42, column: 11, scope: !39)
!47 = !DILocation(line: 42, column: 9, scope: !39)
!48 = !DILocation(line: 43, column: 3, scope: !39)
!49 = !DILocation(line: 39, column: 26, scope: !34)
!50 = !DILocation(line: 39, column: 3, scope: !34)
!51 = distinct !{!51, !37, !52}
!52 = !DILocation(line: 43, column: 3, scope: !30)
!53 = !DILocation(line: 44, column: 10, scope: !2)
!54 = !DILocation(line: 44, column: 3, scope: !2)
!55 = !DILocation(line: 45, column: 1, scope: !2)
!56 = distinct !DISubprogram(name: "fib_main", scope: !57, file: !57, line: 23, type: !58, scopeLine: 23, spFlags: DISPFlagDefinition, unit: !11, retainedNodes: !9)
!57 = !DIFile(filename: "./divvied/purple/cache.mod.c", directory: "/home/andrew/gaps/build/apps/examples/cache")
!58 = !DISubroutineType(types: !59)
!59 = !{!25}
!60 = !DILocalVariable(name: "x", scope: !56, file: !57, line: 26, type: !6)
!61 = !DILocation(line: 26, column: 10, scope: !56)
!62 = !DILocation(line: 26, column: 3, scope: !56)
!63 = !DILocalVariable(name: "i", scope: !64, file: !57, line: 29, type: !25)
!64 = distinct !DILexicalBlock(scope: !56, file: !57, line: 29, column: 3)
!65 = !DILocation(line: 29, column: 12, scope: !64)
!66 = !DILocation(line: 29, column: 8, scope: !64)
!67 = !DILocation(line: 29, column: 17, scope: !68)
!68 = distinct !DILexicalBlock(scope: !64, file: !57, line: 29, column: 3)
!69 = !DILocation(line: 29, column: 19, scope: !68)
!70 = !DILocation(line: 29, column: 3, scope: !64)
!71 = !DILocation(line: 30, column: 10, scope: !72)
!72 = distinct !DILexicalBlock(scope: !68, file: !57, line: 29, column: 30)
!73 = !DILocation(line: 30, column: 8, scope: !72)
!74 = !DILocation(line: 31, column: 20, scope: !72)
!75 = !DILocation(line: 31, column: 5, scope: !72)
!76 = !DILocation(line: 32, column: 3, scope: !72)
!77 = !DILocation(line: 29, column: 26, scope: !68)
!78 = !DILocation(line: 29, column: 3, scope: !68)
!79 = distinct !{!79, !70, !80}
!80 = !DILocation(line: 32, column: 3, scope: !64)
!81 = !DILocation(line: 33, column: 3, scope: !56)
!82 = distinct !DISubprogram(name: "main", scope: !57, file: !57, line: 37, type: !58, scopeLine: 37, spFlags: DISPFlagDefinition, unit: !11, retainedNodes: !9)
!83 = !DILocation(line: 38, column: 10, scope: !82)
!84 = !DILocation(line: 38, column: 3, scope: !82)
