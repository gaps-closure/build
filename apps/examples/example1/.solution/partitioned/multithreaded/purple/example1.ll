; ModuleID = '/workspaces/build/apps/examples/example1/partitioned/multithreaded/purple/example1.c'
source_filename = "/workspaces/build/apps/examples/example1/partitioned/multithreaded/purple/example1.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@calc_ewma.c = internal global double 0.000000e+00, align 8, !dbg !0
@get_b.b = internal global double 1.000000e+00, align 8, !dbg !11
@.str = private unnamed_addr constant [7 x i8] c"PURPLE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [85 x i8] c"/workspaces/build/apps/examples/example1/partitioned/multithreaded/purple/example1.c\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1
@.str.3 = private unnamed_addr constant [10 x i8] c"EWMA_MAIN\00", section "llvm.metadata"
@llvm.global.annotations = appending global [2 x { i8*, i8*, i8*, i32 }] [{ i8*, i8*, i8*, i32 } { i8* bitcast (double* @get_b.b to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([85 x i8], [85 x i8]* @.str.1, i32 0, i32 0), i32 49 }, { i8*, i8*, i8*, i32 } { i8* bitcast (i32 ()* @ewma_main to i8*), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([85 x i8], [85 x i8]* @.str.1, i32 0, i32 0), i32 57 }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @calc_ewma(double %0, double %1) #0 !dbg !2 {
  %3 = alloca double, align 8
  %4 = alloca double, align 8
  %5 = alloca double, align 8
  store double %0, double* %3, align 8
  call void @llvm.dbg.declare(metadata double* %3, metadata !20, metadata !DIExpression()), !dbg !21
  store double %1, double* %4, align 8
  call void @llvm.dbg.declare(metadata double* %4, metadata !22, metadata !DIExpression()), !dbg !23
  call void @llvm.dbg.declare(metadata double* %5, metadata !24, metadata !DIExpression()), !dbg !26
  store double 2.500000e-01, double* %5, align 8, !dbg !26
  %6 = load double, double* %3, align 8, !dbg !27
  %7 = load double, double* %4, align 8, !dbg !28
  %8 = fadd double %6, %7, !dbg !29
  %9 = fmul double 2.500000e-01, %8, !dbg !30
  %10 = load double, double* @calc_ewma.c, align 8, !dbg !31
  %11 = fmul double 7.500000e-01, %10, !dbg !32
  %12 = fadd double %9, %11, !dbg !33
  store double %12, double* @calc_ewma.c, align 8, !dbg !34
  %13 = load double, double* @calc_ewma.c, align 8, !dbg !35
  ret double %13, !dbg !36
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_b() #0 !dbg !13 {
  %1 = load double, double* @get_b.b, align 8, !dbg !37
  %2 = load double, double* @get_b.b, align 8, !dbg !38
  %3 = fadd double %2, %1, !dbg !38
  store double %3, double* @get_b.b, align 8, !dbg !38
  %4 = load double, double* @get_b.b, align 8, !dbg !39
  ret double %4, !dbg !40
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @ewma_main() #0 !dbg !41 {
  %1 = alloca double, align 8
  %2 = alloca double, align 8
  %3 = alloca double, align 8
  %4 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata double* %1, metadata !45, metadata !DIExpression()), !dbg !46
  call void @llvm.dbg.declare(metadata double* %2, metadata !47, metadata !DIExpression()), !dbg !48
  call void @llvm.dbg.declare(metadata double* %3, metadata !49, metadata !DIExpression()), !dbg !50
  %5 = bitcast double* %3 to i8*, !dbg !51
  call void @llvm.var.annotation(i8* %5, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([85 x i8], [85 x i8]* @.str.1, i32 0, i32 0), i32 64), !dbg !51
  call void @llvm.dbg.declare(metadata i32* %4, metadata !52, metadata !DIExpression()), !dbg !54
  store i32 0, i32* %4, align 4, !dbg !54
  br label %6, !dbg !55

6:                                                ; preds = %17, %0
  %7 = load i32, i32* %4, align 4, !dbg !56
  %8 = icmp slt i32 %7, 10, !dbg !58
  br i1 %8, label %9, label %20, !dbg !59

9:                                                ; preds = %6
  %10 = call double @_err_handle_rpc_get_a(), !dbg !60
  store double %10, double* %1, align 8, !dbg !62
  %11 = call double @get_b(), !dbg !63
  store double %11, double* %2, align 8, !dbg !64
  %12 = load double, double* %1, align 8, !dbg !65
  %13 = load double, double* %2, align 8, !dbg !66
  %14 = call double @calc_ewma(double %12, double %13), !dbg !67
  store double %14, double* %3, align 8, !dbg !68
  %15 = load double, double* %3, align 8, !dbg !69
  %16 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i64 0, i64 0), double %15), !dbg !70
  br label %17, !dbg !71

17:                                               ; preds = %9
  %18 = load i32, i32* %4, align 4, !dbg !72
  %19 = add nsw i32 %18, 1, !dbg !72
  store i32 %19, i32* %4, align 4, !dbg !72
  br label %6, !dbg !73, !llvm.loop !74

20:                                               ; preds = %6
  ret i32 0, !dbg !76
}

; Function Attrs: nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #2

declare dso_local double @_err_handle_rpc_get_a() #3

declare dso_local i32 @printf(i8*, ...) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %0, i8** %1) #0 !dbg !77 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !83, metadata !DIExpression()), !dbg !84
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !85, metadata !DIExpression()), !dbg !86
  call void (...) @_master_rpc_init(), !dbg !87
  %6 = call i32 @ewma_main(), !dbg !88
  ret i32 %6, !dbg !89
}

declare dso_local void @_master_rpc_init(...) #3

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind willreturn }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!7}
!llvm.module.flags = !{!16, !17, !18}
!llvm.ident = !{!19}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "c", scope: !2, file: !3, line: 42, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "calc_ewma", scope: !3, file: !3, line: 40, type: !4, scopeLine: 40, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !9)
!3 = !DIFile(filename: "partitioned/multithreaded/purple/example1.c", directory: "/workspaces/build/apps/examples/example1")
!4 = !DISubroutineType(types: !5)
!5 = !{!6, !6, !6}
!6 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !8, producer: "clang version 10.0.0-4ubuntu1 ", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !9, globals: !10, splitDebugInlining: false, nameTableKind: None)
!8 = !DIFile(filename: "/workspaces/build/apps/examples/example1/partitioned/multithreaded/purple/example1.c", directory: "/workspaces/build/apps/examples/example1")
!9 = !{}
!10 = !{!0, !11}
!11 = !DIGlobalVariableExpression(var: !12, expr: !DIExpression())
!12 = distinct !DIGlobalVariable(name: "b", scope: !13, file: !3, line: 49, type: !6, isLocal: true, isDefinition: true)
!13 = distinct !DISubprogram(name: "get_b", scope: !3, file: !3, line: 46, type: !14, scopeLine: 46, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !9)
!14 = !DISubroutineType(types: !15)
!15 = !{!6}
!16 = !{i32 7, !"Dwarf Version", i32 4}
!17 = !{i32 2, !"Debug Info Version", i32 3}
!18 = !{i32 1, !"wchar_size", i32 4}
!19 = !{!"clang version 10.0.0-4ubuntu1 "}
!20 = !DILocalVariable(name: "a", arg: 1, scope: !2, file: !3, line: 40, type: !6)
!21 = !DILocation(line: 40, column: 25, scope: !2)
!22 = !DILocalVariable(name: "b", arg: 2, scope: !2, file: !3, line: 40, type: !6)
!23 = !DILocation(line: 40, column: 35, scope: !2)
!24 = !DILocalVariable(name: "alpha", scope: !2, file: !3, line: 41, type: !25)
!25 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !6)
!26 = !DILocation(line: 41, column: 17, scope: !2)
!27 = !DILocation(line: 43, column: 16, scope: !2)
!28 = !DILocation(line: 43, column: 20, scope: !2)
!29 = !DILocation(line: 43, column: 18, scope: !2)
!30 = !DILocation(line: 43, column: 13, scope: !2)
!31 = !DILocation(line: 43, column: 39, scope: !2)
!32 = !DILocation(line: 43, column: 37, scope: !2)
!33 = !DILocation(line: 43, column: 23, scope: !2)
!34 = !DILocation(line: 43, column: 5, scope: !2)
!35 = !DILocation(line: 44, column: 10, scope: !2)
!36 = !DILocation(line: 44, column: 3, scope: !2)
!37 = !DILocation(line: 52, column: 8, scope: !13)
!38 = !DILocation(line: 52, column: 5, scope: !13)
!39 = !DILocation(line: 53, column: 10, scope: !13)
!40 = !DILocation(line: 53, column: 3, scope: !13)
!41 = distinct !DISubprogram(name: "ewma_main", scope: !3, file: !3, line: 57, type: !42, scopeLine: 57, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !9)
!42 = !DISubroutineType(types: !43)
!43 = !{!44}
!44 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!45 = !DILocalVariable(name: "x", scope: !41, file: !3, line: 60, type: !6)
!46 = !DILocation(line: 60, column: 10, scope: !41)
!47 = !DILocalVariable(name: "y", scope: !41, file: !3, line: 61, type: !6)
!48 = !DILocation(line: 61, column: 10, scope: !41)
!49 = !DILocalVariable(name: "ewma", scope: !41, file: !3, line: 64, type: !6)
!50 = !DILocation(line: 64, column: 10, scope: !41)
!51 = !DILocation(line: 64, column: 3, scope: !41)
!52 = !DILocalVariable(name: "i", scope: !53, file: !3, line: 67, type: !44)
!53 = distinct !DILexicalBlock(scope: !41, file: !3, line: 67, column: 3)
!54 = !DILocation(line: 67, column: 12, scope: !53)
!55 = !DILocation(line: 67, column: 8, scope: !53)
!56 = !DILocation(line: 67, column: 17, scope: !57)
!57 = distinct !DILexicalBlock(scope: !53, file: !3, line: 67, column: 3)
!58 = !DILocation(line: 67, column: 19, scope: !57)
!59 = !DILocation(line: 67, column: 3, scope: !53)
!60 = !DILocation(line: 68, column: 9, scope: !61)
!61 = distinct !DILexicalBlock(scope: !57, file: !3, line: 67, column: 30)
!62 = !DILocation(line: 68, column: 7, scope: !61)
!63 = !DILocation(line: 69, column: 9, scope: !61)
!64 = !DILocation(line: 69, column: 7, scope: !61)
!65 = !DILocation(line: 70, column: 22, scope: !61)
!66 = !DILocation(line: 70, column: 24, scope: !61)
!67 = !DILocation(line: 70, column: 12, scope: !61)
!68 = !DILocation(line: 70, column: 10, scope: !61)
!69 = !DILocation(line: 71, column: 20, scope: !61)
!70 = !DILocation(line: 71, column: 5, scope: !61)
!71 = !DILocation(line: 72, column: 3, scope: !61)
!72 = !DILocation(line: 67, column: 26, scope: !57)
!73 = !DILocation(line: 67, column: 3, scope: !57)
!74 = distinct !{!74, !59, !75}
!75 = !DILocation(line: 72, column: 3, scope: !53)
!76 = !DILocation(line: 73, column: 3, scope: !41)
!77 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 75, type: !78, scopeLine: 75, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !9)
!78 = !DISubroutineType(types: !79)
!79 = !{!44, !44, !80}
!80 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !81, size: 64)
!81 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !82, size: 64)
!82 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!83 = !DILocalVariable(name: "argc", arg: 1, scope: !77, file: !3, line: 75, type: !44)
!84 = !DILocation(line: 75, column: 14, scope: !77)
!85 = !DILocalVariable(name: "argv", arg: 2, scope: !77, file: !3, line: 75, type: !80)
!86 = !DILocation(line: 75, column: 27, scope: !77)
!87 = !DILocation(line: 76, column: 3, scope: !77)
!88 = !DILocation(line: 77, column: 10, scope: !77)
!89 = !DILocation(line: 77, column: 3, scope: !77)
