/*** HELP START ***//*

Program Name    : ads_compare.sas
 Description     : Macro to compare SAS datasets between main and sub libraries.
                   It generates PDF reports for each dataset, checks differences using 
                   PROC COMPARE, and outputs a summary report in Excel format.

 Macro Name      : %ads_compare
 
 Main Functions  :
   - Iteratively compares a list of target datasets between two libraries.
   - Creates a unique output folder using date and time.
   - Generates PROC COMPARE reports as PDF files.
   - Automatically renames the result files to indicate "OK" or "NG" compare-match status.
   - Aggregates comparison results into a summary dataset.
   - Exports the summary as an Excel file.

 Parameters      :
   output_folder : Full path to the folder where output files will be saved.
   main_lib_path : Path to the main library containing the original ADaM datasets.
   sub_lib_path  : Path to the sub library containing the comparison ADaM datasets.
   target_list   : Space-delimited list of dataset names to compare.

 Author          : Yutaka Morioka


 Dependencies    : Requires SAS/BASE, SAS/ACCESS, and ODS PDF.

 Usage Example   :
   %ads_compare(
     output_folder = D:/project/output,
     main_lib_path = D:/project/main,
     sub_lib_path  = D:/project/sub,
     target_list   = A
                        B
                        C
                        D
                        E
   );

License : MIT

*//*** HELP END ***/

%macro ads_compare(
output_folder = ,
main_lib_path =,
sub_lib_path  = ,
target_list =
);

%if %length(&output_folder) eq 0 %then %do;
    %put ERROR:output_folder is Null;
    %goto eoflabel ;
  %end;
  %else %if  %length(&main_lib_path) eq 0  %then %do;
    %put ERROR:main_lib_path is Null;
    %goto eoflabel ;
  %end;
  %else %if %length(&sub_lib_path) eq 0 %then %do;
    %put ERROR: sub_lib_path is null ;
    %goto eoflabel ;
  %end;
  %else %if %length(&target_list) eq 0 %then %do;
    %put ERROR:ctarget_list is Null;
    %goto eoflabel ;
  %end;

proc delete data=all;
run;
proc delete data=temp;
run;

%let target_list=%sysfunc(compbl(&target_list));
%put &=target_list;

data _null_ ;
    length date $20. ;
    date = compress(put(date(),yymmdd10.),"-") ;
    call symputx("date",date) ;
    time = substr(compress(put(time(),tod5.),"-/ :"),1,4);
    call symputx("time",time) ;
  run ;

  %let make_nam =&date&time;  
 libname main_lib "&main_lib_path";
 libname sub_lib "&sub_lib_path";

 option fmtsearch = (main_lib sub_lib WORK) ;

 %let rc=%sysfunc(dcreate(&make_nam., &output_folder.));

%macro dscomp(DS) ;
 %let rc=%sysfunc(dcreate(&make_nam., &output_folder.));

ods noresults;
options orientation=portrait;
title "[sas dataset] : MAIN.&ds vs Sub.&ds";

%local sysinfo1 sysinfo2;
%let sysinfo1=9999;
%let sysinfo2=9999;

%let rc=%sysfunc(dcreate(&make_nam., &output_folder.));

%** Processing when a data set has not been created;
%if %sysfunc(exist(main_lib.&DS.)) ne 1  %then %do;
  %put WARNING:Main.&DS. dose not exist;
  ods pdf file="&output_folder/&make_nam./NG__&ds..pdf" startpage=never ;
    ods pdf text="Main: &ds. dose not exist";
  ods pdf close;
%end;
%if %sysfunc(exist(sub_lib.&DS.)) ne 1  %then %do;
  %put WARNING:Sub.&DS. dose not exist;
  ods pdf file="&output_folder/&make_nam./NG__&ds..pdf" startpage=never ;
    ods pdf text="Sub: &ds. dose not exist";
  ods pdf close;
%end;

%** Compare;
%if %sysfunc(exist(main_lib.&DS.)) eq 1 and %sysfunc(exist(sub_lib.&DS.)) eq 1  %then %do;
  %*make report file;
  ods pdf file="&output_folder/&make_nam./NG__&ds..pdf" startpage=never ;
    %* main sas vs sub sas ;
    ods listing;
      proc compare data = main_lib.&DS. compare = sub_lib.&DS. listall  ;
      run ;
    %put &=sysinfo;
    %let sysinfo1 = &sysinfo.;
    %put &=sysinfo1;
   ods pdf close;

%** File Rename NG->OK if match.;
  %if &sysinfo1 eq 0 %then %do;
  data _null_;
    rc=rename("&output_folder./&make_nam./NG__&ds..pdf",
              "&output_folder./&make_nam./OK__&ds..pdf", 'file');
  run;
  %end;

%end;

options noxwait noxsync;
%sysexec"start &output_folder./&make_nam";

data temp;
length name $50. main sub code 8.;
name="&ds";
 main=%sysfunc(exist(main_lib.&DS.));
 sub=%sysfunc(exist(sub_lib.&DS.));
 if main=1 and sub=1 then code=&sysinfo1.;
run;

proc append base=all data=temp force;
run;

title;

%mend dscomp ;

proc  printto print  = "&output_folder./&make_nam./&make_nam.Compare.lst"   new;
run;

/*execution*/
data _null_;
target_list="&target_list ";
i=1;
target="dummy";
do while(^missing(target));
 target=scan(target_list,i," ");
 put target= ;
 if ^missing(target) then do;
    call symputx(cats("target",i),target);
    call symputx("count",i);
 end;
 i = i+1;
end;
run;

%do i = 1 %to &count;
  %dscomp(&&target&i);
%end;

proc printto; run;

data summary ;
  length name $200 res $20 message $1000 ;
  set all ;
if code=0 then res="Perfect Match";
else res="Unmatch";
if code ne . then do;
 if band(code,1)=1 then mes1="[Data set labels differ]";
 if band(code,2)=2 then mes2="[Data set types differ]";
 if band(code,4)=4 then mes3="[Variable has different informat]";
 if band(code,8)=8 then mes4="[Variable has different format]";
 if band(code,16)=16 then mes5="[Variable has different length]";
 if band(code,32)=32 then mes6="[Variable has different label]";
 if band(code,64)=64 then mes7="[Main data set has observation not in Sub]";
 if band(code,128)=128 then mes8="[Sub data set has observation not in Main]";
 if band(code,256)=256 then mes9="[Main data set has BY group not in Sub]";
 if band(code,512)=512 then mes10="[Sub data set has BY group not in Main]";
 if band(code,1024)=1024 then mes11="[Base data set has variable not in comparison]";
 if band(code,2048)=2048 then mes12="[Comparison data set has variable not in base]";
 if band(code,4096)=4096 then mes13="[A value comparison was unequal]";
 if band(code,8192)=8192 then mes14="[Conflicting variable types]";
 if band(code,16384)=16384 then mes15="[BY variables do not match]";
 if band(code,32768)=32768 then mes16="[Fatal error: comparison not done]";
end;
 if main=0 then mes17="[Main does not exist]";
 if sub=0 then mes18="[Sub does not exist]";
 message=cats(of mes:);
 keep name res message;
run;

proc export data=summary dbms=excel file="&output_folder./&make_nam./__Compare_Status_Summary_&date.T&time..xlsx" label  replace;
run;

%eoflabel:

%mend ads_compare;
