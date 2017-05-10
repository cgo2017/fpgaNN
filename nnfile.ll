; ModuleID = 'nnfile.bc'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [27 x i8] c"\0AEpoch %-5d :   Error = %f\00", align 1
@.str1 = private unnamed_addr constant [23 x i8] c"Target%-4d\09Output%-4d\09\00", align 1
@.str2 = private unnamed_addr constant [8 x i8] c"%f\09%f\09\0A\00", align 1
@.str3 = private unnamed_addr constant [20 x i8] c"\0A\0A\0A\0A\0A\0A\0ATESTING\0A\0A\0A\0A\0A\00", align 1
@.str4 = private unnamed_addr constant [25 x i8] c"Optimal Tile Size  = %d\0A\00", align 1
@.str5 = private unnamed_addr constant [25 x i8] c"Obtained Tile Size  = %d\00", align 1

; Function Attrs: nounwind uwtable
define double @exponential(i32 %n, double %x) #0 {
  %1 = alloca i32, align 4
  %2 = alloca double, align 8
  %i = alloca i32, align 4
  %sum = alloca double, align 8
  store i32 %n, i32* %1, align 4
  store double %x, double* %2, align 8
  store double 1.000000e+00, double* %sum, align 8
  %3 = load i32* %1, align 4
  %4 = sub nsw i32 %3, 1
  store i32 %4, i32* %i, align 4
  br label %5

; <label>:5                                       ; preds = %16, %0
  %6 = load i32* %i, align 4
  %7 = icmp sgt i32 %6, 0
  br i1 %7, label %8, label %19

; <label>:8                                       ; preds = %5
  %9 = load double* %2, align 8
  %10 = load double* %sum, align 8
  %11 = fmul double %9, %10
  %12 = load i32* %i, align 4
  %13 = sitofp i32 %12 to double
  %14 = fdiv double %11, %13
  %15 = fadd double 1.000000e+00, %14
  store double %15, double* %sum, align 8
  br label %16

; <label>:16                                      ; preds = %8
  %17 = load i32* %i, align 4
  %18 = add nsw i32 %17, -1
  store i32 %18, i32* %i, align 4
  br label %5

; <label>:19                                      ; preds = %5
  %20 = load double* %sum, align 8
  ret double %20
}

; Function Attrs: nounwind uwtable
define void @neuralNetwork(i32 %numOfPatterns, i32 %numOfInputs, i32 %select, double* %inputValues, double* %outputValues, double* %testInputValues, double* %testOutputValues) #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca double*, align 8
  %5 = alloca double*, align 8
  %6 = alloca double*, align 8
  %7 = alloca double*, align 8
  %NUMPAT = alloca i32, align 4
  %NUMIN = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  %p = alloca i32, align 4
  %np = alloca i32, align 4
  %op = alloca i32, align 4
  %8 = alloca i8*
  %epoch = alloca i32, align 4
  %NumPattern = alloca i32, align 4
  %NumInput = alloca i32, align 4
  %NumHidden1 = alloca i32, align 4
  %NumOutput = alloca i32, align 4
  %NumHidden2 = alloca i32, align 4
  %NumHidden3 = alloca i32, align 4
  %myfile = alloca %struct._IO_FILE*, align 8
  %batchSize = alloca i32, align 4
  %index = alloca i32, align 4
  %WeightHO = alloca [11 x [2 x double]], align 16
  %DeltaO = alloca [2 x double], align 16
  %SumDOW = alloca [11 x double], align 16
  %DeltaH1 = alloca [11 x double], align 16
  %DeltaH2 = alloca [11 x double], align 16
  %DeltaH3 = alloca [11 x double], align 16
  %DeltaWeightHO = alloca [11 x [2 x double]], align 16
  %Error = alloca double, align 8
  %eta = alloca double, align 8
  %alpha = alloca double, align 8
  %smallwt = alloca double, align 8
  %epoch1 = alloca i32, align 4
  %yt = alloca i32, align 4
  %tile = alloca i32, align 4
  %tile1 = alloca i32, align 4
  %min = alloca float, align 4
  %min1 = alloca float, align 4
  store i32 %numOfPatterns, i32* %1, align 4
  store i32 %numOfInputs, i32* %2, align 4
  store i32 %select, i32* %3, align 4
  store double* %inputValues, double** %4, align 8
  store double* %outputValues, double** %5, align 8
  store double* %testInputValues, double** %6, align 8
  store double* %testOutputValues, double** %7, align 8
  %9 = load i32* %1, align 4
  store i32 %9, i32* %NUMPAT, align 4
  %10 = load i32* %2, align 4
  store i32 %10, i32* %NUMIN, align 4
  %11 = load i32* %NUMPAT, align 4
  %12 = add nsw i32 %11, 1
  %13 = zext i32 %12 to i64
  %14 = call i8* @llvm.stacksave()
  store i8* %14, i8** %8
  %15 = alloca i32, i64 %13, align 16
  %16 = load i32* %NUMPAT, align 4
  store i32 %16, i32* %NumPattern, align 4
  %17 = load i32* %NUMIN, align 4
  store i32 %17, i32* %NumInput, align 4
  store i32 10, i32* %NumHidden1, align 4
  store i32 1, i32* %NumOutput, align 4
  store i32 10, i32* %NumHidden2, align 4
  store i32 10, i32* %NumHidden3, align 4
  %18 = load i32* %NUMPAT, align 4
  %19 = add nsw i32 %18, 1
  %20 = zext i32 %19 to i64
  %21 = load i32* %NUMIN, align 4
  %22 = add nsw i32 %21, 1
  %23 = zext i32 %22 to i64
  %24 = mul nuw i64 %20, %23
  %25 = alloca double, i64 %24, align 16
  %26 = load i32* %NUMPAT, align 4
  %27 = add nsw i32 %26, 1
  %28 = zext i32 %27 to i64
  %29 = alloca [2 x double], i64 %28, align 16
  %30 = load i32* %3, align 4
  %31 = icmp eq i32 %30, 1
  br i1 %31, label %32, label %33

; <label>:32                                      ; preds = %0
  store i32 64, i32* %batchSize, align 4
  br label %38

; <label>:33                                      ; preds = %0
  %34 = load i32* %3, align 4
  %35 = icmp eq i32 %34, 2
  br i1 %35, label %36, label %37

; <label>:36                                      ; preds = %33
  store i32 8, i32* %batchSize, align 4
  br label %37

; <label>:37                                      ; preds = %36, %33
  br label %38

; <label>:38                                      ; preds = %37, %32
  store i32 0, i32* %i, align 4
  br label %39

; <label>:39                                      ; preds = %60, %38
  %40 = load i32* %i, align 4
  %41 = load i32* %NUMPAT, align 4
  %42 = icmp sle i32 %40, %41
  br i1 %42, label %43, label %63

; <label>:43                                      ; preds = %39
  store i32 0, i32* %j, align 4
  br label %44

; <label>:44                                      ; preds = %56, %43
  %45 = load i32* %j, align 4
  %46 = load i32* %NUMIN, align 4
  %47 = icmp sle i32 %45, %46
  br i1 %47, label %48, label %59

; <label>:48                                      ; preds = %44
  %49 = load i32* %j, align 4
  %50 = sext i32 %49 to i64
  %51 = load i32* %i, align 4
  %52 = sext i32 %51 to i64
  %53 = mul nsw i64 %52, %23
  %54 = getelementptr inbounds double* %25, i64 %53
  %55 = getelementptr inbounds double* %54, i64 %50
  store double 0.000000e+00, double* %55, align 8
  br label %56

; <label>:56                                      ; preds = %48
  %57 = load i32* %j, align 4
  %58 = add nsw i32 %57, 1
  store i32 %58, i32* %j, align 4
  br label %44

; <label>:59                                      ; preds = %44
  br label %60

; <label>:60                                      ; preds = %59
  %61 = load i32* %i, align 4
  %62 = add nsw i32 %61, 1
  store i32 %62, i32* %i, align 4
  br label %39

; <label>:63                                      ; preds = %39
  store i32 0, i32* %index, align 4
  store i32 1, i32* %i, align 4
  br label %64

; <label>:64                                      ; preds = %92, %63
  %65 = load i32* %i, align 4
  %66 = load i32* %NUMPAT, align 4
  %67 = icmp sle i32 %65, %66
  br i1 %67, label %68, label %95

; <label>:68                                      ; preds = %64
  store i32 1, i32* %j, align 4
  br label %69

; <label>:69                                      ; preds = %86, %68
  %70 = load i32* %j, align 4
  %71 = load i32* %NUMIN, align 4
  %72 = icmp sle i32 %70, %71
  br i1 %72, label %73, label %89

; <label>:73                                      ; preds = %69
  %74 = load i32* %index, align 4
  %75 = sext i32 %74 to i64
  %76 = load double** %4, align 8
  %77 = getelementptr inbounds double* %76, i64 %75
  %78 = load double* %77, align 8
  %79 = load i32* %j, align 4
  %80 = sext i32 %79 to i64
  %81 = load i32* %i, align 4
  %82 = sext i32 %81 to i64
  %83 = mul nsw i64 %82, %23
  %84 = getelementptr inbounds double* %25, i64 %83
  %85 = getelementptr inbounds double* %84, i64 %80
  store double %78, double* %85, align 8
  br label %86

; <label>:86                                      ; preds = %73
  %87 = load i32* %j, align 4
  %88 = add nsw i32 %87, 1
  store i32 %88, i32* %j, align 4
  br label %69

; <label>:89                                      ; preds = %69
  %90 = load i32* %index, align 4
  %91 = add nsw i32 %90, 1
  store i32 %91, i32* %index, align 4
  br label %92

; <label>:92                                      ; preds = %89
  %93 = load i32* %i, align 4
  %94 = add nsw i32 %93, 1
  store i32 %94, i32* %i, align 4
  br label %64

; <label>:95                                      ; preds = %64
  store i32 0, i32* %index, align 4
  store i32 0, i32* %i, align 4
  br label %96

; <label>:96                                      ; preds = %115, %95
  %97 = load i32* %i, align 4
  %98 = load i32* %NUMPAT, align 4
  %99 = icmp sle i32 %97, %98
  br i1 %99, label %100, label %118

; <label>:100                                     ; preds = %96
  store i32 0, i32* %j, align 4
  br label %101

; <label>:101                                     ; preds = %111, %100
  %102 = load i32* %j, align 4
  %103 = icmp sle i32 %102, 1
  br i1 %103, label %104, label %114

; <label>:104                                     ; preds = %101
  %105 = load i32* %j, align 4
  %106 = sext i32 %105 to i64
  %107 = load i32* %i, align 4
  %108 = sext i32 %107 to i64
  %109 = getelementptr inbounds [2 x double]* %29, i64 %108
  %110 = getelementptr inbounds [2 x double]* %109, i32 0, i64 %106
  store double 0.000000e+00, double* %110, align 8
  br label %111

; <label>:111                                     ; preds = %104
  %112 = load i32* %j, align 4
  %113 = add nsw i32 %112, 1
  store i32 %113, i32* %j, align 4
  br label %101

; <label>:114                                     ; preds = %101
  br label %115

; <label>:115                                     ; preds = %114
  %116 = load i32* %i, align 4
  %117 = add nsw i32 %116, 1
  store i32 %117, i32* %i, align 4
  br label %96

; <label>:118                                     ; preds = %96
  store i32 1, i32* %i, align 4
  br label %119

; <label>:119                                     ; preds = %145, %118
  %120 = load i32* %i, align 4
  %121 = load i32* %NUMPAT, align 4
  %122 = icmp sle i32 %120, %121
  br i1 %122, label %123, label %148

; <label>:123                                     ; preds = %119
  store i32 1, i32* %j, align 4
  br label %124

; <label>:124                                     ; preds = %141, %123
  %125 = load i32* %j, align 4
  %126 = icmp sle i32 %125, 1
  br i1 %126, label %127, label %144

; <label>:127                                     ; preds = %124
  %128 = load i32* %index, align 4
  %129 = sext i32 %128 to i64
  %130 = load double** %5, align 8
  %131 = getelementptr inbounds double* %130, i64 %129
  %132 = load double* %131, align 8
  %133 = load i32* %j, align 4
  %134 = sext i32 %133 to i64
  %135 = load i32* %i, align 4
  %136 = sext i32 %135 to i64
  %137 = getelementptr inbounds [2 x double]* %29, i64 %136
  %138 = getelementptr inbounds [2 x double]* %137, i32 0, i64 %134
  store double %132, double* %138, align 8
  %139 = load i32* %index, align 4
  %140 = add nsw i32 %139, 1
  store i32 %140, i32* %index, align 4
  br label %141

; <label>:141                                     ; preds = %127
  %142 = load i32* %j, align 4
  %143 = add nsw i32 %142, 1
  store i32 %143, i32* %j, align 4
  br label %124

; <label>:144                                     ; preds = %124
  br label %145

; <label>:145                                     ; preds = %144
  %146 = load i32* %i, align 4
  %147 = add nsw i32 %146, 1
  store i32 %147, i32* %i, align 4
  br label %119

; <label>:148                                     ; preds = %119
  %149 = load i32* %NUMPAT, align 4
  %150 = add nsw i32 %149, 1
  %151 = zext i32 %150 to i64
  %152 = alloca [11 x double], i64 %151, align 16
  %153 = load i32* %NUMIN, align 4
  %154 = add nsw i32 %153, 1
  %155 = zext i32 %154 to i64
  %156 = alloca [11 x double], i64 %155, align 16
  %157 = load i32* %NUMPAT, align 4
  %158 = add nsw i32 %157, 1
  %159 = zext i32 %158 to i64
  %160 = alloca [11 x double], i64 %159, align 16
  %161 = load i32* %NUMPAT, align 4
  %162 = add nsw i32 %161, 1
  %163 = zext i32 %162 to i64
  %164 = alloca [11 x double], i64 %163, align 16
  %165 = load i32* %NUMPAT, align 4
  %166 = add nsw i32 %165, 1
  %167 = zext i32 %166 to i64
  %168 = alloca [11 x double], i64 %167, align 16
  %169 = load i32* %NUMPAT, align 4
  %170 = add nsw i32 %169, 1
  %171 = zext i32 %170 to i64
  %172 = alloca [11 x double], i64 %171, align 16
  %173 = load i32* %NUMIN, align 4
  %174 = add nsw i32 %173, 1
  %175 = zext i32 %174 to i64
  %176 = alloca [11 x double], i64 %175, align 16
  %177 = load i32* %NUMPAT, align 4
  %178 = add nsw i32 %177, 1
  %179 = zext i32 %178 to i64
  %180 = alloca [11 x double], i64 %179, align 16
  %181 = load i32* %NUMIN, align 4
  %182 = add nsw i32 %181, 1
  %183 = zext i32 %182 to i64
  %184 = alloca [11 x double], i64 %183, align 16
  %185 = load i32* %NUMPAT, align 4
  %186 = add nsw i32 %185, 1
  %187 = zext i32 %186 to i64
  %188 = alloca [2 x double], i64 %187, align 16
  %189 = load i32* %NUMPAT, align 4
  %190 = add nsw i32 %189, 1
  %191 = zext i32 %190 to i64
  %192 = alloca [2 x double], i64 %191, align 16
  %193 = load i32* %NUMIN, align 4
  %194 = add nsw i32 %193, 1
  %195 = zext i32 %194 to i64
  %196 = alloca [11 x double], i64 %195, align 16
  %197 = load i32* %NUMIN, align 4
  %198 = add nsw i32 %197, 1
  %199 = zext i32 %198 to i64
  %200 = alloca [11 x double], i64 %199, align 16
  %201 = load i32* %NUMIN, align 4
  %202 = add nsw i32 %201, 1
  %203 = zext i32 %202 to i64
  %204 = alloca [11 x double], i64 %203, align 16
  store double 5.000000e-04, double* %eta, align 8
  store double 9.000000e-04, double* %alpha, align 8
  store double 4.000000e-04, double* %smallwt, align 8
  store i32 1, i32* %j, align 4
  br label %205

; <label>:205                                     ; preds = %231, %148
  %206 = load i32* %j, align 4
  %207 = load i32* %NumHidden1, align 4
  %208 = icmp sle i32 %206, %207
  br i1 %208, label %209, label %234

; <label>:209                                     ; preds = %205
  store i32 0, i32* %i, align 4
  br label %210

; <label>:210                                     ; preds = %227, %209
  %211 = load i32* %i, align 4
  %212 = load i32* %NumInput, align 4
  %213 = icmp sle i32 %211, %212
  br i1 %213, label %214, label %230

; <label>:214                                     ; preds = %210
  %215 = load i32* %j, align 4
  %216 = sext i32 %215 to i64
  %217 = load i32* %i, align 4
  %218 = sext i32 %217 to i64
  %219 = getelementptr inbounds [11 x double]* %196, i64 %218
  %220 = getelementptr inbounds [11 x double]* %219, i32 0, i64 %216
  store double 0.000000e+00, double* %220, align 8
  %221 = load i32* %j, align 4
  %222 = sext i32 %221 to i64
  %223 = load i32* %i, align 4
  %224 = sext i32 %223 to i64
  %225 = getelementptr inbounds [11 x double]* %156, i64 %224
  %226 = getelementptr inbounds [11 x double]* %225, i32 0, i64 %222
  store double 0.000000e+00, double* %226, align 8
  br label %227

; <label>:227                                     ; preds = %214
  %228 = load i32* %i, align 4
  %229 = add nsw i32 %228, 1
  store i32 %229, i32* %i, align 4
  br label %210

; <label>:230                                     ; preds = %210
  br label %231

; <label>:231                                     ; preds = %230
  %232 = load i32* %j, align 4
  %233 = add nsw i32 %232, 1
  store i32 %233, i32* %j, align 4
  br label %205

; <label>:234                                     ; preds = %205
  store i32 1, i32* %j, align 4
  br label %235

; <label>:235                                     ; preds = %261, %234
  %236 = load i32* %j, align 4
  %237 = load i32* %NumHidden2, align 4
  %238 = icmp sle i32 %236, %237
  br i1 %238, label %239, label %264

; <label>:239                                     ; preds = %235
  store i32 0, i32* %i, align 4
  br label %240

; <label>:240                                     ; preds = %257, %239
  %241 = load i32* %i, align 4
  %242 = load i32* %NumHidden1, align 4
  %243 = icmp sle i32 %241, %242
  br i1 %243, label %244, label %260

; <label>:244                                     ; preds = %240
  %245 = load i32* %j, align 4
  %246 = sext i32 %245 to i64
  %247 = load i32* %i, align 4
  %248 = sext i32 %247 to i64
  %249 = getelementptr inbounds [11 x double]* %200, i64 %248
  %250 = getelementptr inbounds [11 x double]* %249, i32 0, i64 %246
  store double 0.000000e+00, double* %250, align 8
  %251 = load i32* %j, align 4
  %252 = sext i32 %251 to i64
  %253 = load i32* %i, align 4
  %254 = sext i32 %253 to i64
  %255 = getelementptr inbounds [11 x double]* %156, i64 %254
  %256 = getelementptr inbounds [11 x double]* %255, i32 0, i64 %252
  store double 0.000000e+00, double* %256, align 8
  br label %257

; <label>:257                                     ; preds = %244
  %258 = load i32* %i, align 4
  %259 = add nsw i32 %258, 1
  store i32 %259, i32* %i, align 4
  br label %240

; <label>:260                                     ; preds = %240
  br label %261

; <label>:261                                     ; preds = %260
  %262 = load i32* %j, align 4
  %263 = add nsw i32 %262, 1
  store i32 %263, i32* %j, align 4
  br label %235

; <label>:264                                     ; preds = %235
  store i32 1, i32* %j, align 4
  br label %265

; <label>:265                                     ; preds = %291, %264
  %266 = load i32* %j, align 4
  %267 = load i32* %NumHidden3, align 4
  %268 = icmp sle i32 %266, %267
  br i1 %268, label %269, label %294

; <label>:269                                     ; preds = %265
  store i32 0, i32* %i, align 4
  br label %270

; <label>:270                                     ; preds = %287, %269
  %271 = load i32* %i, align 4
  %272 = load i32* %NumHidden2, align 4
  %273 = icmp sle i32 %271, %272
  br i1 %273, label %274, label %290

; <label>:274                                     ; preds = %270
  %275 = load i32* %j, align 4
  %276 = sext i32 %275 to i64
  %277 = load i32* %i, align 4
  %278 = sext i32 %277 to i64
  %279 = getelementptr inbounds [11 x double]* %204, i64 %278
  %280 = getelementptr inbounds [11 x double]* %279, i32 0, i64 %276
  store double 0.000000e+00, double* %280, align 8
  %281 = load i32* %j, align 4
  %282 = sext i32 %281 to i64
  %283 = load i32* %i, align 4
  %284 = sext i32 %283 to i64
  %285 = getelementptr inbounds [11 x double]* %156, i64 %284
  %286 = getelementptr inbounds [11 x double]* %285, i32 0, i64 %282
  store double 0.000000e+00, double* %286, align 8
  br label %287

; <label>:287                                     ; preds = %274
  %288 = load i32* %i, align 4
  %289 = add nsw i32 %288, 1
  store i32 %289, i32* %i, align 4
  br label %270

; <label>:290                                     ; preds = %270
  br label %291

; <label>:291                                     ; preds = %290
  %292 = load i32* %j, align 4
  %293 = add nsw i32 %292, 1
  store i32 %293, i32* %j, align 4
  br label %265

; <label>:294                                     ; preds = %265
  store i32 1, i32* %k, align 4
  br label %295

; <label>:295                                     ; preds = %321, %294
  %296 = load i32* %k, align 4
  %297 = load i32* %NumOutput, align 4
  %298 = icmp sle i32 %296, %297
  br i1 %298, label %299, label %324

; <label>:299                                     ; preds = %295
  store i32 0, i32* %j, align 4
  br label %300

; <label>:300                                     ; preds = %317, %299
  %301 = load i32* %j, align 4
  %302 = load i32* %NumHidden3, align 4
  %303 = icmp sle i32 %301, %302
  br i1 %303, label %304, label %320

; <label>:304                                     ; preds = %300
  %305 = load i32* %k, align 4
  %306 = sext i32 %305 to i64
  %307 = load i32* %j, align 4
  %308 = sext i32 %307 to i64
  %309 = getelementptr inbounds [11 x [2 x double]]* %DeltaWeightHO, i32 0, i64 %308
  %310 = getelementptr inbounds [2 x double]* %309, i32 0, i64 %306
  store double 0.000000e+00, double* %310, align 8
  %311 = load i32* %j, align 4
  %312 = sext i32 %311 to i64
  %313 = load i32* %i, align 4
  %314 = sext i32 %313 to i64
  %315 = getelementptr inbounds [11 x double]* %156, i64 %314
  %316 = getelementptr inbounds [11 x double]* %315, i32 0, i64 %312
  store double 0.000000e+00, double* %316, align 8
  br label %317

; <label>:317                                     ; preds = %304
  %318 = load i32* %j, align 4
  %319 = add nsw i32 %318, 1
  store i32 %319, i32* %j, align 4
  br label %300

; <label>:320                                     ; preds = %300
  br label %321

; <label>:321                                     ; preds = %320
  %322 = load i32* %k, align 4
  %323 = add nsw i32 %322, 1
  store i32 %323, i32* %k, align 4
  br label %295

; <label>:324                                     ; preds = %295
  store i32 1, i32* %p, align 4
  br label %325

; <label>:325                                     ; preds = %334, %324
  %326 = load i32* %p, align 4
  %327 = load i32* %NumPattern, align 4
  %328 = icmp sle i32 %326, %327
  br i1 %328, label %329, label %337

; <label>:329                                     ; preds = %325
  %330 = load i32* %p, align 4
  %331 = load i32* %p, align 4
  %332 = sext i32 %331 to i64
  %333 = getelementptr inbounds i32* %15, i64 %332
  store i32 %330, i32* %333, align 4
  br label %334

; <label>:334                                     ; preds = %329
  %335 = load i32* %p, align 4
  %336 = add nsw i32 %335, 1
  store i32 %336, i32* %p, align 4
  br label %325

; <label>:337                                     ; preds = %325
  store i32 0, i32* %epoch1, align 4
  br label %338

; <label>:338                                     ; preds = %1264, %337
  %339 = load i32* %epoch1, align 4
  %340 = icmp slt i32 %339, 1
  br i1 %340, label %341, label %1267

; <label>:341                                     ; preds = %338
  store i32 1, i32* %yt, align 4
  br label %342

; <label>:342                                     ; preds = %1259, %341
  %343 = load i32* %yt, align 4
  %344 = load i32* %NUMPAT, align 4
  %345 = icmp sle i32 %343, %344
  br i1 %345, label %346, label %1263

; <label>:346                                     ; preds = %342
  store i32 0, i32* %epoch, align 4
  br label %347

; <label>:347                                     ; preds = %1255, %346
  %348 = load i32* %epoch, align 4
  %349 = icmp slt i32 %348, 1000
  br i1 %349, label %350, label %1258

; <label>:350                                     ; preds = %347
  store double 0.000000e+00, double* %Error, align 8
  %351 = load i32* %yt, align 4
  store i32 %351, i32* %np, align 4
  br label %352

; <label>:352                                     ; preds = %1243, %350
  %353 = load i32* %np, align 4
  %354 = load i32* %yt, align 4
  %355 = load i32* %batchSize, align 4
  %356 = add nsw i32 %354, %355
  %357 = icmp sle i32 %353, %356
  br i1 %357, label %358, label %1246

; <label>:358                                     ; preds = %352
  %359 = load i32* %np, align 4
  %360 = sext i32 %359 to i64
  %361 = getelementptr inbounds i32* %15, i64 %360
  %362 = load i32* %361, align 4
  store i32 %362, i32* %p, align 4
  store i32 1, i32* %j, align 4
  br label %363

; <label>:363                                     ; preds = %429, %358
  %364 = load i32* %j, align 4
  %365 = load i32* %NumHidden1, align 4
  %366 = icmp sle i32 %364, %365
  br i1 %366, label %367, label %432

; <label>:367                                     ; preds = %363
  %368 = load i32* %j, align 4
  %369 = sext i32 %368 to i64
  %370 = getelementptr inbounds [11 x double]* %156, i64 0
  %371 = getelementptr inbounds [11 x double]* %370, i32 0, i64 %369
  %372 = load double* %371, align 8
  %373 = load i32* %j, align 4
  %374 = sext i32 %373 to i64
  %375 = load i32* %p, align 4
  %376 = sext i32 %375 to i64
  %377 = getelementptr inbounds [11 x double]* %152, i64 %376
  %378 = getelementptr inbounds [11 x double]* %377, i32 0, i64 %374
  store double %372, double* %378, align 8
  store i32 1, i32* %i, align 4
  br label %379

; <label>:379                                     ; preds = %408, %367
  %380 = load i32* %i, align 4
  %381 = load i32* %NumInput, align 4
  %382 = icmp sle i32 %380, %381
  br i1 %382, label %383, label %411

; <label>:383                                     ; preds = %379
  %384 = load i32* %i, align 4
  %385 = sext i32 %384 to i64
  %386 = load i32* %p, align 4
  %387 = sext i32 %386 to i64
  %388 = mul nsw i64 %387, %23
  %389 = getelementptr inbounds double* %25, i64 %388
  %390 = getelementptr inbounds double* %389, i64 %385
  %391 = load double* %390, align 8
  %392 = load i32* %j, align 4
  %393 = sext i32 %392 to i64
  %394 = load i32* %i, align 4
  %395 = sext i32 %394 to i64
  %396 = getelementptr inbounds [11 x double]* %156, i64 %395
  %397 = getelementptr inbounds [11 x double]* %396, i32 0, i64 %393
  %398 = load double* %397, align 8
  %399 = fmul double %391, %398
  %400 = load i32* %j, align 4
  %401 = sext i32 %400 to i64
  %402 = load i32* %p, align 4
  %403 = sext i32 %402 to i64
  %404 = getelementptr inbounds [11 x double]* %152, i64 %403
  %405 = getelementptr inbounds [11 x double]* %404, i32 0, i64 %401
  %406 = load double* %405, align 8
  %407 = fadd double %406, %399
  store double %407, double* %405, align 8
  br label %408

; <label>:408                                     ; preds = %383
  %409 = load i32* %i, align 4
  %410 = add nsw i32 %409, 1
  store i32 %410, i32* %i, align 4
  br label %379

; <label>:411                                     ; preds = %379
  %412 = load i32* %j, align 4
  %413 = sext i32 %412 to i64
  %414 = load i32* %p, align 4
  %415 = sext i32 %414 to i64
  %416 = getelementptr inbounds [11 x double]* %152, i64 %415
  %417 = getelementptr inbounds [11 x double]* %416, i32 0, i64 %413
  %418 = load double* %417, align 8
  %419 = fsub double -0.000000e+00, %418
  %420 = call double @exponential(i32 10, double %419)
  %421 = fadd double 1.000000e+00, %420
  %422 = fdiv double 1.000000e+00, %421
  %423 = load i32* %j, align 4
  %424 = sext i32 %423 to i64
  %425 = load i32* %p, align 4
  %426 = sext i32 %425 to i64
  %427 = getelementptr inbounds [11 x double]* %160, i64 %426
  %428 = getelementptr inbounds [11 x double]* %427, i32 0, i64 %424
  store double %422, double* %428, align 8
  br label %429

; <label>:429                                     ; preds = %411
  %430 = load i32* %j, align 4
  %431 = add nsw i32 %430, 1
  store i32 %431, i32* %j, align 4
  br label %363

; <label>:432                                     ; preds = %363
  store i32 1, i32* %j, align 4
  br label %433

; <label>:433                                     ; preds = %498, %432
  %434 = load i32* %j, align 4
  %435 = load i32* %NumHidden2, align 4
  %436 = icmp sle i32 %434, %435
  br i1 %436, label %437, label %501

; <label>:437                                     ; preds = %433
  %438 = load i32* %j, align 4
  %439 = sext i32 %438 to i64
  %440 = getelementptr inbounds [11 x double]* %176, i64 0
  %441 = getelementptr inbounds [11 x double]* %440, i32 0, i64 %439
  %442 = load double* %441, align 8
  %443 = load i32* %j, align 4
  %444 = sext i32 %443 to i64
  %445 = load i32* %p, align 4
  %446 = sext i32 %445 to i64
  %447 = getelementptr inbounds [11 x double]* %172, i64 %446
  %448 = getelementptr inbounds [11 x double]* %447, i32 0, i64 %444
  store double %442, double* %448, align 8
  store i32 1, i32* %i, align 4
  br label %449

; <label>:449                                     ; preds = %477, %437
  %450 = load i32* %i, align 4
  %451 = load i32* %NumHidden1, align 4
  %452 = icmp sle i32 %450, %451
  br i1 %452, label %453, label %480

; <label>:453                                     ; preds = %449
  %454 = load i32* %i, align 4
  %455 = sext i32 %454 to i64
  %456 = load i32* %p, align 4
  %457 = sext i32 %456 to i64
  %458 = getelementptr inbounds [11 x double]* %160, i64 %457
  %459 = getelementptr inbounds [11 x double]* %458, i32 0, i64 %455
  %460 = load double* %459, align 8
  %461 = load i32* %j, align 4
  %462 = sext i32 %461 to i64
  %463 = load i32* %i, align 4
  %464 = sext i32 %463 to i64
  %465 = getelementptr inbounds [11 x double]* %176, i64 %464
  %466 = getelementptr inbounds [11 x double]* %465, i32 0, i64 %462
  %467 = load double* %466, align 8
  %468 = fmul double %460, %467
  %469 = load i32* %j, align 4
  %470 = sext i32 %469 to i64
  %471 = load i32* %p, align 4
  %472 = sext i32 %471 to i64
  %473 = getelementptr inbounds [11 x double]* %172, i64 %472
  %474 = getelementptr inbounds [11 x double]* %473, i32 0, i64 %470
  %475 = load double* %474, align 8
  %476 = fadd double %475, %468
  store double %476, double* %474, align 8
  br label %477

; <label>:477                                     ; preds = %453
  %478 = load i32* %i, align 4
  %479 = add nsw i32 %478, 1
  store i32 %479, i32* %i, align 4
  br label %449

; <label>:480                                     ; preds = %449
  %481 = load i32* %j, align 4
  %482 = sext i32 %481 to i64
  %483 = load i32* %p, align 4
  %484 = sext i32 %483 to i64
  %485 = getelementptr inbounds [11 x double]* %172, i64 %484
  %486 = getelementptr inbounds [11 x double]* %485, i32 0, i64 %482
  %487 = load double* %486, align 8
  %488 = fsub double -0.000000e+00, %487
  %489 = call double @exponential(i32 10, double %488)
  %490 = fadd double 1.000000e+00, %489
  %491 = fdiv double 1.000000e+00, %490
  %492 = load i32* %j, align 4
  %493 = sext i32 %492 to i64
  %494 = load i32* %p, align 4
  %495 = sext i32 %494 to i64
  %496 = getelementptr inbounds [11 x double]* %164, i64 %495
  %497 = getelementptr inbounds [11 x double]* %496, i32 0, i64 %493
  store double %491, double* %497, align 8
  br label %498

; <label>:498                                     ; preds = %480
  %499 = load i32* %j, align 4
  %500 = add nsw i32 %499, 1
  store i32 %500, i32* %j, align 4
  br label %433

; <label>:501                                     ; preds = %433
  store i32 1, i32* %j, align 4
  br label %502

; <label>:502                                     ; preds = %567, %501
  %503 = load i32* %j, align 4
  %504 = load i32* %NumHidden3, align 4
  %505 = icmp sle i32 %503, %504
  br i1 %505, label %506, label %570

; <label>:506                                     ; preds = %502
  %507 = load i32* %j, align 4
  %508 = sext i32 %507 to i64
  %509 = getelementptr inbounds [11 x double]* %184, i64 0
  %510 = getelementptr inbounds [11 x double]* %509, i32 0, i64 %508
  %511 = load double* %510, align 8
  %512 = load i32* %j, align 4
  %513 = sext i32 %512 to i64
  %514 = load i32* %p, align 4
  %515 = sext i32 %514 to i64
  %516 = getelementptr inbounds [11 x double]* %180, i64 %515
  %517 = getelementptr inbounds [11 x double]* %516, i32 0, i64 %513
  store double %511, double* %517, align 8
  store i32 1, i32* %i, align 4
  br label %518

; <label>:518                                     ; preds = %546, %506
  %519 = load i32* %i, align 4
  %520 = load i32* %NumHidden2, align 4
  %521 = icmp sle i32 %519, %520
  br i1 %521, label %522, label %549

; <label>:522                                     ; preds = %518
  %523 = load i32* %i, align 4
  %524 = sext i32 %523 to i64
  %525 = load i32* %p, align 4
  %526 = sext i32 %525 to i64
  %527 = getelementptr inbounds [11 x double]* %164, i64 %526
  %528 = getelementptr inbounds [11 x double]* %527, i32 0, i64 %524
  %529 = load double* %528, align 8
  %530 = load i32* %j, align 4
  %531 = sext i32 %530 to i64
  %532 = load i32* %i, align 4
  %533 = sext i32 %532 to i64
  %534 = getelementptr inbounds [11 x double]* %184, i64 %533
  %535 = getelementptr inbounds [11 x double]* %534, i32 0, i64 %531
  %536 = load double* %535, align 8
  %537 = fmul double %529, %536
  %538 = load i32* %j, align 4
  %539 = sext i32 %538 to i64
  %540 = load i32* %p, align 4
  %541 = sext i32 %540 to i64
  %542 = getelementptr inbounds [11 x double]* %180, i64 %541
  %543 = getelementptr inbounds [11 x double]* %542, i32 0, i64 %539
  %544 = load double* %543, align 8
  %545 = fadd double %544, %537
  store double %545, double* %543, align 8
  br label %546

; <label>:546                                     ; preds = %522
  %547 = load i32* %i, align 4
  %548 = add nsw i32 %547, 1
  store i32 %548, i32* %i, align 4
  br label %518

; <label>:549                                     ; preds = %518
  %550 = load i32* %j, align 4
  %551 = sext i32 %550 to i64
  %552 = load i32* %p, align 4
  %553 = sext i32 %552 to i64
  %554 = getelementptr inbounds [11 x double]* %180, i64 %553
  %555 = getelementptr inbounds [11 x double]* %554, i32 0, i64 %551
  %556 = load double* %555, align 8
  %557 = fsub double -0.000000e+00, %556
  %558 = call double @exponential(i32 10, double %557)
  %559 = fadd double 1.000000e+00, %558
  %560 = fdiv double 1.000000e+00, %559
  %561 = load i32* %j, align 4
  %562 = sext i32 %561 to i64
  %563 = load i32* %p, align 4
  %564 = sext i32 %563 to i64
  %565 = getelementptr inbounds [11 x double]* %168, i64 %564
  %566 = getelementptr inbounds [11 x double]* %565, i32 0, i64 %562
  store double %560, double* %566, align 8
  br label %567

; <label>:567                                     ; preds = %549
  %568 = load i32* %j, align 4
  %569 = add nsw i32 %568, 1
  store i32 %569, i32* %j, align 4
  br label %502

; <label>:570                                     ; preds = %502
  store i32 1, i32* %k, align 4
  br label %571

; <label>:571                                     ; preds = %684, %570
  %572 = load i32* %k, align 4
  %573 = load i32* %NumOutput, align 4
  %574 = icmp sle i32 %572, %573
  br i1 %574, label %575, label %687

; <label>:575                                     ; preds = %571
  %576 = load i32* %k, align 4
  %577 = sext i32 %576 to i64
  %578 = getelementptr inbounds [11 x [2 x double]]* %WeightHO, i32 0, i64 0
  %579 = getelementptr inbounds [2 x double]* %578, i32 0, i64 %577
  %580 = load double* %579, align 8
  %581 = load i32* %k, align 4
  %582 = sext i32 %581 to i64
  %583 = load i32* %p, align 4
  %584 = sext i32 %583 to i64
  %585 = getelementptr inbounds [2 x double]* %188, i64 %584
  %586 = getelementptr inbounds [2 x double]* %585, i32 0, i64 %582
  store double %580, double* %586, align 8
  store i32 1, i32* %j, align 4
  br label %587

; <label>:587                                     ; preds = %615, %575
  %588 = load i32* %j, align 4
  %589 = load i32* %NumHidden3, align 4
  %590 = icmp sle i32 %588, %589
  br i1 %590, label %591, label %618

; <label>:591                                     ; preds = %587
  %592 = load i32* %j, align 4
  %593 = sext i32 %592 to i64
  %594 = load i32* %p, align 4
  %595 = sext i32 %594 to i64
  %596 = getelementptr inbounds [11 x double]* %168, i64 %595
  %597 = getelementptr inbounds [11 x double]* %596, i32 0, i64 %593
  %598 = load double* %597, align 8
  %599 = load i32* %k, align 4
  %600 = sext i32 %599 to i64
  %601 = load i32* %j, align 4
  %602 = sext i32 %601 to i64
  %603 = getelementptr inbounds [11 x [2 x double]]* %WeightHO, i32 0, i64 %602
  %604 = getelementptr inbounds [2 x double]* %603, i32 0, i64 %600
  %605 = load double* %604, align 8
  %606 = fmul double %598, %605
  %607 = load i32* %k, align 4
  %608 = sext i32 %607 to i64
  %609 = load i32* %p, align 4
  %610 = sext i32 %609 to i64
  %611 = getelementptr inbounds [2 x double]* %188, i64 %610
  %612 = getelementptr inbounds [2 x double]* %611, i32 0, i64 %608
  %613 = load double* %612, align 8
  %614 = fadd double %613, %606
  store double %614, double* %612, align 8
  br label %615

; <label>:615                                     ; preds = %591
  %616 = load i32* %j, align 4
  %617 = add nsw i32 %616, 1
  store i32 %617, i32* %j, align 4
  br label %587

; <label>:618                                     ; preds = %587
  %619 = load i32* %k, align 4
  %620 = sext i32 %619 to i64
  %621 = load i32* %p, align 4
  %622 = sext i32 %621 to i64
  %623 = getelementptr inbounds [2 x double]* %188, i64 %622
  %624 = getelementptr inbounds [2 x double]* %623, i32 0, i64 %620
  %625 = load double* %624, align 8
  %626 = load i32* %k, align 4
  %627 = sext i32 %626 to i64
  %628 = load i32* %p, align 4
  %629 = sext i32 %628 to i64
  %630 = getelementptr inbounds [2 x double]* %192, i64 %629
  %631 = getelementptr inbounds [2 x double]* %630, i32 0, i64 %627
  store double %625, double* %631, align 8
  %632 = load i32* %k, align 4
  %633 = sext i32 %632 to i64
  %634 = load i32* %p, align 4
  %635 = sext i32 %634 to i64
  %636 = getelementptr inbounds [2 x double]* %29, i64 %635
  %637 = getelementptr inbounds [2 x double]* %636, i32 0, i64 %633
  %638 = load double* %637, align 8
  %639 = load i32* %k, align 4
  %640 = sext i32 %639 to i64
  %641 = load i32* %p, align 4
  %642 = sext i32 %641 to i64
  %643 = getelementptr inbounds [2 x double]* %192, i64 %642
  %644 = getelementptr inbounds [2 x double]* %643, i32 0, i64 %640
  %645 = load double* %644, align 8
  %646 = fsub double %638, %645
  %647 = fmul double 5.000000e-01, %646
  %648 = load i32* %k, align 4
  %649 = sext i32 %648 to i64
  %650 = load i32* %p, align 4
  %651 = sext i32 %650 to i64
  %652 = getelementptr inbounds [2 x double]* %29, i64 %651
  %653 = getelementptr inbounds [2 x double]* %652, i32 0, i64 %649
  %654 = load double* %653, align 8
  %655 = load i32* %k, align 4
  %656 = sext i32 %655 to i64
  %657 = load i32* %p, align 4
  %658 = sext i32 %657 to i64
  %659 = getelementptr inbounds [2 x double]* %192, i64 %658
  %660 = getelementptr inbounds [2 x double]* %659, i32 0, i64 %656
  %661 = load double* %660, align 8
  %662 = fsub double %654, %661
  %663 = fmul double %647, %662
  %664 = load double* %Error, align 8
  %665 = fadd double %664, %663
  store double %665, double* %Error, align 8
  %666 = load i32* %k, align 4
  %667 = sext i32 %666 to i64
  %668 = load i32* %p, align 4
  %669 = sext i32 %668 to i64
  %670 = getelementptr inbounds [2 x double]* %29, i64 %669
  %671 = getelementptr inbounds [2 x double]* %670, i32 0, i64 %667
  %672 = load double* %671, align 8
  %673 = load i32* %k, align 4
  %674 = sext i32 %673 to i64
  %675 = load i32* %p, align 4
  %676 = sext i32 %675 to i64
  %677 = getelementptr inbounds [2 x double]* %192, i64 %676
  %678 = getelementptr inbounds [2 x double]* %677, i32 0, i64 %674
  %679 = load double* %678, align 8
  %680 = fsub double %672, %679
  %681 = load i32* %k, align 4
  %682 = sext i32 %681 to i64
  %683 = getelementptr inbounds [2 x double]* %DeltaO, i32 0, i64 %682
  store double %680, double* %683, align 8
  br label %684

; <label>:684                                     ; preds = %618
  %685 = load i32* %k, align 4
  %686 = add nsw i32 %685, 1
  store i32 %686, i32* %k, align 4
  br label %571

; <label>:687                                     ; preds = %571
  store i32 1, i32* %j, align 4
  br label %688

; <label>:688                                     ; preds = %746, %687
  %689 = load i32* %j, align 4
  %690 = load i32* %NumHidden3, align 4
  %691 = icmp sle i32 %689, %690
  br i1 %691, label %692, label %749

; <label>:692                                     ; preds = %688
  %693 = load i32* %j, align 4
  %694 = sext i32 %693 to i64
  %695 = getelementptr inbounds [11 x double]* %SumDOW, i32 0, i64 %694
  store double 0.000000e+00, double* %695, align 8
  store i32 1, i32* %k, align 4
  br label %696

; <label>:696                                     ; preds = %718, %692
  %697 = load i32* %k, align 4
  %698 = load i32* %NumOutput, align 4
  %699 = icmp sle i32 %697, %698
  br i1 %699, label %700, label %721

; <label>:700                                     ; preds = %696
  %701 = load i32* %k, align 4
  %702 = sext i32 %701 to i64
  %703 = load i32* %j, align 4
  %704 = sext i32 %703 to i64
  %705 = getelementptr inbounds [11 x [2 x double]]* %WeightHO, i32 0, i64 %704
  %706 = getelementptr inbounds [2 x double]* %705, i32 0, i64 %702
  %707 = load double* %706, align 8
  %708 = load i32* %k, align 4
  %709 = sext i32 %708 to i64
  %710 = getelementptr inbounds [2 x double]* %DeltaO, i32 0, i64 %709
  %711 = load double* %710, align 8
  %712 = fmul double %707, %711
  %713 = load i32* %j, align 4
  %714 = sext i32 %713 to i64
  %715 = getelementptr inbounds [11 x double]* %SumDOW, i32 0, i64 %714
  %716 = load double* %715, align 8
  %717 = fadd double %716, %712
  store double %717, double* %715, align 8
  br label %718

; <label>:718                                     ; preds = %700
  %719 = load i32* %k, align 4
  %720 = add nsw i32 %719, 1
  store i32 %720, i32* %k, align 4
  br label %696

; <label>:721                                     ; preds = %696
  %722 = load i32* %j, align 4
  %723 = sext i32 %722 to i64
  %724 = getelementptr inbounds [11 x double]* %SumDOW, i32 0, i64 %723
  %725 = load double* %724, align 8
  %726 = load i32* %j, align 4
  %727 = sext i32 %726 to i64
  %728 = load i32* %p, align 4
  %729 = sext i32 %728 to i64
  %730 = getelementptr inbounds [11 x double]* %168, i64 %729
  %731 = getelementptr inbounds [11 x double]* %730, i32 0, i64 %727
  %732 = load double* %731, align 8
  %733 = fmul double %725, %732
  %734 = load i32* %j, align 4
  %735 = sext i32 %734 to i64
  %736 = load i32* %p, align 4
  %737 = sext i32 %736 to i64
  %738 = getelementptr inbounds [11 x double]* %168, i64 %737
  %739 = getelementptr inbounds [11 x double]* %738, i32 0, i64 %735
  %740 = load double* %739, align 8
  %741 = fsub double 1.000000e+00, %740
  %742 = fmul double %733, %741
  %743 = load i32* %j, align 4
  %744 = sext i32 %743 to i64
  %745 = getelementptr inbounds [11 x double]* %DeltaH3, i32 0, i64 %744
  store double %742, double* %745, align 8
  br label %746

; <label>:746                                     ; preds = %721
  %747 = load i32* %j, align 4
  %748 = add nsw i32 %747, 1
  store i32 %748, i32* %j, align 4
  br label %688

; <label>:749                                     ; preds = %688
  store i32 1, i32* %j, align 4
  br label %750

; <label>:750                                     ; preds = %808, %749
  %751 = load i32* %j, align 4
  %752 = load i32* %NumHidden2, align 4
  %753 = icmp sle i32 %751, %752
  br i1 %753, label %754, label %811

; <label>:754                                     ; preds = %750
  %755 = load i32* %j, align 4
  %756 = sext i32 %755 to i64
  %757 = getelementptr inbounds [11 x double]* %SumDOW, i32 0, i64 %756
  store double 0.000000e+00, double* %757, align 8
  store i32 1, i32* %k, align 4
  br label %758

; <label>:758                                     ; preds = %780, %754
  %759 = load i32* %k, align 4
  %760 = load i32* %NumHidden3, align 4
  %761 = icmp sle i32 %759, %760
  br i1 %761, label %762, label %783

; <label>:762                                     ; preds = %758
  %763 = load i32* %k, align 4
  %764 = sext i32 %763 to i64
  %765 = load i32* %j, align 4
  %766 = sext i32 %765 to i64
  %767 = getelementptr inbounds [11 x double]* %184, i64 %766
  %768 = getelementptr inbounds [11 x double]* %767, i32 0, i64 %764
  %769 = load double* %768, align 8
  %770 = load i32* %k, align 4
  %771 = sext i32 %770 to i64
  %772 = getelementptr inbounds [11 x double]* %DeltaH3, i32 0, i64 %771
  %773 = load double* %772, align 8
  %774 = fmul double %769, %773
  %775 = load i32* %j, align 4
  %776 = sext i32 %775 to i64
  %777 = getelementptr inbounds [11 x double]* %SumDOW, i32 0, i64 %776
  %778 = load double* %777, align 8
  %779 = fadd double %778, %774
  store double %779, double* %777, align 8
  br label %780

; <label>:780                                     ; preds = %762
  %781 = load i32* %k, align 4
  %782 = add nsw i32 %781, 1
  store i32 %782, i32* %k, align 4
  br label %758

; <label>:783                                     ; preds = %758
  %784 = load i32* %j, align 4
  %785 = sext i32 %784 to i64
  %786 = getelementptr inbounds [11 x double]* %SumDOW, i32 0, i64 %785
  %787 = load double* %786, align 8
  %788 = load i32* %j, align 4
  %789 = sext i32 %788 to i64
  %790 = load i32* %p, align 4
  %791 = sext i32 %790 to i64
  %792 = getelementptr inbounds [11 x double]* %164, i64 %791
  %793 = getelementptr inbounds [11 x double]* %792, i32 0, i64 %789
  %794 = load double* %793, align 8
  %795 = fmul double %787, %794
  %796 = load i32* %j, align 4
  %797 = sext i32 %796 to i64
  %798 = load i32* %p, align 4
  %799 = sext i32 %798 to i64
  %800 = getelementptr inbounds [11 x double]* %164, i64 %799
  %801 = getelementptr inbounds [11 x double]* %800, i32 0, i64 %797
  %802 = load double* %801, align 8
  %803 = fsub double 1.000000e+00, %802
  %804 = fmul double %795, %803
  %805 = load i32* %j, align 4
  %806 = sext i32 %805 to i64
  %807 = getelementptr inbounds [11 x double]* %DeltaH2, i32 0, i64 %806
  store double %804, double* %807, align 8
  br label %808

; <label>:808                                     ; preds = %783
  %809 = load i32* %j, align 4
  %810 = add nsw i32 %809, 1
  store i32 %810, i32* %j, align 4
  br label %750

; <label>:811                                     ; preds = %750
  store i32 1, i32* %j, align 4
  br label %812

; <label>:812                                     ; preds = %870, %811
  %813 = load i32* %j, align 4
  %814 = load i32* %NumHidden1, align 4
  %815 = icmp sle i32 %813, %814
  br i1 %815, label %816, label %873

; <label>:816                                     ; preds = %812
  %817 = load i32* %j, align 4
  %818 = sext i32 %817 to i64
  %819 = getelementptr inbounds [11 x double]* %SumDOW, i32 0, i64 %818
  store double 0.000000e+00, double* %819, align 8
  store i32 1, i32* %k, align 4
  br label %820

; <label>:820                                     ; preds = %842, %816
  %821 = load i32* %k, align 4
  %822 = load i32* %NumHidden2, align 4
  %823 = icmp sle i32 %821, %822
  br i1 %823, label %824, label %845

; <label>:824                                     ; preds = %820
  %825 = load i32* %k, align 4
  %826 = sext i32 %825 to i64
  %827 = load i32* %j, align 4
  %828 = sext i32 %827 to i64
  %829 = getelementptr inbounds [11 x double]* %176, i64 %828
  %830 = getelementptr inbounds [11 x double]* %829, i32 0, i64 %826
  %831 = load double* %830, align 8
  %832 = load i32* %k, align 4
  %833 = sext i32 %832 to i64
  %834 = getelementptr inbounds [11 x double]* %DeltaH2, i32 0, i64 %833
  %835 = load double* %834, align 8
  %836 = fmul double %831, %835
  %837 = load i32* %j, align 4
  %838 = sext i32 %837 to i64
  %839 = getelementptr inbounds [11 x double]* %SumDOW, i32 0, i64 %838
  %840 = load double* %839, align 8
  %841 = fadd double %840, %836
  store double %841, double* %839, align 8
  br label %842

; <label>:842                                     ; preds = %824
  %843 = load i32* %k, align 4
  %844 = add nsw i32 %843, 1
  store i32 %844, i32* %k, align 4
  br label %820

; <label>:845                                     ; preds = %820
  %846 = load i32* %j, align 4
  %847 = sext i32 %846 to i64
  %848 = getelementptr inbounds [11 x double]* %SumDOW, i32 0, i64 %847
  %849 = load double* %848, align 8
  %850 = load i32* %j, align 4
  %851 = sext i32 %850 to i64
  %852 = load i32* %p, align 4
  %853 = sext i32 %852 to i64
  %854 = getelementptr inbounds [11 x double]* %160, i64 %853
  %855 = getelementptr inbounds [11 x double]* %854, i32 0, i64 %851
  %856 = load double* %855, align 8
  %857 = fmul double %849, %856
  %858 = load i32* %j, align 4
  %859 = sext i32 %858 to i64
  %860 = load i32* %p, align 4
  %861 = sext i32 %860 to i64
  %862 = getelementptr inbounds [11 x double]* %160, i64 %861
  %863 = getelementptr inbounds [11 x double]* %862, i32 0, i64 %859
  %864 = load double* %863, align 8
  %865 = fsub double 1.000000e+00, %864
  %866 = fmul double %857, %865
  %867 = load i32* %j, align 4
  %868 = sext i32 %867 to i64
  %869 = getelementptr inbounds [11 x double]* %DeltaH1, i32 0, i64 %868
  store double %866, double* %869, align 8
  br label %870

; <label>:870                                     ; preds = %845
  %871 = load i32* %j, align 4
  %872 = add nsw i32 %871, 1
  store i32 %872, i32* %j, align 4
  br label %812

; <label>:873                                     ; preds = %812
  store i32 1, i32* %j, align 4
  br label %874

; <label>:874                                     ; preds = %963, %873
  %875 = load i32* %j, align 4
  %876 = load i32* %NumHidden1, align 4
  %877 = icmp sle i32 %875, %876
  br i1 %877, label %878, label %966

; <label>:878                                     ; preds = %874
  %879 = load double* %eta, align 8
  %880 = load i32* %j, align 4
  %881 = sext i32 %880 to i64
  %882 = getelementptr inbounds [11 x double]* %DeltaH1, i32 0, i64 %881
  %883 = load double* %882, align 8
  %884 = fmul double %879, %883
  %885 = load double* %alpha, align 8
  %886 = load i32* %j, align 4
  %887 = sext i32 %886 to i64
  %888 = getelementptr inbounds [11 x double]* %196, i64 0
  %889 = getelementptr inbounds [11 x double]* %888, i32 0, i64 %887
  %890 = load double* %889, align 8
  %891 = fmul double %885, %890
  %892 = fadd double %884, %891
  %893 = load i32* %j, align 4
  %894 = sext i32 %893 to i64
  %895 = getelementptr inbounds [11 x double]* %196, i64 0
  %896 = getelementptr inbounds [11 x double]* %895, i32 0, i64 %894
  store double %892, double* %896, align 8
  %897 = load i32* %j, align 4
  %898 = sext i32 %897 to i64
  %899 = getelementptr inbounds [11 x double]* %196, i64 0
  %900 = getelementptr inbounds [11 x double]* %899, i32 0, i64 %898
  %901 = load double* %900, align 8
  %902 = load i32* %j, align 4
  %903 = sext i32 %902 to i64
  %904 = getelementptr inbounds [11 x double]* %156, i64 0
  %905 = getelementptr inbounds [11 x double]* %904, i32 0, i64 %903
  %906 = load double* %905, align 8
  %907 = fadd double %906, %901
  store double %907, double* %905, align 8
  store i32 1, i32* %i, align 4
  br label %908

; <label>:908                                     ; preds = %959, %878
  %909 = load i32* %i, align 4
  %910 = load i32* %NumInput, align 4
  %911 = icmp sle i32 %909, %910
  br i1 %911, label %912, label %962

; <label>:912                                     ; preds = %908
  %913 = load double* %eta, align 8
  %914 = load i32* %i, align 4
  %915 = sext i32 %914 to i64
  %916 = load i32* %p, align 4
  %917 = sext i32 %916 to i64
  %918 = mul nsw i64 %917, %23
  %919 = getelementptr inbounds double* %25, i64 %918
  %920 = getelementptr inbounds double* %919, i64 %915
  %921 = load double* %920, align 8
  %922 = fmul double %913, %921
  %923 = load i32* %j, align 4
  %924 = sext i32 %923 to i64
  %925 = getelementptr inbounds [11 x double]* %DeltaH1, i32 0, i64 %924
  %926 = load double* %925, align 8
  %927 = fmul double %922, %926
  %928 = load double* %alpha, align 8
  %929 = load i32* %j, align 4
  %930 = sext i32 %929 to i64
  %931 = load i32* %i, align 4
  %932 = sext i32 %931 to i64
  %933 = getelementptr inbounds [11 x double]* %196, i64 %932
  %934 = getelementptr inbounds [11 x double]* %933, i32 0, i64 %930
  %935 = load double* %934, align 8
  %936 = fmul double %928, %935
  %937 = fadd double %927, %936
  %938 = load i32* %j, align 4
  %939 = sext i32 %938 to i64
  %940 = load i32* %i, align 4
  %941 = sext i32 %940 to i64
  %942 = getelementptr inbounds [11 x double]* %196, i64 %941
  %943 = getelementptr inbounds [11 x double]* %942, i32 0, i64 %939
  store double %937, double* %943, align 8
  %944 = load i32* %j, align 4
  %945 = sext i32 %944 to i64
  %946 = load i32* %i, align 4
  %947 = sext i32 %946 to i64
  %948 = getelementptr inbounds [11 x double]* %196, i64 %947
  %949 = getelementptr inbounds [11 x double]* %948, i32 0, i64 %945
  %950 = load double* %949, align 8
  %951 = load i32* %j, align 4
  %952 = sext i32 %951 to i64
  %953 = load i32* %i, align 4
  %954 = sext i32 %953 to i64
  %955 = getelementptr inbounds [11 x double]* %156, i64 %954
  %956 = getelementptr inbounds [11 x double]* %955, i32 0, i64 %952
  %957 = load double* %956, align 8
  %958 = fadd double %957, %950
  store double %958, double* %956, align 8
  br label %959

; <label>:959                                     ; preds = %912
  %960 = load i32* %i, align 4
  %961 = add nsw i32 %960, 1
  store i32 %961, i32* %i, align 4
  br label %908

; <label>:962                                     ; preds = %908
  br label %963

; <label>:963                                     ; preds = %962
  %964 = load i32* %j, align 4
  %965 = add nsw i32 %964, 1
  store i32 %965, i32* %j, align 4
  br label %874

; <label>:966                                     ; preds = %874
  store i32 1, i32* %j, align 4
  br label %967

; <label>:967                                     ; preds = %1055, %966
  %968 = load i32* %j, align 4
  %969 = load i32* %NumHidden2, align 4
  %970 = icmp sle i32 %968, %969
  br i1 %970, label %971, label %1058

; <label>:971                                     ; preds = %967
  %972 = load double* %eta, align 8
  %973 = load i32* %j, align 4
  %974 = sext i32 %973 to i64
  %975 = getelementptr inbounds [11 x double]* %DeltaH2, i32 0, i64 %974
  %976 = load double* %975, align 8
  %977 = fmul double %972, %976
  %978 = load double* %alpha, align 8
  %979 = load i32* %j, align 4
  %980 = sext i32 %979 to i64
  %981 = getelementptr inbounds [11 x double]* %200, i64 0
  %982 = getelementptr inbounds [11 x double]* %981, i32 0, i64 %980
  %983 = load double* %982, align 8
  %984 = fmul double %978, %983
  %985 = fadd double %977, %984
  %986 = load i32* %j, align 4
  %987 = sext i32 %986 to i64
  %988 = getelementptr inbounds [11 x double]* %200, i64 0
  %989 = getelementptr inbounds [11 x double]* %988, i32 0, i64 %987
  store double %985, double* %989, align 8
  %990 = load i32* %j, align 4
  %991 = sext i32 %990 to i64
  %992 = getelementptr inbounds [11 x double]* %200, i64 0
  %993 = getelementptr inbounds [11 x double]* %992, i32 0, i64 %991
  %994 = load double* %993, align 8
  %995 = load i32* %j, align 4
  %996 = sext i32 %995 to i64
  %997 = getelementptr inbounds [11 x double]* %176, i64 0
  %998 = getelementptr inbounds [11 x double]* %997, i32 0, i64 %996
  %999 = load double* %998, align 8
  %1000 = fadd double %999, %994
  store double %1000, double* %998, align 8
  store i32 1, i32* %i, align 4
  br label %1001

; <label>:1001                                    ; preds = %1051, %971
  %1002 = load i32* %i, align 4
  %1003 = load i32* %NumHidden1, align 4
  %1004 = icmp sle i32 %1002, %1003
  br i1 %1004, label %1005, label %1054

; <label>:1005                                    ; preds = %1001
  %1006 = load double* %eta, align 8
  %1007 = load i32* %i, align 4
  %1008 = sext i32 %1007 to i64
  %1009 = load i32* %p, align 4
  %1010 = sext i32 %1009 to i64
  %1011 = getelementptr inbounds [11 x double]* %160, i64 %1010
  %1012 = getelementptr inbounds [11 x double]* %1011, i32 0, i64 %1008
  %1013 = load double* %1012, align 8
  %1014 = fmul double %1006, %1013
  %1015 = load i32* %j, align 4
  %1016 = sext i32 %1015 to i64
  %1017 = getelementptr inbounds [11 x double]* %DeltaH2, i32 0, i64 %1016
  %1018 = load double* %1017, align 8
  %1019 = fmul double %1014, %1018
  %1020 = load double* %alpha, align 8
  %1021 = load i32* %j, align 4
  %1022 = sext i32 %1021 to i64
  %1023 = load i32* %i, align 4
  %1024 = sext i32 %1023 to i64
  %1025 = getelementptr inbounds [11 x double]* %200, i64 %1024
  %1026 = getelementptr inbounds [11 x double]* %1025, i32 0, i64 %1022
  %1027 = load double* %1026, align 8
  %1028 = fmul double %1020, %1027
  %1029 = fadd double %1019, %1028
  %1030 = load i32* %j, align 4
  %1031 = sext i32 %1030 to i64
  %1032 = load i32* %i, align 4
  %1033 = sext i32 %1032 to i64
  %1034 = getelementptr inbounds [11 x double]* %200, i64 %1033
  %1035 = getelementptr inbounds [11 x double]* %1034, i32 0, i64 %1031
  store double %1029, double* %1035, align 8
  %1036 = load i32* %j, align 4
  %1037 = sext i32 %1036 to i64
  %1038 = load i32* %i, align 4
  %1039 = sext i32 %1038 to i64
  %1040 = getelementptr inbounds [11 x double]* %200, i64 %1039
  %1041 = getelementptr inbounds [11 x double]* %1040, i32 0, i64 %1037
  %1042 = load double* %1041, align 8
  %1043 = load i32* %j, align 4
  %1044 = sext i32 %1043 to i64
  %1045 = load i32* %i, align 4
  %1046 = sext i32 %1045 to i64
  %1047 = getelementptr inbounds [11 x double]* %176, i64 %1046
  %1048 = getelementptr inbounds [11 x double]* %1047, i32 0, i64 %1044
  %1049 = load double* %1048, align 8
  %1050 = fadd double %1049, %1042
  store double %1050, double* %1048, align 8
  br label %1051

; <label>:1051                                    ; preds = %1005
  %1052 = load i32* %i, align 4
  %1053 = add nsw i32 %1052, 1
  store i32 %1053, i32* %i, align 4
  br label %1001

; <label>:1054                                    ; preds = %1001
  br label %1055

; <label>:1055                                    ; preds = %1054
  %1056 = load i32* %j, align 4
  %1057 = add nsw i32 %1056, 1
  store i32 %1057, i32* %j, align 4
  br label %967

; <label>:1058                                    ; preds = %967
  store i32 1, i32* %j, align 4
  br label %1059

; <label>:1059                                    ; preds = %1147, %1058
  %1060 = load i32* %j, align 4
  %1061 = load i32* %NumHidden3, align 4
  %1062 = icmp sle i32 %1060, %1061
  br i1 %1062, label %1063, label %1150

; <label>:1063                                    ; preds = %1059
  %1064 = load double* %eta, align 8
  %1065 = load i32* %j, align 4
  %1066 = sext i32 %1065 to i64
  %1067 = getelementptr inbounds [11 x double]* %DeltaH3, i32 0, i64 %1066
  %1068 = load double* %1067, align 8
  %1069 = fmul double %1064, %1068
  %1070 = load double* %alpha, align 8
  %1071 = load i32* %j, align 4
  %1072 = sext i32 %1071 to i64
  %1073 = getelementptr inbounds [11 x double]* %204, i64 0
  %1074 = getelementptr inbounds [11 x double]* %1073, i32 0, i64 %1072
  %1075 = load double* %1074, align 8
  %1076 = fmul double %1070, %1075
  %1077 = fadd double %1069, %1076
  %1078 = load i32* %j, align 4
  %1079 = sext i32 %1078 to i64
  %1080 = getelementptr inbounds [11 x double]* %204, i64 0
  %1081 = getelementptr inbounds [11 x double]* %1080, i32 0, i64 %1079
  store double %1077, double* %1081, align 8
  %1082 = load i32* %j, align 4
  %1083 = sext i32 %1082 to i64
  %1084 = getelementptr inbounds [11 x double]* %204, i64 0
  %1085 = getelementptr inbounds [11 x double]* %1084, i32 0, i64 %1083
  %1086 = load double* %1085, align 8
  %1087 = load i32* %j, align 4
  %1088 = sext i32 %1087 to i64
  %1089 = getelementptr inbounds [11 x double]* %184, i64 0
  %1090 = getelementptr inbounds [11 x double]* %1089, i32 0, i64 %1088
  %1091 = load double* %1090, align 8
  %1092 = fadd double %1091, %1086
  store double %1092, double* %1090, align 8
  store i32 1, i32* %i, align 4
  br label %1093

; <label>:1093                                    ; preds = %1143, %1063
  %1094 = load i32* %i, align 4
  %1095 = load i32* %NumHidden2, align 4
  %1096 = icmp sle i32 %1094, %1095
  br i1 %1096, label %1097, label %1146

; <label>:1097                                    ; preds = %1093
  %1098 = load double* %eta, align 8
  %1099 = load i32* %i, align 4
  %1100 = sext i32 %1099 to i64
  %1101 = load i32* %p, align 4
  %1102 = sext i32 %1101 to i64
  %1103 = getelementptr inbounds [11 x double]* %164, i64 %1102
  %1104 = getelementptr inbounds [11 x double]* %1103, i32 0, i64 %1100
  %1105 = load double* %1104, align 8
  %1106 = fmul double %1098, %1105
  %1107 = load i32* %j, align 4
  %1108 = sext i32 %1107 to i64
  %1109 = getelementptr inbounds [11 x double]* %DeltaH3, i32 0, i64 %1108
  %1110 = load double* %1109, align 8
  %1111 = fmul double %1106, %1110
  %1112 = load double* %alpha, align 8
  %1113 = load i32* %j, align 4
  %1114 = sext i32 %1113 to i64
  %1115 = load i32* %i, align 4
  %1116 = sext i32 %1115 to i64
  %1117 = getelementptr inbounds [11 x double]* %204, i64 %1116
  %1118 = getelementptr inbounds [11 x double]* %1117, i32 0, i64 %1114
  %1119 = load double* %1118, align 8
  %1120 = fmul double %1112, %1119
  %1121 = fadd double %1111, %1120
  %1122 = load i32* %j, align 4
  %1123 = sext i32 %1122 to i64
  %1124 = load i32* %i, align 4
  %1125 = sext i32 %1124 to i64
  %1126 = getelementptr inbounds [11 x double]* %204, i64 %1125
  %1127 = getelementptr inbounds [11 x double]* %1126, i32 0, i64 %1123
  store double %1121, double* %1127, align 8
  %1128 = load i32* %j, align 4
  %1129 = sext i32 %1128 to i64
  %1130 = load i32* %i, align 4
  %1131 = sext i32 %1130 to i64
  %1132 = getelementptr inbounds [11 x double]* %204, i64 %1131
  %1133 = getelementptr inbounds [11 x double]* %1132, i32 0, i64 %1129
  %1134 = load double* %1133, align 8
  %1135 = load i32* %j, align 4
  %1136 = sext i32 %1135 to i64
  %1137 = load i32* %i, align 4
  %1138 = sext i32 %1137 to i64
  %1139 = getelementptr inbounds [11 x double]* %184, i64 %1138
  %1140 = getelementptr inbounds [11 x double]* %1139, i32 0, i64 %1136
  %1141 = load double* %1140, align 8
  %1142 = fadd double %1141, %1134
  store double %1142, double* %1140, align 8
  br label %1143

; <label>:1143                                    ; preds = %1097
  %1144 = load i32* %i, align 4
  %1145 = add nsw i32 %1144, 1
  store i32 %1145, i32* %i, align 4
  br label %1093

; <label>:1146                                    ; preds = %1093
  br label %1147

; <label>:1147                                    ; preds = %1146
  %1148 = load i32* %j, align 4
  %1149 = add nsw i32 %1148, 1
  store i32 %1149, i32* %j, align 4
  br label %1059

; <label>:1150                                    ; preds = %1059
  store i32 1, i32* %k, align 4
  br label %1151

; <label>:1151                                    ; preds = %1239, %1150
  %1152 = load i32* %k, align 4
  %1153 = load i32* %NumOutput, align 4
  %1154 = icmp sle i32 %1152, %1153
  br i1 %1154, label %1155, label %1242

; <label>:1155                                    ; preds = %1151
  %1156 = load double* %eta, align 8
  %1157 = load i32* %k, align 4
  %1158 = sext i32 %1157 to i64
  %1159 = getelementptr inbounds [2 x double]* %DeltaO, i32 0, i64 %1158
  %1160 = load double* %1159, align 8
  %1161 = fmul double %1156, %1160
  %1162 = load double* %alpha, align 8
  %1163 = load i32* %k, align 4
  %1164 = sext i32 %1163 to i64
  %1165 = getelementptr inbounds [11 x [2 x double]]* %DeltaWeightHO, i32 0, i64 0
  %1166 = getelementptr inbounds [2 x double]* %1165, i32 0, i64 %1164
  %1167 = load double* %1166, align 8
  %1168 = fmul double %1162, %1167
  %1169 = fadd double %1161, %1168
  %1170 = load i32* %k, align 4
  %1171 = sext i32 %1170 to i64
  %1172 = getelementptr inbounds [11 x [2 x double]]* %DeltaWeightHO, i32 0, i64 0
  %1173 = getelementptr inbounds [2 x double]* %1172, i32 0, i64 %1171
  store double %1169, double* %1173, align 8
  %1174 = load i32* %k, align 4
  %1175 = sext i32 %1174 to i64
  %1176 = getelementptr inbounds [11 x [2 x double]]* %DeltaWeightHO, i32 0, i64 0
  %1177 = getelementptr inbounds [2 x double]* %1176, i32 0, i64 %1175
  %1178 = load double* %1177, align 8
  %1179 = load i32* %k, align 4
  %1180 = sext i32 %1179 to i64
  %1181 = getelementptr inbounds [11 x [2 x double]]* %WeightHO, i32 0, i64 0
  %1182 = getelementptr inbounds [2 x double]* %1181, i32 0, i64 %1180
  %1183 = load double* %1182, align 8
  %1184 = fadd double %1183, %1178
  store double %1184, double* %1182, align 8
  store i32 1, i32* %j, align 4
  br label %1185

; <label>:1185                                    ; preds = %1235, %1155
  %1186 = load i32* %j, align 4
  %1187 = load i32* %NumHidden3, align 4
  %1188 = icmp sle i32 %1186, %1187
  br i1 %1188, label %1189, label %1238

; <label>:1189                                    ; preds = %1185
  %1190 = load double* %eta, align 8
  %1191 = load i32* %j, align 4
  %1192 = sext i32 %1191 to i64
  %1193 = load i32* %p, align 4
  %1194 = sext i32 %1193 to i64
  %1195 = getelementptr inbounds [11 x double]* %168, i64 %1194
  %1196 = getelementptr inbounds [11 x double]* %1195, i32 0, i64 %1192
  %1197 = load double* %1196, align 8
  %1198 = fmul double %1190, %1197
  %1199 = load i32* %k, align 4
  %1200 = sext i32 %1199 to i64
  %1201 = getelementptr inbounds [2 x double]* %DeltaO, i32 0, i64 %1200
  %1202 = load double* %1201, align 8
  %1203 = fmul double %1198, %1202
  %1204 = load double* %alpha, align 8
  %1205 = load i32* %k, align 4
  %1206 = sext i32 %1205 to i64
  %1207 = load i32* %j, align 4
  %1208 = sext i32 %1207 to i64
  %1209 = getelementptr inbounds [11 x [2 x double]]* %DeltaWeightHO, i32 0, i64 %1208
  %1210 = getelementptr inbounds [2 x double]* %1209, i32 0, i64 %1206
  %1211 = load double* %1210, align 8
  %1212 = fmul double %1204, %1211
  %1213 = fadd double %1203, %1212
  %1214 = load i32* %k, align 4
  %1215 = sext i32 %1214 to i64
  %1216 = load i32* %j, align 4
  %1217 = sext i32 %1216 to i64
  %1218 = getelementptr inbounds [11 x [2 x double]]* %DeltaWeightHO, i32 0, i64 %1217
  %1219 = getelementptr inbounds [2 x double]* %1218, i32 0, i64 %1215
  store double %1213, double* %1219, align 8
  %1220 = load i32* %k, align 4
  %1221 = sext i32 %1220 to i64
  %1222 = load i32* %j, align 4
  %1223 = sext i32 %1222 to i64
  %1224 = getelementptr inbounds [11 x [2 x double]]* %DeltaWeightHO, i32 0, i64 %1223
  %1225 = getelementptr inbounds [2 x double]* %1224, i32 0, i64 %1221
  %1226 = load double* %1225, align 8
  %1227 = load i32* %k, align 4
  %1228 = sext i32 %1227 to i64
  %1229 = load i32* %j, align 4
  %1230 = sext i32 %1229 to i64
  %1231 = getelementptr inbounds [11 x [2 x double]]* %WeightHO, i32 0, i64 %1230
  %1232 = getelementptr inbounds [2 x double]* %1231, i32 0, i64 %1228
  %1233 = load double* %1232, align 8
  %1234 = fadd double %1233, %1226
  store double %1234, double* %1232, align 8
  br label %1235

; <label>:1235                                    ; preds = %1189
  %1236 = load i32* %j, align 4
  %1237 = add nsw i32 %1236, 1
  store i32 %1237, i32* %j, align 4
  br label %1185

; <label>:1238                                    ; preds = %1185
  br label %1239

; <label>:1239                                    ; preds = %1238
  %1240 = load i32* %k, align 4
  %1241 = add nsw i32 %1240, 1
  store i32 %1241, i32* %k, align 4
  br label %1151

; <label>:1242                                    ; preds = %1151
  br label %1243

; <label>:1243                                    ; preds = %1242
  %1244 = load i32* %np, align 4
  %1245 = add nsw i32 %1244, 1
  store i32 %1245, i32* %np, align 4
  br label %352

; <label>:1246                                    ; preds = %352
  %1247 = load i32* %epoch, align 4
  %1248 = srem i32 %1247, 100
  %1249 = icmp eq i32 %1248, 0
  br i1 %1249, label %1250, label %1254

; <label>:1250                                    ; preds = %1246
  %1251 = load i32* %epoch, align 4
  %1252 = load double* %Error, align 8
  %1253 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([27 x i8]* @.str, i32 0, i32 0), i32 %1251, double %1252)
  br label %1254

; <label>:1254                                    ; preds = %1250, %1246
  br label %1255

; <label>:1255                                    ; preds = %1254
  %1256 = load i32* %epoch, align 4
  %1257 = add nsw i32 %1256, 1
  store i32 %1257, i32* %epoch, align 4
  br label %347

; <label>:1258                                    ; preds = %347
  br label %1259

; <label>:1259                                    ; preds = %1258
  %1260 = load i32* %yt, align 4
  %1261 = load i32* %batchSize, align 4
  %1262 = add nsw i32 %1260, %1261
  store i32 %1262, i32* %yt, align 4
  br label %342

; <label>:1263                                    ; preds = %342
  br label %1264

; <label>:1264                                    ; preds = %1263
  %1265 = load i32* %epoch1, align 4
  %1266 = add nsw i32 %1265, 1
  store i32 %1266, i32* %epoch1, align 4
  br label %338

; <label>:1267                                    ; preds = %338
  store i32 1, i32* %k, align 4
  br label %1268

; <label>:1268                                    ; preds = %1276, %1267
  %1269 = load i32* %k, align 4
  %1270 = load i32* %NumOutput, align 4
  %1271 = icmp sle i32 %1269, %1270
  br i1 %1271, label %1272, label %1279

; <label>:1272                                    ; preds = %1268
  %1273 = load i32* %k, align 4
  %1274 = load i32* %k, align 4
  %1275 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([23 x i8]* @.str1, i32 0, i32 0), i32 %1273, i32 %1274)
  br label %1276

; <label>:1276                                    ; preds = %1272
  %1277 = load i32* %k, align 4
  %1278 = add nsw i32 %1277, 1
  store i32 %1278, i32* %k, align 4
  br label %1268

; <label>:1279                                    ; preds = %1268
  store i32 1, i32* %p, align 4
  br label %1280

; <label>:1280                                    ; preds = %1309, %1279
  %1281 = load i32* %p, align 4
  %1282 = load i32* %NumPattern, align 4
  %1283 = icmp sle i32 %1281, %1282
  br i1 %1283, label %1284, label %1312

; <label>:1284                                    ; preds = %1280
  store i32 1, i32* %k, align 4
  br label %1285

; <label>:1285                                    ; preds = %1305, %1284
  %1286 = load i32* %k, align 4
  %1287 = load i32* %NumOutput, align 4
  %1288 = icmp sle i32 %1286, %1287
  br i1 %1288, label %1289, label %1308

; <label>:1289                                    ; preds = %1285
  %1290 = load i32* %k, align 4
  %1291 = sext i32 %1290 to i64
  %1292 = load i32* %p, align 4
  %1293 = sext i32 %1292 to i64
  %1294 = getelementptr inbounds [2 x double]* %29, i64 %1293
  %1295 = getelementptr inbounds [2 x double]* %1294, i32 0, i64 %1291
  %1296 = load double* %1295, align 8
  %1297 = load i32* %k, align 4
  %1298 = sext i32 %1297 to i64
  %1299 = load i32* %p, align 4
  %1300 = sext i32 %1299 to i64
  %1301 = getelementptr inbounds [2 x double]* %192, i64 %1300
  %1302 = getelementptr inbounds [2 x double]* %1301, i32 0, i64 %1298
  %1303 = load double* %1302, align 8
  %1304 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([8 x i8]* @.str2, i32 0, i32 0), double %1296, double %1303)
  br label %1305

; <label>:1305                                    ; preds = %1289
  %1306 = load i32* %k, align 4
  %1307 = add nsw i32 %1306, 1
  store i32 %1307, i32* %k, align 4
  br label %1285

; <label>:1308                                    ; preds = %1285
  br label %1309

; <label>:1309                                    ; preds = %1308
  %1310 = load i32* %p, align 4
  %1311 = add nsw i32 %1310, 1
  store i32 %1311, i32* %p, align 4
  br label %1280

; <label>:1312                                    ; preds = %1280
  %1313 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([20 x i8]* @.str3, i32 0, i32 0))
  store i32 0, i32* %index, align 4
  store i32 0, i32* %i, align 4
  br label %1314

; <label>:1314                                    ; preds = %1334, %1312
  %1315 = load i32* %i, align 4
  %1316 = icmp sle i32 %1315, 64
  br i1 %1316, label %1317, label %1337

; <label>:1317                                    ; preds = %1314
  store i32 0, i32* %j, align 4
  br label %1318

; <label>:1318                                    ; preds = %1330, %1317
  %1319 = load i32* %j, align 4
  %1320 = load i32* %NUMIN, align 4
  %1321 = icmp sle i32 %1319, %1320
  br i1 %1321, label %1322, label %1333

; <label>:1322                                    ; preds = %1318
  %1323 = load i32* %j, align 4
  %1324 = sext i32 %1323 to i64
  %1325 = load i32* %i, align 4
  %1326 = sext i32 %1325 to i64
  %1327 = mul nsw i64 %1326, %23
  %1328 = getelementptr inbounds double* %25, i64 %1327
  %1329 = getelementptr inbounds double* %1328, i64 %1324
  store double 0.000000e+00, double* %1329, align 8
  br label %1330

; <label>:1330                                    ; preds = %1322
  %1331 = load i32* %j, align 4
  %1332 = add nsw i32 %1331, 1
  store i32 %1332, i32* %j, align 4
  br label %1318

; <label>:1333                                    ; preds = %1318
  br label %1334

; <label>:1334                                    ; preds = %1333
  %1335 = load i32* %i, align 4
  %1336 = add nsw i32 %1335, 1
  store i32 %1336, i32* %i, align 4
  br label %1314

; <label>:1337                                    ; preds = %1314
  store i32 1, i32* %i, align 4
  br label %1338

; <label>:1338                                    ; preds = %1365, %1337
  %1339 = load i32* %i, align 4
  %1340 = icmp sle i32 %1339, 64
  br i1 %1340, label %1341, label %1368

; <label>:1341                                    ; preds = %1338
  store i32 1, i32* %j, align 4
  br label %1342

; <label>:1342                                    ; preds = %1361, %1341
  %1343 = load i32* %j, align 4
  %1344 = load i32* %NUMIN, align 4
  %1345 = icmp sle i32 %1343, %1344
  br i1 %1345, label %1346, label %1364

; <label>:1346                                    ; preds = %1342
  %1347 = load i32* %index, align 4
  %1348 = sext i32 %1347 to i64
  %1349 = load double** %6, align 8
  %1350 = getelementptr inbounds double* %1349, i64 %1348
  %1351 = load double* %1350, align 8
  %1352 = load i32* %j, align 4
  %1353 = sext i32 %1352 to i64
  %1354 = load i32* %i, align 4
  %1355 = sext i32 %1354 to i64
  %1356 = mul nsw i64 %1355, %23
  %1357 = getelementptr inbounds double* %25, i64 %1356
  %1358 = getelementptr inbounds double* %1357, i64 %1353
  store double %1351, double* %1358, align 8
  %1359 = load i32* %index, align 4
  %1360 = add nsw i32 %1359, 1
  store i32 %1360, i32* %index, align 4
  br label %1361

; <label>:1361                                    ; preds = %1346
  %1362 = load i32* %j, align 4
  %1363 = add nsw i32 %1362, 1
  store i32 %1363, i32* %j, align 4
  br label %1342

; <label>:1364                                    ; preds = %1342
  br label %1365

; <label>:1365                                    ; preds = %1364
  %1366 = load i32* %i, align 4
  %1367 = add nsw i32 %1366, 1
  store i32 %1367, i32* %i, align 4
  br label %1338

; <label>:1368                                    ; preds = %1338
  store i32 0, i32* %index, align 4
  store i32 0, i32* %i, align 4
  br label %1369

; <label>:1369                                    ; preds = %1387, %1368
  %1370 = load i32* %i, align 4
  %1371 = icmp sle i32 %1370, 64
  br i1 %1371, label %1372, label %1390

; <label>:1372                                    ; preds = %1369
  store i32 0, i32* %j, align 4
  br label %1373

; <label>:1373                                    ; preds = %1383, %1372
  %1374 = load i32* %j, align 4
  %1375 = icmp sle i32 %1374, 1
  br i1 %1375, label %1376, label %1386

; <label>:1376                                    ; preds = %1373
  %1377 = load i32* %j, align 4
  %1378 = sext i32 %1377 to i64
  %1379 = load i32* %i, align 4
  %1380 = sext i32 %1379 to i64
  %1381 = getelementptr inbounds [2 x double]* %29, i64 %1380
  %1382 = getelementptr inbounds [2 x double]* %1381, i32 0, i64 %1378
  store double 0.000000e+00, double* %1382, align 8
  br label %1383

; <label>:1383                                    ; preds = %1376
  %1384 = load i32* %j, align 4
  %1385 = add nsw i32 %1384, 1
  store i32 %1385, i32* %j, align 4
  br label %1373

; <label>:1386                                    ; preds = %1373
  br label %1387

; <label>:1387                                    ; preds = %1386
  %1388 = load i32* %i, align 4
  %1389 = add nsw i32 %1388, 1
  store i32 %1389, i32* %i, align 4
  br label %1369

; <label>:1390                                    ; preds = %1369
  store i32 1, i32* %i, align 4
  br label %1391

; <label>:1391                                    ; preds = %1416, %1390
  %1392 = load i32* %i, align 4
  %1393 = icmp sle i32 %1392, 64
  br i1 %1393, label %1394, label %1419

; <label>:1394                                    ; preds = %1391
  store i32 1, i32* %j, align 4
  br label %1395

; <label>:1395                                    ; preds = %1412, %1394
  %1396 = load i32* %j, align 4
  %1397 = icmp sle i32 %1396, 1
  br i1 %1397, label %1398, label %1415

; <label>:1398                                    ; preds = %1395
  %1399 = load i32* %index, align 4
  %1400 = sext i32 %1399 to i64
  %1401 = load double** %7, align 8
  %1402 = getelementptr inbounds double* %1401, i64 %1400
  %1403 = load double* %1402, align 8
  %1404 = load i32* %j, align 4
  %1405 = sext i32 %1404 to i64
  %1406 = load i32* %i, align 4
  %1407 = sext i32 %1406 to i64
  %1408 = getelementptr inbounds [2 x double]* %29, i64 %1407
  %1409 = getelementptr inbounds [2 x double]* %1408, i32 0, i64 %1405
  store double %1403, double* %1409, align 8
  %1410 = load i32* %index, align 4
  %1411 = add nsw i32 %1410, 1
  store i32 %1411, i32* %index, align 4
  br label %1412

; <label>:1412                                    ; preds = %1398
  %1413 = load i32* %j, align 4
  %1414 = add nsw i32 %1413, 1
  store i32 %1414, i32* %j, align 4
  br label %1395

; <label>:1415                                    ; preds = %1395
  br label %1416

; <label>:1416                                    ; preds = %1415
  %1417 = load i32* %i, align 4
  %1418 = add nsw i32 %1417, 1
  store i32 %1418, i32* %i, align 4
  br label %1391

; <label>:1419                                    ; preds = %1391
  store i32 1, i32* %p, align 4
  br label %1420

; <label>:1420                                    ; preds = %1433, %1419
  %1421 = load i32* %p, align 4
  %1422 = icmp sle i32 %1421, 64
  br i1 %1422, label %1423, label %1436

; <label>:1423                                    ; preds = %1420
  store i32 1, i32* %k, align 4
  br label %1424

; <label>:1424                                    ; preds = %1429, %1423
  %1425 = load i32* %k, align 4
  %1426 = load i32* %NumOutput, align 4
  %1427 = icmp sle i32 %1425, %1426
  br i1 %1427, label %1428, label %1432

; <label>:1428                                    ; preds = %1424
  br label %1429

; <label>:1429                                    ; preds = %1428
  %1430 = load i32* %k, align 4
  %1431 = add nsw i32 %1430, 1
  store i32 %1431, i32* %k, align 4
  br label %1424

; <label>:1432                                    ; preds = %1424
  br label %1433

; <label>:1433                                    ; preds = %1432
  %1434 = load i32* %p, align 4
  %1435 = add nsw i32 %1434, 1
  store i32 %1435, i32* %p, align 4
  br label %1420

; <label>:1436                                    ; preds = %1420
  store i32 1, i32* %np, align 4
  br label %1437

; <label>:1437                                    ; preds = %1714, %1436
  %1438 = load i32* %np, align 4
  %1439 = icmp sle i32 %1438, 64
  br i1 %1439, label %1440, label %1717

; <label>:1440                                    ; preds = %1437
  store i32 1, i32* %j, align 4
  br label %1441

; <label>:1441                                    ; preds = %1507, %1440
  %1442 = load i32* %j, align 4
  %1443 = load i32* %NumHidden1, align 4
  %1444 = icmp sle i32 %1442, %1443
  br i1 %1444, label %1445, label %1510

; <label>:1445                                    ; preds = %1441
  %1446 = load i32* %j, align 4
  %1447 = sext i32 %1446 to i64
  %1448 = getelementptr inbounds [11 x double]* %156, i64 0
  %1449 = getelementptr inbounds [11 x double]* %1448, i32 0, i64 %1447
  %1450 = load double* %1449, align 8
  %1451 = load i32* %j, align 4
  %1452 = sext i32 %1451 to i64
  %1453 = load i32* %p, align 4
  %1454 = sext i32 %1453 to i64
  %1455 = getelementptr inbounds [11 x double]* %152, i64 %1454
  %1456 = getelementptr inbounds [11 x double]* %1455, i32 0, i64 %1452
  store double %1450, double* %1456, align 8
  store i32 1, i32* %i, align 4
  br label %1457

; <label>:1457                                    ; preds = %1486, %1445
  %1458 = load i32* %i, align 4
  %1459 = load i32* %NumInput, align 4
  %1460 = icmp sle i32 %1458, %1459
  br i1 %1460, label %1461, label %1489

; <label>:1461                                    ; preds = %1457
  %1462 = load i32* %i, align 4
  %1463 = sext i32 %1462 to i64
  %1464 = load i32* %p, align 4
  %1465 = sext i32 %1464 to i64
  %1466 = mul nsw i64 %1465, %23
  %1467 = getelementptr inbounds double* %25, i64 %1466
  %1468 = getelementptr inbounds double* %1467, i64 %1463
  %1469 = load double* %1468, align 8
  %1470 = load i32* %j, align 4
  %1471 = sext i32 %1470 to i64
  %1472 = load i32* %i, align 4
  %1473 = sext i32 %1472 to i64
  %1474 = getelementptr inbounds [11 x double]* %156, i64 %1473
  %1475 = getelementptr inbounds [11 x double]* %1474, i32 0, i64 %1471
  %1476 = load double* %1475, align 8
  %1477 = fmul double %1469, %1476
  %1478 = load i32* %j, align 4
  %1479 = sext i32 %1478 to i64
  %1480 = load i32* %p, align 4
  %1481 = sext i32 %1480 to i64
  %1482 = getelementptr inbounds [11 x double]* %152, i64 %1481
  %1483 = getelementptr inbounds [11 x double]* %1482, i32 0, i64 %1479
  %1484 = load double* %1483, align 8
  %1485 = fadd double %1484, %1477
  store double %1485, double* %1483, align 8
  br label %1486

; <label>:1486                                    ; preds = %1461
  %1487 = load i32* %i, align 4
  %1488 = add nsw i32 %1487, 1
  store i32 %1488, i32* %i, align 4
  br label %1457

; <label>:1489                                    ; preds = %1457
  %1490 = load i32* %j, align 4
  %1491 = sext i32 %1490 to i64
  %1492 = load i32* %p, align 4
  %1493 = sext i32 %1492 to i64
  %1494 = getelementptr inbounds [11 x double]* %152, i64 %1493
  %1495 = getelementptr inbounds [11 x double]* %1494, i32 0, i64 %1491
  %1496 = load double* %1495, align 8
  %1497 = fsub double -0.000000e+00, %1496
  %1498 = call double @exponential(i32 10, double %1497)
  %1499 = fadd double 1.000000e+00, %1498
  %1500 = fdiv double 1.000000e+00, %1499
  %1501 = load i32* %j, align 4
  %1502 = sext i32 %1501 to i64
  %1503 = load i32* %p, align 4
  %1504 = sext i32 %1503 to i64
  %1505 = getelementptr inbounds [11 x double]* %160, i64 %1504
  %1506 = getelementptr inbounds [11 x double]* %1505, i32 0, i64 %1502
  store double %1500, double* %1506, align 8
  br label %1507

; <label>:1507                                    ; preds = %1489
  %1508 = load i32* %j, align 4
  %1509 = add nsw i32 %1508, 1
  store i32 %1509, i32* %j, align 4
  br label %1441

; <label>:1510                                    ; preds = %1441
  store i32 1, i32* %j, align 4
  br label %1511

; <label>:1511                                    ; preds = %1576, %1510
  %1512 = load i32* %j, align 4
  %1513 = load i32* %NumHidden2, align 4
  %1514 = icmp sle i32 %1512, %1513
  br i1 %1514, label %1515, label %1579

; <label>:1515                                    ; preds = %1511
  %1516 = load i32* %j, align 4
  %1517 = sext i32 %1516 to i64
  %1518 = getelementptr inbounds [11 x double]* %176, i64 0
  %1519 = getelementptr inbounds [11 x double]* %1518, i32 0, i64 %1517
  %1520 = load double* %1519, align 8
  %1521 = load i32* %j, align 4
  %1522 = sext i32 %1521 to i64
  %1523 = load i32* %p, align 4
  %1524 = sext i32 %1523 to i64
  %1525 = getelementptr inbounds [11 x double]* %172, i64 %1524
  %1526 = getelementptr inbounds [11 x double]* %1525, i32 0, i64 %1522
  store double %1520, double* %1526, align 8
  store i32 1, i32* %i, align 4
  br label %1527

; <label>:1527                                    ; preds = %1555, %1515
  %1528 = load i32* %i, align 4
  %1529 = load i32* %NumHidden1, align 4
  %1530 = icmp sle i32 %1528, %1529
  br i1 %1530, label %1531, label %1558

; <label>:1531                                    ; preds = %1527
  %1532 = load i32* %i, align 4
  %1533 = sext i32 %1532 to i64
  %1534 = load i32* %p, align 4
  %1535 = sext i32 %1534 to i64
  %1536 = getelementptr inbounds [11 x double]* %160, i64 %1535
  %1537 = getelementptr inbounds [11 x double]* %1536, i32 0, i64 %1533
  %1538 = load double* %1537, align 8
  %1539 = load i32* %j, align 4
  %1540 = sext i32 %1539 to i64
  %1541 = load i32* %i, align 4
  %1542 = sext i32 %1541 to i64
  %1543 = getelementptr inbounds [11 x double]* %176, i64 %1542
  %1544 = getelementptr inbounds [11 x double]* %1543, i32 0, i64 %1540
  %1545 = load double* %1544, align 8
  %1546 = fmul double %1538, %1545
  %1547 = load i32* %j, align 4
  %1548 = sext i32 %1547 to i64
  %1549 = load i32* %p, align 4
  %1550 = sext i32 %1549 to i64
  %1551 = getelementptr inbounds [11 x double]* %172, i64 %1550
  %1552 = getelementptr inbounds [11 x double]* %1551, i32 0, i64 %1548
  %1553 = load double* %1552, align 8
  %1554 = fadd double %1553, %1546
  store double %1554, double* %1552, align 8
  br label %1555

; <label>:1555                                    ; preds = %1531
  %1556 = load i32* %i, align 4
  %1557 = add nsw i32 %1556, 1
  store i32 %1557, i32* %i, align 4
  br label %1527

; <label>:1558                                    ; preds = %1527
  %1559 = load i32* %j, align 4
  %1560 = sext i32 %1559 to i64
  %1561 = load i32* %p, align 4
  %1562 = sext i32 %1561 to i64
  %1563 = getelementptr inbounds [11 x double]* %172, i64 %1562
  %1564 = getelementptr inbounds [11 x double]* %1563, i32 0, i64 %1560
  %1565 = load double* %1564, align 8
  %1566 = fsub double -0.000000e+00, %1565
  %1567 = call double @exponential(i32 10, double %1566)
  %1568 = fadd double 1.000000e+00, %1567
  %1569 = fdiv double 1.000000e+00, %1568
  %1570 = load i32* %j, align 4
  %1571 = sext i32 %1570 to i64
  %1572 = load i32* %p, align 4
  %1573 = sext i32 %1572 to i64
  %1574 = getelementptr inbounds [11 x double]* %164, i64 %1573
  %1575 = getelementptr inbounds [11 x double]* %1574, i32 0, i64 %1571
  store double %1569, double* %1575, align 8
  br label %1576

; <label>:1576                                    ; preds = %1558
  %1577 = load i32* %j, align 4
  %1578 = add nsw i32 %1577, 1
  store i32 %1578, i32* %j, align 4
  br label %1511

; <label>:1579                                    ; preds = %1511
  store i32 1, i32* %j, align 4
  br label %1580

; <label>:1580                                    ; preds = %1645, %1579
  %1581 = load i32* %j, align 4
  %1582 = load i32* %NumHidden3, align 4
  %1583 = icmp sle i32 %1581, %1582
  br i1 %1583, label %1584, label %1648

; <label>:1584                                    ; preds = %1580
  %1585 = load i32* %j, align 4
  %1586 = sext i32 %1585 to i64
  %1587 = getelementptr inbounds [11 x double]* %184, i64 0
  %1588 = getelementptr inbounds [11 x double]* %1587, i32 0, i64 %1586
  %1589 = load double* %1588, align 8
  %1590 = load i32* %j, align 4
  %1591 = sext i32 %1590 to i64
  %1592 = load i32* %p, align 4
  %1593 = sext i32 %1592 to i64
  %1594 = getelementptr inbounds [11 x double]* %180, i64 %1593
  %1595 = getelementptr inbounds [11 x double]* %1594, i32 0, i64 %1591
  store double %1589, double* %1595, align 8
  store i32 1, i32* %i, align 4
  br label %1596

; <label>:1596                                    ; preds = %1624, %1584
  %1597 = load i32* %i, align 4
  %1598 = load i32* %NumHidden2, align 4
  %1599 = icmp sle i32 %1597, %1598
  br i1 %1599, label %1600, label %1627

; <label>:1600                                    ; preds = %1596
  %1601 = load i32* %i, align 4
  %1602 = sext i32 %1601 to i64
  %1603 = load i32* %p, align 4
  %1604 = sext i32 %1603 to i64
  %1605 = getelementptr inbounds [11 x double]* %164, i64 %1604
  %1606 = getelementptr inbounds [11 x double]* %1605, i32 0, i64 %1602
  %1607 = load double* %1606, align 8
  %1608 = load i32* %j, align 4
  %1609 = sext i32 %1608 to i64
  %1610 = load i32* %i, align 4
  %1611 = sext i32 %1610 to i64
  %1612 = getelementptr inbounds [11 x double]* %184, i64 %1611
  %1613 = getelementptr inbounds [11 x double]* %1612, i32 0, i64 %1609
  %1614 = load double* %1613, align 8
  %1615 = fmul double %1607, %1614
  %1616 = load i32* %j, align 4
  %1617 = sext i32 %1616 to i64
  %1618 = load i32* %p, align 4
  %1619 = sext i32 %1618 to i64
  %1620 = getelementptr inbounds [11 x double]* %180, i64 %1619
  %1621 = getelementptr inbounds [11 x double]* %1620, i32 0, i64 %1617
  %1622 = load double* %1621, align 8
  %1623 = fadd double %1622, %1615
  store double %1623, double* %1621, align 8
  br label %1624

; <label>:1624                                    ; preds = %1600
  %1625 = load i32* %i, align 4
  %1626 = add nsw i32 %1625, 1
  store i32 %1626, i32* %i, align 4
  br label %1596

; <label>:1627                                    ; preds = %1596
  %1628 = load i32* %j, align 4
  %1629 = sext i32 %1628 to i64
  %1630 = load i32* %p, align 4
  %1631 = sext i32 %1630 to i64
  %1632 = getelementptr inbounds [11 x double]* %180, i64 %1631
  %1633 = getelementptr inbounds [11 x double]* %1632, i32 0, i64 %1629
  %1634 = load double* %1633, align 8
  %1635 = fsub double -0.000000e+00, %1634
  %1636 = call double @exponential(i32 10, double %1635)
  %1637 = fadd double 1.000000e+00, %1636
  %1638 = fdiv double 1.000000e+00, %1637
  %1639 = load i32* %j, align 4
  %1640 = sext i32 %1639 to i64
  %1641 = load i32* %p, align 4
  %1642 = sext i32 %1641 to i64
  %1643 = getelementptr inbounds [11 x double]* %168, i64 %1642
  %1644 = getelementptr inbounds [11 x double]* %1643, i32 0, i64 %1640
  store double %1638, double* %1644, align 8
  br label %1645

; <label>:1645                                    ; preds = %1627
  %1646 = load i32* %j, align 4
  %1647 = add nsw i32 %1646, 1
  store i32 %1647, i32* %j, align 4
  br label %1580

; <label>:1648                                    ; preds = %1580
  store i32 1, i32* %k, align 4
  br label %1649

; <label>:1649                                    ; preds = %1710, %1648
  %1650 = load i32* %k, align 4
  %1651 = load i32* %NumOutput, align 4
  %1652 = icmp sle i32 %1650, %1651
  br i1 %1652, label %1653, label %1713

; <label>:1653                                    ; preds = %1649
  %1654 = load i32* %k, align 4
  %1655 = sext i32 %1654 to i64
  %1656 = getelementptr inbounds [11 x [2 x double]]* %WeightHO, i32 0, i64 0
  %1657 = getelementptr inbounds [2 x double]* %1656, i32 0, i64 %1655
  %1658 = load double* %1657, align 8
  %1659 = load i32* %k, align 4
  %1660 = sext i32 %1659 to i64
  %1661 = load i32* %p, align 4
  %1662 = sext i32 %1661 to i64
  %1663 = getelementptr inbounds [2 x double]* %188, i64 %1662
  %1664 = getelementptr inbounds [2 x double]* %1663, i32 0, i64 %1660
  store double %1658, double* %1664, align 8
  store i32 1, i32* %j, align 4
  br label %1665

; <label>:1665                                    ; preds = %1693, %1653
  %1666 = load i32* %j, align 4
  %1667 = load i32* %NumHidden3, align 4
  %1668 = icmp sle i32 %1666, %1667
  br i1 %1668, label %1669, label %1696

; <label>:1669                                    ; preds = %1665
  %1670 = load i32* %j, align 4
  %1671 = sext i32 %1670 to i64
  %1672 = load i32* %p, align 4
  %1673 = sext i32 %1672 to i64
  %1674 = getelementptr inbounds [11 x double]* %168, i64 %1673
  %1675 = getelementptr inbounds [11 x double]* %1674, i32 0, i64 %1671
  %1676 = load double* %1675, align 8
  %1677 = load i32* %k, align 4
  %1678 = sext i32 %1677 to i64
  %1679 = load i32* %j, align 4
  %1680 = sext i32 %1679 to i64
  %1681 = getelementptr inbounds [11 x [2 x double]]* %WeightHO, i32 0, i64 %1680
  %1682 = getelementptr inbounds [2 x double]* %1681, i32 0, i64 %1678
  %1683 = load double* %1682, align 8
  %1684 = fmul double %1676, %1683
  %1685 = load i32* %k, align 4
  %1686 = sext i32 %1685 to i64
  %1687 = load i32* %p, align 4
  %1688 = sext i32 %1687 to i64
  %1689 = getelementptr inbounds [2 x double]* %188, i64 %1688
  %1690 = getelementptr inbounds [2 x double]* %1689, i32 0, i64 %1686
  %1691 = load double* %1690, align 8
  %1692 = fadd double %1691, %1684
  store double %1692, double* %1690, align 8
  br label %1693

; <label>:1693                                    ; preds = %1669
  %1694 = load i32* %j, align 4
  %1695 = add nsw i32 %1694, 1
  store i32 %1695, i32* %j, align 4
  br label %1665

; <label>:1696                                    ; preds = %1665
  %1697 = load i32* %k, align 4
  %1698 = sext i32 %1697 to i64
  %1699 = load i32* %p, align 4
  %1700 = sext i32 %1699 to i64
  %1701 = getelementptr inbounds [2 x double]* %188, i64 %1700
  %1702 = getelementptr inbounds [2 x double]* %1701, i32 0, i64 %1698
  %1703 = load double* %1702, align 8
  %1704 = load i32* %k, align 4
  %1705 = sext i32 %1704 to i64
  %1706 = load i32* %p, align 4
  %1707 = sext i32 %1706 to i64
  %1708 = getelementptr inbounds [2 x double]* %192, i64 %1707
  %1709 = getelementptr inbounds [2 x double]* %1708, i32 0, i64 %1705
  store double %1703, double* %1709, align 8
  br label %1710

; <label>:1710                                    ; preds = %1696
  %1711 = load i32* %k, align 4
  %1712 = add nsw i32 %1711, 1
  store i32 %1712, i32* %k, align 4
  br label %1649

; <label>:1713                                    ; preds = %1649
  br label %1714

; <label>:1714                                    ; preds = %1713
  %1715 = load i32* %np, align 4
  %1716 = add nsw i32 %1715, 1
  store i32 %1716, i32* %np, align 4
  br label %1437

; <label>:1717                                    ; preds = %1437
  store i32 1, i32* %p, align 4
  br label %1718

; <label>:1718                                    ; preds = %1746, %1717
  %1719 = load i32* %p, align 4
  %1720 = icmp sle i32 %1719, 64
  br i1 %1720, label %1721, label %1749

; <label>:1721                                    ; preds = %1718
  store i32 1, i32* %k, align 4
  br label %1722

; <label>:1722                                    ; preds = %1742, %1721
  %1723 = load i32* %k, align 4
  %1724 = load i32* %NumOutput, align 4
  %1725 = icmp sle i32 %1723, %1724
  br i1 %1725, label %1726, label %1745

; <label>:1726                                    ; preds = %1722
  %1727 = load i32* %k, align 4
  %1728 = sext i32 %1727 to i64
  %1729 = load i32* %p, align 4
  %1730 = sext i32 %1729 to i64
  %1731 = getelementptr inbounds [2 x double]* %29, i64 %1730
  %1732 = getelementptr inbounds [2 x double]* %1731, i32 0, i64 %1728
  %1733 = load double* %1732, align 8
  %1734 = load i32* %k, align 4
  %1735 = sext i32 %1734 to i64
  %1736 = load i32* %p, align 4
  %1737 = sext i32 %1736 to i64
  %1738 = getelementptr inbounds [2 x double]* %192, i64 %1737
  %1739 = getelementptr inbounds [2 x double]* %1738, i32 0, i64 %1735
  %1740 = load double* %1739, align 8
  %1741 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([8 x i8]* @.str2, i32 0, i32 0), double %1733, double %1740)
  br label %1742

; <label>:1742                                    ; preds = %1726
  %1743 = load i32* %k, align 4
  %1744 = add nsw i32 %1743, 1
  store i32 %1744, i32* %k, align 4
  br label %1722

; <label>:1745                                    ; preds = %1722
  br label %1746

; <label>:1746                                    ; preds = %1745
  %1747 = load i32* %p, align 4
  %1748 = add nsw i32 %1747, 1
  store i32 %1748, i32* %p, align 4
  br label %1718

; <label>:1749                                    ; preds = %1718
  %1750 = load i32* %3, align 4
  %1751 = icmp eq i32 %1750, 1
  br i1 %1751, label %1752, label %1818

; <label>:1752                                    ; preds = %1749
  store float 1.000000e+00, float* %min, align 4
  store float 1.000000e+00, float* %min1, align 4
  store i32 1, i32* %p, align 4
  br label %1753

; <label>:1753                                    ; preds = %1810, %1752
  %1754 = load i32* %p, align 4
  %1755 = icmp sle i32 %1754, 64
  br i1 %1755, label %1756, label %1813

; <label>:1756                                    ; preds = %1753
  store i32 1, i32* %k, align 4
  br label %1757

; <label>:1757                                    ; preds = %1806, %1756
  %1758 = load i32* %k, align 4
  %1759 = load i32* %NumOutput, align 4
  %1760 = icmp sle i32 %1758, %1759
  br i1 %1760, label %1761, label %1809

; <label>:1761                                    ; preds = %1757
  %1762 = load i32* %k, align 4
  %1763 = sext i32 %1762 to i64
  %1764 = load i32* %p, align 4
  %1765 = sext i32 %1764 to i64
  %1766 = getelementptr inbounds [2 x double]* %192, i64 %1765
  %1767 = getelementptr inbounds [2 x double]* %1766, i32 0, i64 %1763
  %1768 = load double* %1767, align 8
  %1769 = load float* %min, align 4
  %1770 = fpext float %1769 to double
  %1771 = fcmp olt double %1768, %1770
  br i1 %1771, label %1772, label %1783

; <label>:1772                                    ; preds = %1761
  %1773 = load i32* %k, align 4
  %1774 = sext i32 %1773 to i64
  %1775 = load i32* %p, align 4
  %1776 = sext i32 %1775 to i64
  %1777 = getelementptr inbounds [2 x double]* %192, i64 %1776
  %1778 = getelementptr inbounds [2 x double]* %1777, i32 0, i64 %1774
  %1779 = load double* %1778, align 8
  %1780 = fptrunc double %1779 to float
  store float %1780, float* %min, align 4
  %1781 = load i32* %p, align 4
  %1782 = mul nsw i32 16, %1781
  store i32 %1782, i32* %tile, align 4
  br label %1783

; <label>:1783                                    ; preds = %1772, %1761
  %1784 = load i32* %k, align 4
  %1785 = sext i32 %1784 to i64
  %1786 = load i32* %p, align 4
  %1787 = sext i32 %1786 to i64
  %1788 = getelementptr inbounds [2 x double]* %29, i64 %1787
  %1789 = getelementptr inbounds [2 x double]* %1788, i32 0, i64 %1785
  %1790 = load double* %1789, align 8
  %1791 = load float* %min1, align 4
  %1792 = fpext float %1791 to double
  %1793 = fcmp olt double %1790, %1792
  br i1 %1793, label %1794, label %1805

; <label>:1794                                    ; preds = %1783
  %1795 = load i32* %k, align 4
  %1796 = sext i32 %1795 to i64
  %1797 = load i32* %p, align 4
  %1798 = sext i32 %1797 to i64
  %1799 = getelementptr inbounds [2 x double]* %29, i64 %1798
  %1800 = getelementptr inbounds [2 x double]* %1799, i32 0, i64 %1796
  %1801 = load double* %1800, align 8
  %1802 = fptrunc double %1801 to float
  store float %1802, float* %min1, align 4
  %1803 = load i32* %p, align 4
  %1804 = mul nsw i32 16, %1803
  store i32 %1804, i32* %tile1, align 4
  br label %1805

; <label>:1805                                    ; preds = %1794, %1783
  br label %1806

; <label>:1806                                    ; preds = %1805
  %1807 = load i32* %k, align 4
  %1808 = add nsw i32 %1807, 1
  store i32 %1808, i32* %k, align 4
  br label %1757

; <label>:1809                                    ; preds = %1757
  br label %1810

; <label>:1810                                    ; preds = %1809
  %1811 = load i32* %p, align 4
  %1812 = add nsw i32 %1811, 1
  store i32 %1812, i32* %p, align 4
  br label %1753

; <label>:1813                                    ; preds = %1753
  %1814 = load i32* %tile1, align 4
  %1815 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([25 x i8]* @.str4, i32 0, i32 0), i32 %1814)
  %1816 = load i32* %tile, align 4
  %1817 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([25 x i8]* @.str5, i32 0, i32 0), i32 %1816)
  br label %1818

; <label>:1818                                    ; preds = %1813, %1749
  %1819 = load i8** %8
  call void @llvm.stackrestore(i8* %1819)
  ret void
}

; Function Attrs: nounwind
declare i8* @llvm.stacksave() #1

declare i32 @printf(i8*, ...) #2

; Function Attrs: nounwind
declare void @llvm.stackrestore(i8*) #1

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind }
attributes #2 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"clang version 3.5.0 (tags/RELEASE_350/final)"}
