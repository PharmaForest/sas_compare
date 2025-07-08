# sas_compare
Compares SDTM/ADaM, TLF datasets, etc. Assume a double program in the pharmaceutical industry to compare main and sub

![sas_compare](./sas_compare_small.png)  

#%ads_compare
 
 Main Functions  :
   - Iteratively compares a list of target datasets between two libraries.
   - Creates a unique output folder using date and time.
   - Generates PROC COMPARE reports as PDF files.
   - Automatically renames the result files to indicate "OK" or "NG" compare-match status.
   - Aggregates comparison results into a summary dataset.
   - Exports the summary as an Excel file.

 Parameters      :
 ~~~text
   output_folder : Full path to the folder where output files will be saved.
   main_lib_path : Path to the main library containing the original ADaM datasets.
   sub_lib_path  : Path to the sub library containing the comparison ADaM datasets.
   target_list   : Space-delimited list of dataset names to compare.
~~~

 Usage Example   :
 ~~~sas      
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
~~~
