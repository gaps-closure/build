; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@llvm.global.annotations = appending global [2 x { i8*, i8*, i8*, i32 }] [{ i8*, i8*, i8*, i32 } { i8* bitcast (i32* @fib.mod to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.1, i32 0, i32 0), i32 29 }, { i8*, i8*, i8*, i32 } { i8* bitcast (double (i32)* @fib to i8*), i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.1, i32 0, i32 0), i32 24 }], section "llvm.metadata"
@fib.mod = internal global i32 100000007, align 4, !dbg !0
@.str.2 = private unnamed_addr constant [7 x i8] c"ORANGE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [32 x i8] c"./divvied/orange/example3.mod.c\00", section "llvm.metadata"
@.str = private unnamed_addr constant [16 x i8] c"XDLINKAGE_GET_A\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [7 x i8] c"PURPLE\00", section "llvm.metadata"
@.str.1.4 = private unnamed_addr constant [32 x i8] c"./divvied/purple/example3.mod.c\00", section "llvm.metadata"
@.str.2.5 = private unnamed_addr constant [7 x i8] c"%f %d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @fib(i32 %0) #0 !dbg !2 {
  %2 = alloca double, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  call void @llvm.dbg.declare(metadata i32* %3, metadata !22, metadata !DIExpression()), !dbg !23
  %8 = bitcast i32* %3 to i8*
  call void @llvm.var.annotation(i8* %8, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.1, i32 0, i32 0), i32 24)
  %9 = load i32, i32* %3, align 4, !dbg !24
  %10 = add nsw i32 %9, 1, !dbg !24
  store i32 %10, i32* %3, align 4, !dbg !24
  %11 = load i32, i32* %3, align 4, !dbg !25
  %12 = icmp slt i32 %11, 2, !dbg !27
  br i1 %12, label %13, label %14, !dbg !28

13:                                               ; preds = %1
  store double 1.000000e+00, double* %2, align 8, !dbg !29
  br label %33, !dbg !29

14:                                               ; preds = %1
  call void @llvm.dbg.declare(metadata i32* %4, metadata !31, metadata !DIExpression()), !dbg !32
  store i32 1, i32* %4, align 4, !dbg !32
  call void @llvm.dbg.declare(metadata i32* %5, metadata !33, metadata !DIExpression()), !dbg !34
  store i32 1, i32* %5, align 4, !dbg !34
  call void @llvm.dbg.declare(metadata i32* %6, metadata !35, metadata !DIExpression()), !dbg !37
  store i32 2, i32* %6, align 4, !dbg !37
  br label %15, !dbg !38

15:                                               ; preds = %27, %14
  %16 = load i32, i32* %6, align 4, !dbg !39
  %17 = load i32, i32* %3, align 4, !dbg !41
  %18 = icmp slt i32 %16, %17, !dbg !42
  br i1 %18, label %19, label %30, !dbg !43

19:                                               ; preds = %15
  call void @llvm.dbg.declare(metadata i32* %7, metadata !44, metadata !DIExpression()), !dbg !46
  %20 = load i32, i32* %4, align 4, !dbg !47
  store i32 %20, i32* %7, align 4, !dbg !46
  %21 = load i32, i32* %4, align 4, !dbg !48
  %22 = load i32, i32* %5, align 4, !dbg !49
  %23 = add nsw i32 %21, %22, !dbg !50
  %24 = load i32, i32* @fib.mod, align 4, !dbg !51
  %25 = srem i32 %23, %24, !dbg !52
  store i32 %25, i32* %4, align 4, !dbg !53
  %26 = load i32, i32* %7, align 4, !dbg !54
  store i32 %26, i32* %5, align 4, !dbg !55
  br label %27, !dbg !56

27:                                               ; preds = %19
  %28 = load i32, i32* %6, align 4, !dbg !57
  %29 = add nsw i32 %28, 1, !dbg !57
  store i32 %29, i32* %6, align 4, !dbg !57
  br label %15, !dbg !58, !llvm.loop !59

30:                                               ; preds = %15
  %31 = load i32, i32* %4, align 4, !dbg !61
  %32 = sitofp i32 %31 to double, !dbg !61
  store double %32, double* %2, align 8, !dbg !62
  br label %33, !dbg !62

33:                                               ; preds = %30, %13
  %34 = load double, double* %2, align 8, !dbg !63
  ret double %34, !dbg !63
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @fib_main() #0 !dbg !64 {
  %1 = alloca double, align 8
  %2 = alloca i32, align 4
  %3 = alloca i64, align 8
  %4 = alloca i32, align 4
  %5 = alloca i64, align 8
  %6 = alloca i32, align 4
  %7 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata double* %1, metadata !68, metadata !DIExpression()), !dbg !69
  %8 = bitcast double* %1 to i8*, !dbg !70
  call void @llvm.var.annotation(i8* %8, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.1.4, i32 0, i32 0), i32 25), !dbg !70
  call void @llvm.dbg.declare(metadata i32* %2, metadata !71, metadata !DIExpression()), !dbg !72
  store i32 0, i32* %2, align 4, !dbg !72
  call void @llvm.dbg.declare(metadata i64* %3, metadata !73, metadata !DIExpression()), !dbg !76
  %9 = call i64 @clock() #5, !dbg !77
  store i64 %9, i64* %3, align 8, !dbg !76
  call void @llvm.dbg.declare(metadata i32* %4, metadata !78, metadata !DIExpression()), !dbg !80
  store i32 0, i32* %4, align 4, !dbg !80
  br label %10, !dbg !81

10:                                               ; preds = %32, %0
  %11 = load i32, i32* %4, align 4, !dbg !82
  %12 = icmp slt i32 %11, 1000, !dbg !84
  br i1 %12, label %13, label %35, !dbg !85

13:                                               ; preds = %10
  %14 = load i32, i32* %4, align 4, !dbg !86
  %15 = call i32 (i32, ...) bitcast (double (i32)* @fib to i32 (i32, ...)*)(i32 %14), !dbg !88
  %16 = sitofp i32 %15 to double, !dbg !88
  store double %16, double* %1, align 8, !dbg !89
  %17 = load i32, i32* %4, align 4, !dbg !90
  %18 = srem i32 %17, 100, !dbg !92
  %19 = icmp eq i32 %18, 0, !dbg !93
  br i1 %19, label %20, label %31, !dbg !94

20:                                               ; preds = %13
  call void @llvm.dbg.declare(metadata i64* %5, metadata !95, metadata !DIExpression()), !dbg !97
  %21 = call i64 @clock() #5, !dbg !98
  %22 = load i64, i64* %3, align 8, !dbg !99
  %23 = sub nsw i64 %21, %22, !dbg !100
  store i64 %23, i64* %5, align 8, !dbg !97
  %24 = load i64, i64* %5, align 8, !dbg !101
  %25 = mul nsw i64 %24, 1000, !dbg !102
  %26 = sdiv i64 %25, 1000000, !dbg !103
  %27 = trunc i64 %26 to i32, !dbg !101
  store i32 %27, i32* %2, align 4, !dbg !104
  %28 = load double, double* %1, align 8, !dbg !105
  %29 = load i32, i32* %2, align 4, !dbg !106
  %30 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2.5, i64 0, i64 0), double %28, i32 %29), !dbg !107
  br label %31, !dbg !108

31:                                               ; preds = %20, %13
  br label %32, !dbg !109

32:                                               ; preds = %31
  %33 = load i32, i32* %4, align 4, !dbg !110
  %34 = add nsw i32 %33, 1, !dbg !110
  store i32 %34, i32* %4, align 4, !dbg !110
  br label %10, !dbg !111, !llvm.loop !112

35:                                               ; preds = %10
  %36 = call i64 @clock() #5, !dbg !114
  store i64 %36, i64* %3, align 8, !dbg !115
  call void @llvm.dbg.declare(metadata i32* %6, metadata !116, metadata !DIExpression()), !dbg !118
  store i32 0, i32* %6, align 4, !dbg !118
  br label %37, !dbg !119

37:                                               ; preds = %59, %35
  %38 = load i32, i32* %6, align 4, !dbg !120
  %39 = icmp slt i32 %38, 1000, !dbg !122
  br i1 %39, label %40, label %62, !dbg !123

40:                                               ; preds = %37
  %41 = load i32, i32* %6, align 4, !dbg !124
  %42 = call i32 (i32, ...) bitcast (double (i32)* @fib to i32 (i32, ...)*)(i32 %41), !dbg !126
  %43 = sitofp i32 %42 to double, !dbg !126
  store double %43, double* %1, align 8, !dbg !127
  %44 = load i32, i32* %6, align 4, !dbg !128
  %45 = srem i32 %44, 100, !dbg !130
  %46 = icmp eq i32 %45, 0, !dbg !131
  br i1 %46, label %47, label %58, !dbg !132

47:                                               ; preds = %40
  call void @llvm.dbg.declare(metadata i64* %7, metadata !133, metadata !DIExpression()), !dbg !135
  %48 = call i64 @clock() #5, !dbg !136
  %49 = load i64, i64* %3, align 8, !dbg !137
  %50 = sub nsw i64 %48, %49, !dbg !138
  store i64 %50, i64* %7, align 8, !dbg !135
  %51 = load i64, i64* %7, align 8, !dbg !139
  %52 = mul nsw i64 %51, 1000, !dbg !140
  %53 = sdiv i64 %52, 1000000, !dbg !141
  %54 = trunc i64 %53 to i32, !dbg !139
  store i32 %54, i32* %2, align 4, !dbg !142
  %55 = load double, double* %1, align 8, !dbg !143
  %56 = load i32, i32* %2, align 4, !dbg !144
  %57 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2.5, i64 0, i64 0), double %55, i32 %56), !dbg !145
  br label %58, !dbg !146

58:                                               ; preds = %47, %40
  br label %59, !dbg !147

59:                                               ; preds = %58
  %60 = load i32, i32* %6, align 4, !dbg !148
  %61 = add nsw i32 %60, 1, !dbg !148
  store i32 %61, i32* %6, align 4, !dbg !148
  br label %37, !dbg !149, !llvm.loop !150

62:                                               ; preds = %37
  ret i32 0, !dbg !152
}

; Function Attrs: nounwind
declare dso_local i64 @clock() #3

declare dso_local i32 @printf(i8*, ...) #4

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !153 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  %2 = call i32 @fib_main(), !dbg !154
  ret i32 %2, !dbg !155
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind willreturn }
attributes #3 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind }

!llvm.dbg.cu = !{!8, !12}
!llvm.ident = !{!18, !18}
!llvm.module.flags = !{!19, !20, !21}

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
!12 = distinct !DICompileUnit(language: DW_LANG_C99, file: !13, producer: "clang version 10.0.1 (https://github.com/llvm/llvm-project.git d24d5c8e308e689dcd83cbafd2e8bd32aa845a15)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !10, retainedTypes: !14, splitDebugInlining: false, nameTableKind: None)
!13 = !DIFile(filename: "divvied/purple/example3.mod.c", directory: "/home/andrew/gaps/build/apps/examples/example3")
!14 = !{!15}
!15 = !DIDerivedType(tag: DW_TAG_typedef, name: "__clock_t", file: !16, line: 156, baseType: !17)
!16 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!17 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!18 = !{!"clang version 10.0.1 (https://github.com/llvm/llvm-project.git d24d5c8e308e689dcd83cbafd2e8bd32aa845a15)"}
!19 = !{i32 7, !"Dwarf Version", i32 4}
!20 = !{i32 2, !"Debug Info Version", i32 3}
!21 = !{i32 1, !"wchar_size", i32 4}
!22 = !DILocalVariable(name: "i", arg: 1, scope: !2, file: !3, line: 24, type: !7)
!23 = !DILocation(line: 24, column: 12, scope: !2)
!24 = !DILocation(line: 32, column: 4, scope: !2)
!25 = !DILocation(line: 33, column: 7, scope: !26)
!26 = distinct !DILexicalBlock(scope: !2, file: !3, line: 33, column: 7)
!27 = !DILocation(line: 33, column: 9, scope: !26)
!28 = !DILocation(line: 33, column: 7, scope: !2)
!29 = !DILocation(line: 34, column: 5, scope: !30)
!30 = distinct !DILexicalBlock(scope: !26, file: !3, line: 33, column: 14)
!31 = !DILocalVariable(name: "one", scope: !2, file: !3, line: 36, type: !7)
!32 = !DILocation(line: 36, column: 7, scope: !2)
!33 = !DILocalVariable(name: "two", scope: !2, file: !3, line: 37, type: !7)
!34 = !DILocation(line: 37, column: 7, scope: !2)
!35 = !DILocalVariable(name: "j", scope: !36, file: !3, line: 38, type: !7)
!36 = distinct !DILexicalBlock(scope: !2, file: !3, line: 38, column: 3)
!37 = !DILocation(line: 38, column: 11, scope: !36)
!38 = !DILocation(line: 38, column: 7, scope: !36)
!39 = !DILocation(line: 38, column: 18, scope: !40)
!40 = distinct !DILexicalBlock(scope: !36, file: !3, line: 38, column: 3)
!41 = !DILocation(line: 38, column: 22, scope: !40)
!42 = !DILocation(line: 38, column: 20, scope: !40)
!43 = !DILocation(line: 38, column: 3, scope: !36)
!44 = !DILocalVariable(name: "temp", scope: !45, file: !3, line: 39, type: !7)
!45 = distinct !DILexicalBlock(scope: !40, file: !3, line: 38, column: 30)
!46 = !DILocation(line: 39, column: 9, scope: !45)
!47 = !DILocation(line: 39, column: 16, scope: !45)
!48 = !DILocation(line: 40, column: 12, scope: !45)
!49 = !DILocation(line: 40, column: 18, scope: !45)
!50 = !DILocation(line: 40, column: 16, scope: !45)
!51 = !DILocation(line: 40, column: 25, scope: !45)
!52 = !DILocation(line: 40, column: 23, scope: !45)
!53 = !DILocation(line: 40, column: 9, scope: !45)
!54 = !DILocation(line: 41, column: 11, scope: !45)
!55 = !DILocation(line: 41, column: 9, scope: !45)
!56 = !DILocation(line: 42, column: 3, scope: !45)
!57 = !DILocation(line: 38, column: 26, scope: !40)
!58 = !DILocation(line: 38, column: 3, scope: !40)
!59 = distinct !{!59, !43, !60}
!60 = !DILocation(line: 42, column: 3, scope: !36)
!61 = !DILocation(line: 43, column: 10, scope: !2)
!62 = !DILocation(line: 43, column: 3, scope: !2)
!63 = !DILocation(line: 44, column: 1, scope: !2)
!64 = distinct !DISubprogram(name: "fib_main", scope: !65, file: !65, line: 22, type: !66, scopeLine: 22, spFlags: DISPFlagDefinition, unit: !12, retainedNodes: !10)
!65 = !DIFile(filename: "./divvied/purple/example3.mod.c", directory: "/home/andrew/gaps/build/apps/examples/example3")
!66 = !DISubroutineType(types: !67)
!67 = !{!7}
!68 = !DILocalVariable(name: "x", scope: !64, file: !65, line: 25, type: !6)
!69 = !DILocation(line: 25, column: 10, scope: !64)
!70 = !DILocation(line: 25, column: 3, scope: !64)
!71 = !DILocalVariable(name: "msec", scope: !64, file: !65, line: 28, type: !7)
!72 = !DILocation(line: 28, column: 7, scope: !64)
!73 = !DILocalVariable(name: "before", scope: !64, file: !65, line: 29, type: !74)
!74 = !DIDerivedType(tag: DW_TAG_typedef, name: "clock_t", file: !75, line: 7, baseType: !15)
!75 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/clock_t.h", directory: "")
!76 = !DILocation(line: 29, column: 11, scope: !64)
!77 = !DILocation(line: 29, column: 20, scope: !64)
!78 = !DILocalVariable(name: "i", scope: !79, file: !65, line: 30, type: !7)
!79 = distinct !DILexicalBlock(scope: !64, file: !65, line: 30, column: 3)
!80 = !DILocation(line: 30, column: 12, scope: !79)
!81 = !DILocation(line: 30, column: 8, scope: !79)
!82 = !DILocation(line: 30, column: 18, scope: !83)
!83 = distinct !DILexicalBlock(scope: !79, file: !65, line: 30, column: 3)
!84 = !DILocation(line: 30, column: 20, scope: !83)
!85 = !DILocation(line: 30, column: 3, scope: !79)
!86 = !DILocation(line: 31, column: 14, scope: !87)
!87 = distinct !DILexicalBlock(scope: !83, file: !65, line: 30, column: 33)
!88 = !DILocation(line: 31, column: 10, scope: !87)
!89 = !DILocation(line: 31, column: 8, scope: !87)
!90 = !DILocation(line: 32, column: 9, scope: !91)
!91 = distinct !DILexicalBlock(scope: !87, file: !65, line: 32, column: 9)
!92 = !DILocation(line: 32, column: 11, scope: !91)
!93 = !DILocation(line: 32, column: 17, scope: !91)
!94 = !DILocation(line: 32, column: 9, scope: !87)
!95 = !DILocalVariable(name: "difference", scope: !96, file: !65, line: 33, type: !74)
!96 = distinct !DILexicalBlock(scope: !91, file: !65, line: 32, column: 23)
!97 = !DILocation(line: 33, column: 18, scope: !96)
!98 = !DILocation(line: 33, column: 31, scope: !96)
!99 = !DILocation(line: 33, column: 41, scope: !96)
!100 = !DILocation(line: 33, column: 39, scope: !96)
!101 = !DILocation(line: 34, column: 16, scope: !96)
!102 = !DILocation(line: 34, column: 27, scope: !96)
!103 = !DILocation(line: 34, column: 34, scope: !96)
!104 = !DILocation(line: 34, column: 14, scope: !96)
!105 = !DILocation(line: 35, column: 26, scope: !96)
!106 = !DILocation(line: 35, column: 29, scope: !96)
!107 = !DILocation(line: 35, column: 8, scope: !96)
!108 = !DILocation(line: 36, column: 6, scope: !96)
!109 = !DILocation(line: 37, column: 3, scope: !87)
!110 = !DILocation(line: 30, column: 29, scope: !83)
!111 = !DILocation(line: 30, column: 3, scope: !83)
!112 = distinct !{!112, !85, !113}
!113 = !DILocation(line: 37, column: 3, scope: !79)
!114 = !DILocation(line: 38, column: 12, scope: !64)
!115 = !DILocation(line: 38, column: 10, scope: !64)
!116 = !DILocalVariable(name: "i", scope: !117, file: !65, line: 39, type: !7)
!117 = distinct !DILexicalBlock(scope: !64, file: !65, line: 39, column: 3)
!118 = !DILocation(line: 39, column: 12, scope: !117)
!119 = !DILocation(line: 39, column: 8, scope: !117)
!120 = !DILocation(line: 39, column: 18, scope: !121)
!121 = distinct !DILexicalBlock(scope: !117, file: !65, line: 39, column: 3)
!122 = !DILocation(line: 39, column: 20, scope: !121)
!123 = !DILocation(line: 39, column: 3, scope: !117)
!124 = !DILocation(line: 40, column: 14, scope: !125)
!125 = distinct !DILexicalBlock(scope: !121, file: !65, line: 39, column: 33)
!126 = !DILocation(line: 40, column: 10, scope: !125)
!127 = !DILocation(line: 40, column: 8, scope: !125)
!128 = !DILocation(line: 41, column: 9, scope: !129)
!129 = distinct !DILexicalBlock(scope: !125, file: !65, line: 41, column: 9)
!130 = !DILocation(line: 41, column: 11, scope: !129)
!131 = !DILocation(line: 41, column: 17, scope: !129)
!132 = !DILocation(line: 41, column: 9, scope: !125)
!133 = !DILocalVariable(name: "difference", scope: !134, file: !65, line: 42, type: !74)
!134 = distinct !DILexicalBlock(scope: !129, file: !65, line: 41, column: 23)
!135 = !DILocation(line: 42, column: 18, scope: !134)
!136 = !DILocation(line: 42, column: 31, scope: !134)
!137 = !DILocation(line: 42, column: 41, scope: !134)
!138 = !DILocation(line: 42, column: 39, scope: !134)
!139 = !DILocation(line: 43, column: 16, scope: !134)
!140 = !DILocation(line: 43, column: 27, scope: !134)
!141 = !DILocation(line: 43, column: 34, scope: !134)
!142 = !DILocation(line: 43, column: 14, scope: !134)
!143 = !DILocation(line: 44, column: 26, scope: !134)
!144 = !DILocation(line: 44, column: 29, scope: !134)
!145 = !DILocation(line: 44, column: 8, scope: !134)
!146 = !DILocation(line: 45, column: 6, scope: !134)
!147 = !DILocation(line: 46, column: 3, scope: !125)
!148 = !DILocation(line: 39, column: 29, scope: !121)
!149 = !DILocation(line: 39, column: 3, scope: !121)
!150 = distinct !{!150, !123, !151}
!151 = !DILocation(line: 46, column: 3, scope: !117)
!152 = !DILocation(line: 48, column: 3, scope: !64)
!153 = distinct !DISubprogram(name: "main", scope: !65, file: !65, line: 53, type: !66, scopeLine: 53, spFlags: DISPFlagDefinition, unit: !12, retainedNodes: !10)
!154 = !DILocation(line: 54, column: 10, scope: !153)
!155 = !DILocation(line: 54, column: 3, scope: !153)
