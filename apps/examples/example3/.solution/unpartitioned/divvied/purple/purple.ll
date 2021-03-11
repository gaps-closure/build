; ModuleID = './divvied/purple/example3.mod.c'
source_filename = "./divvied/purple/example3.mod.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [7 x i8] c"PURPLE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [32 x i8] c"./divvied/purple/example3.mod.c\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [7 x i8] c"%f %d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @fib_main() #0 !dbg !11 {
  %1 = alloca double, align 8
  %2 = alloca i32, align 4
  %3 = alloca i64, align 8
  %4 = alloca i32, align 4
  %5 = alloca i64, align 8
  %6 = alloca i32, align 4
  %7 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata double* %1, metadata !16, metadata !DIExpression()), !dbg !18
  %8 = bitcast double* %1 to i8*, !dbg !19
  call void @llvm.var.annotation(i8* %8, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.1, i32 0, i32 0), i32 25), !dbg !19
  call void @llvm.dbg.declare(metadata i32* %2, metadata !20, metadata !DIExpression()), !dbg !21
  store i32 0, i32* %2, align 4, !dbg !21
  call void @llvm.dbg.declare(metadata i64* %3, metadata !22, metadata !DIExpression()), !dbg !25
  %9 = call i64 @clock() #5, !dbg !26
  store i64 %9, i64* %3, align 8, !dbg !25
  call void @llvm.dbg.declare(metadata i32* %4, metadata !27, metadata !DIExpression()), !dbg !29
  store i32 0, i32* %4, align 4, !dbg !29
  br label %10, !dbg !30

10:                                               ; preds = %32, %0
  %11 = load i32, i32* %4, align 4, !dbg !31
  %12 = icmp slt i32 %11, 1000, !dbg !33
  br i1 %12, label %13, label %35, !dbg !34

13:                                               ; preds = %10
  %14 = load i32, i32* %4, align 4, !dbg !35
  %15 = call i32 (i32, ...) bitcast (i32 (...)* @fib to i32 (i32, ...)*)(i32 %14), !dbg !37
  %16 = sitofp i32 %15 to double, !dbg !37
  store double %16, double* %1, align 8, !dbg !38
  %17 = load i32, i32* %4, align 4, !dbg !39
  %18 = srem i32 %17, 100, !dbg !41
  %19 = icmp eq i32 %18, 0, !dbg !42
  br i1 %19, label %20, label %31, !dbg !43

20:                                               ; preds = %13
  call void @llvm.dbg.declare(metadata i64* %5, metadata !44, metadata !DIExpression()), !dbg !46
  %21 = call i64 @clock() #5, !dbg !47
  %22 = load i64, i64* %3, align 8, !dbg !48
  %23 = sub nsw i64 %21, %22, !dbg !49
  store i64 %23, i64* %5, align 8, !dbg !46
  %24 = load i64, i64* %5, align 8, !dbg !50
  %25 = mul nsw i64 %24, 1000, !dbg !51
  %26 = sdiv i64 %25, 1000000, !dbg !52
  %27 = trunc i64 %26 to i32, !dbg !50
  store i32 %27, i32* %2, align 4, !dbg !53
  %28 = load double, double* %1, align 8, !dbg !54
  %29 = load i32, i32* %2, align 4, !dbg !55
  %30 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i64 0, i64 0), double %28, i32 %29), !dbg !56
  br label %31, !dbg !57

31:                                               ; preds = %20, %13
  br label %32, !dbg !58

32:                                               ; preds = %31
  %33 = load i32, i32* %4, align 4, !dbg !59
  %34 = add nsw i32 %33, 1, !dbg !59
  store i32 %34, i32* %4, align 4, !dbg !59
  br label %10, !dbg !60, !llvm.loop !61

35:                                               ; preds = %10
  %36 = call i64 @clock() #5, !dbg !63
  store i64 %36, i64* %3, align 8, !dbg !64
  call void @llvm.dbg.declare(metadata i32* %6, metadata !65, metadata !DIExpression()), !dbg !67
  store i32 0, i32* %6, align 4, !dbg !67
  br label %37, !dbg !68

37:                                               ; preds = %59, %35
  %38 = load i32, i32* %6, align 4, !dbg !69
  %39 = icmp slt i32 %38, 1000, !dbg !71
  br i1 %39, label %40, label %62, !dbg !72

40:                                               ; preds = %37
  %41 = load i32, i32* %6, align 4, !dbg !73
  %42 = call i32 (i32, ...) bitcast (i32 (...)* @fib to i32 (i32, ...)*)(i32 %41), !dbg !75
  %43 = sitofp i32 %42 to double, !dbg !75
  store double %43, double* %1, align 8, !dbg !76
  %44 = load i32, i32* %6, align 4, !dbg !77
  %45 = srem i32 %44, 100, !dbg !79
  %46 = icmp eq i32 %45, 0, !dbg !80
  br i1 %46, label %47, label %58, !dbg !81

47:                                               ; preds = %40
  call void @llvm.dbg.declare(metadata i64* %7, metadata !82, metadata !DIExpression()), !dbg !84
  %48 = call i64 @clock() #5, !dbg !85
  %49 = load i64, i64* %3, align 8, !dbg !86
  %50 = sub nsw i64 %48, %49, !dbg !87
  store i64 %50, i64* %7, align 8, !dbg !84
  %51 = load i64, i64* %7, align 8, !dbg !88
  %52 = mul nsw i64 %51, 1000, !dbg !89
  %53 = sdiv i64 %52, 1000000, !dbg !90
  %54 = trunc i64 %53 to i32, !dbg !88
  store i32 %54, i32* %2, align 4, !dbg !91
  %55 = load double, double* %1, align 8, !dbg !92
  %56 = load i32, i32* %2, align 4, !dbg !93
  %57 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i64 0, i64 0), double %55, i32 %56), !dbg !94
  br label %58, !dbg !95

58:                                               ; preds = %47, %40
  br label %59, !dbg !96

59:                                               ; preds = %58
  %60 = load i32, i32* %6, align 4, !dbg !97
  %61 = add nsw i32 %60, 1, !dbg !97
  store i32 %61, i32* %6, align 4, !dbg !97
  br label %37, !dbg !98, !llvm.loop !99

62:                                               ; preds = %37
  ret i32 0, !dbg !101
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #2

; Function Attrs: nounwind
declare dso_local i64 @clock() #3

declare dso_local i32 @fib(...) #4

declare dso_local i32 @printf(i8*, ...) #4

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !102 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  %2 = call i32 @fib_main(), !dbg !103
  ret i32 %2, !dbg !104
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind willreturn }
attributes #3 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!7, !8, !9}
!llvm.ident = !{!10}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 10.0.1 (https://github.com/llvm/llvm-project.git d24d5c8e308e689dcd83cbafd2e8bd32aa845a15)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "divvied/purple/example3.mod.c", directory: "/home/andrew/gaps/build/apps/examples/example3")
!2 = !{}
!3 = !{!4}
!4 = !DIDerivedType(tag: DW_TAG_typedef, name: "__clock_t", file: !5, line: 156, baseType: !6)
!5 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!6 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!7 = !{i32 7, !"Dwarf Version", i32 4}
!8 = !{i32 2, !"Debug Info Version", i32 3}
!9 = !{i32 1, !"wchar_size", i32 4}
!10 = !{!"clang version 10.0.1 (https://github.com/llvm/llvm-project.git d24d5c8e308e689dcd83cbafd2e8bd32aa845a15)"}
!11 = distinct !DISubprogram(name: "fib_main", scope: !12, file: !12, line: 22, type: !13, scopeLine: 22, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!12 = !DIFile(filename: "./divvied/purple/example3.mod.c", directory: "/home/andrew/gaps/build/apps/examples/example3")
!13 = !DISubroutineType(types: !14)
!14 = !{!15}
!15 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!16 = !DILocalVariable(name: "x", scope: !11, file: !12, line: 25, type: !17)
!17 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!18 = !DILocation(line: 25, column: 10, scope: !11)
!19 = !DILocation(line: 25, column: 3, scope: !11)
!20 = !DILocalVariable(name: "msec", scope: !11, file: !12, line: 28, type: !15)
!21 = !DILocation(line: 28, column: 7, scope: !11)
!22 = !DILocalVariable(name: "before", scope: !11, file: !12, line: 29, type: !23)
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "clock_t", file: !24, line: 7, baseType: !4)
!24 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/clock_t.h", directory: "")
!25 = !DILocation(line: 29, column: 11, scope: !11)
!26 = !DILocation(line: 29, column: 20, scope: !11)
!27 = !DILocalVariable(name: "i", scope: !28, file: !12, line: 30, type: !15)
!28 = distinct !DILexicalBlock(scope: !11, file: !12, line: 30, column: 3)
!29 = !DILocation(line: 30, column: 12, scope: !28)
!30 = !DILocation(line: 30, column: 8, scope: !28)
!31 = !DILocation(line: 30, column: 18, scope: !32)
!32 = distinct !DILexicalBlock(scope: !28, file: !12, line: 30, column: 3)
!33 = !DILocation(line: 30, column: 20, scope: !32)
!34 = !DILocation(line: 30, column: 3, scope: !28)
!35 = !DILocation(line: 31, column: 14, scope: !36)
!36 = distinct !DILexicalBlock(scope: !32, file: !12, line: 30, column: 33)
!37 = !DILocation(line: 31, column: 10, scope: !36)
!38 = !DILocation(line: 31, column: 8, scope: !36)
!39 = !DILocation(line: 32, column: 9, scope: !40)
!40 = distinct !DILexicalBlock(scope: !36, file: !12, line: 32, column: 9)
!41 = !DILocation(line: 32, column: 11, scope: !40)
!42 = !DILocation(line: 32, column: 17, scope: !40)
!43 = !DILocation(line: 32, column: 9, scope: !36)
!44 = !DILocalVariable(name: "difference", scope: !45, file: !12, line: 33, type: !23)
!45 = distinct !DILexicalBlock(scope: !40, file: !12, line: 32, column: 23)
!46 = !DILocation(line: 33, column: 18, scope: !45)
!47 = !DILocation(line: 33, column: 31, scope: !45)
!48 = !DILocation(line: 33, column: 41, scope: !45)
!49 = !DILocation(line: 33, column: 39, scope: !45)
!50 = !DILocation(line: 34, column: 16, scope: !45)
!51 = !DILocation(line: 34, column: 27, scope: !45)
!52 = !DILocation(line: 34, column: 34, scope: !45)
!53 = !DILocation(line: 34, column: 14, scope: !45)
!54 = !DILocation(line: 35, column: 26, scope: !45)
!55 = !DILocation(line: 35, column: 29, scope: !45)
!56 = !DILocation(line: 35, column: 8, scope: !45)
!57 = !DILocation(line: 36, column: 6, scope: !45)
!58 = !DILocation(line: 37, column: 3, scope: !36)
!59 = !DILocation(line: 30, column: 29, scope: !32)
!60 = !DILocation(line: 30, column: 3, scope: !32)
!61 = distinct !{!61, !34, !62}
!62 = !DILocation(line: 37, column: 3, scope: !28)
!63 = !DILocation(line: 38, column: 12, scope: !11)
!64 = !DILocation(line: 38, column: 10, scope: !11)
!65 = !DILocalVariable(name: "i", scope: !66, file: !12, line: 39, type: !15)
!66 = distinct !DILexicalBlock(scope: !11, file: !12, line: 39, column: 3)
!67 = !DILocation(line: 39, column: 12, scope: !66)
!68 = !DILocation(line: 39, column: 8, scope: !66)
!69 = !DILocation(line: 39, column: 18, scope: !70)
!70 = distinct !DILexicalBlock(scope: !66, file: !12, line: 39, column: 3)
!71 = !DILocation(line: 39, column: 20, scope: !70)
!72 = !DILocation(line: 39, column: 3, scope: !66)
!73 = !DILocation(line: 40, column: 14, scope: !74)
!74 = distinct !DILexicalBlock(scope: !70, file: !12, line: 39, column: 33)
!75 = !DILocation(line: 40, column: 10, scope: !74)
!76 = !DILocation(line: 40, column: 8, scope: !74)
!77 = !DILocation(line: 41, column: 9, scope: !78)
!78 = distinct !DILexicalBlock(scope: !74, file: !12, line: 41, column: 9)
!79 = !DILocation(line: 41, column: 11, scope: !78)
!80 = !DILocation(line: 41, column: 17, scope: !78)
!81 = !DILocation(line: 41, column: 9, scope: !74)
!82 = !DILocalVariable(name: "difference", scope: !83, file: !12, line: 42, type: !23)
!83 = distinct !DILexicalBlock(scope: !78, file: !12, line: 41, column: 23)
!84 = !DILocation(line: 42, column: 18, scope: !83)
!85 = !DILocation(line: 42, column: 31, scope: !83)
!86 = !DILocation(line: 42, column: 41, scope: !83)
!87 = !DILocation(line: 42, column: 39, scope: !83)
!88 = !DILocation(line: 43, column: 16, scope: !83)
!89 = !DILocation(line: 43, column: 27, scope: !83)
!90 = !DILocation(line: 43, column: 34, scope: !83)
!91 = !DILocation(line: 43, column: 14, scope: !83)
!92 = !DILocation(line: 44, column: 26, scope: !83)
!93 = !DILocation(line: 44, column: 29, scope: !83)
!94 = !DILocation(line: 44, column: 8, scope: !83)
!95 = !DILocation(line: 45, column: 6, scope: !83)
!96 = !DILocation(line: 46, column: 3, scope: !74)
!97 = !DILocation(line: 39, column: 29, scope: !70)
!98 = !DILocation(line: 39, column: 3, scope: !70)
!99 = distinct !{!99, !72, !100}
!100 = !DILocation(line: 46, column: 3, scope: !66)
!101 = !DILocation(line: 48, column: 3, scope: !11)
!102 = distinct !DISubprogram(name: "main", scope: !12, file: !12, line: 53, type: !13, scopeLine: 53, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!103 = !DILocation(line: 54, column: 10, scope: !102)
!104 = !DILocation(line: 54, column: 3, scope: !102)
