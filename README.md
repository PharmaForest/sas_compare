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

<img width="610" height="327" alt="Image" src="https://github.com/user-attachments/assets/fad14b03-4467-4c2e-884f-2695d45146e1" />


<img width="1208" height="198" alt="Image" src="https://github.com/user-attachments/assets/e69b95dd-cea5-4249-b600-9e1143b65074" />


<img width="470" height="857" alt="Image" src="https://github.com/user-attachments/assets/da9e0b28-4269-42bc-8ee9-08a41c985e53" />


# What is SAS Packages?
The package is built on top of **SAS Packages framework(SPF)** created by Bartosz Jablonski.<br>
For more on SAS Packages framework, see [SASPAC](https://github.com/yabwon/SAS_PACKAGES).<br>
You can also find more SAS Packages(SASPAC) in [GitHub](https://github.com/SASPAC)<br>


# How to use SAS Packages Framework(SPF)? (quick start)
Create directory for your packages and assign a fileref to it.
~~~sas      
filename packages "\path\to\your\packages";
~~~
Enable the SAS Packages Framework (if you have not done it yet):

~~~sas      
%include packages(SPFinit.sas)
~~~
(If you don't have SAS Packages Framework installed follow the instruction.)

You can learn from the following training materials by Bartosz Jablonski for source files and folders structure of SAS packages.<br>
[My first SAS Package -a How To](https://github.com/yabwon/SAS_PACKAGES/blob/main/SPF/Documentation/SAS(r)%20packages%20-%20the%20way%20to%20share%20(a%20how%20to)-%20Paper%204725-2020%20-%20extended.pdf).<br>
[SAS Packages - The Way To Share (a How To)](https://github.com/yabwon/SAS_PACKAGES/blob/main/SPF/Documentation/SAS(r)%20packages%20-%20the%20way%20to%20share%20(a%20how%20to)-%20Paper%204725-2020%20-%20extended.pdf)

