; ModuleID = './divvied/purple/cache.mod.c'
source_filename = "./divvied/purple/cache.mod.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [7 x i8] c"PURPLE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [29 x i8] c"./divvied/purple/cache.mod.c\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @fib_main() #0 !dbg !7 {
  %1 = alloca double, align 8
  %2 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata double* %1, metadata !12, metadata !DIExpression()), !dbg !14
  %3 = bitcast double* %1 to i8*, !dbg !15
  call void @llvm.var.annotation(i8* %3, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([29 x i8], [29 x i8]* @.str.1, i32 0, i32 0), i32 26), !dbg !15
  call void @llvm.dbg.declare(metadata i32* %2, metadata !16, metadata !DIExpression()), !dbg !18
  store i32 0, i32* %2, align 4, !dbg !18
  br label %4, !dbg !19

4:                                                ; preds = %12, %0
  %5 = load i32, i32* %2, align 4, !dbg !20
  %6 = icmp slt i32 %5, 10, !dbg !22
  br i1 %6, label %7, label %15, !dbg !23

7:                                                ; preds = %4
  %8 = call i32 (...) @fib(), !dbg !24
  %9 = sitofp i32 %8 to double, !dbg !24
  store double %9, double* %1, align 8, !dbg !26
  %10 = load double, double* %1, align 8, !dbg !27
  %11 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i64 0, i64 0), double %10), !dbg !28
  br label %12, !dbg !29

12:                                               ; preds = %7
  %13 = load i32, i32* %2, align 4, !dbg !30
  %14 = add nsw i32 %13, 1, !dbg !30
  store i32 %14, i32* %2, align 4, !dbg !30
  br label %4, !dbg !31, !llvm.loop !32

15:                                               ; preds = %4
  ret i32 0, !dbg !34
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #2

declare dso_local i32 @fib(...) #3

declare dso_local i32 @printf(i8*, ...) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !35 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  %2 = call i32 @fib_main(), !dbg !36
  ret i32 %2, !dbg !37
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind willreturn }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 10.0.1 (https://github.com/llvm/llvm-project.git d24d5c8e308e689dcd83cbafd2e8bd32aa845a15)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "divvied/purple/cache.mod.c", directory: "/home/andrew/gaps/build/apps/examples/cache")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"clang version 10.0.1 (https://github.com/llvm/llvm-project.git d24d5c8e308e689dcd83cbafd2e8bd32aa845a15)"}
!7 = distinct !DISubprogram(name: "fib_main", scope: !8, file: !8, line: 23, type: !9, scopeLine: 23, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DIFile(filename: "./divvied/purple/cache.mod.c", directory: "/home/andrew/gaps/build/apps/examples/cache")
!9 = !DISubroutineType(types: !10)
!10 = !{!11}
!11 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!12 = !DILocalVariable(name: "x", scope: !7, file: !8, line: 26, type: !13)
!13 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!14 = !DILocation(line: 26, column: 10, scope: !7)
!15 = !DILocation(line: 26, column: 3, scope: !7)
!16 = !DILocalVariable(name: "i", scope: !17, file: !8, line: 29, type: !11)
!17 = distinct !DILexicalBlock(scope: !7, file: !8, line: 29, column: 3)
!18 = !DILocation(line: 29, column: 12, scope: !17)
!19 = !DILocation(line: 29, column: 8, scope: !17)
!20 = !DILocation(line: 29, column: 17, scope: !21)
!21 = distinct !DILexicalBlock(scope: !17, file: !8, line: 29, column: 3)
!22 = !DILocation(line: 29, column: 19, scope: !21)
!23 = !DILocation(line: 29, column: 3, scope: !17)
!24 = !DILocation(line: 30, column: 10, scope: !25)
!25 = distinct !DILexicalBlock(scope: !21, file: !8, line: 29, column: 30)
!26 = !DILocation(line: 30, column: 8, scope: !25)
!27 = !DILocation(line: 31, column: 20, scope: !25)
!28 = !DILocation(line: 31, column: 5, scope: !25)
!29 = !DILocation(line: 32, column: 3, scope: !25)
!30 = !DILocation(line: 29, column: 26, scope: !21)
!31 = !DILocation(line: 29, column: 3, scope: !21)
!32 = distinct !{!32, !23, !33}
!33 = !DILocation(line: 32, column: 3, scope: !17)
!34 = !DILocation(line: 33, column: 3, scope: !7)
!35 = distinct !DISubprogram(name: "main", scope: !8, file: !8, line: 37, type: !9, scopeLine: 37, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!36 = !DILocation(line: 38, column: 10, scope: !35)
!37 = !DILocation(line: 38, column: 3, scope: !35)
