# sas_compare
Compares SDTM/ADaM, TLF datasets, etc. Assume a double program in the pharmaceutical industry to compare main and sub

<img width="350" height="350" alt="Image" src="https://github.com/user-attachments/assets/317afaaf-f856-4e82-9ae1-9f54f7f86890" />

# %ads_compare
 
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


## What is SAS Packages?  
The package is built on top of **SAS Packages framework(SPF)** developed by Bartosz Jablonski.  
For more information about SAS Packages framework, see [SAS_PACKAGES](https://github.com/yabwon/SAS_PACKAGES).  
You can also find more SAS Packages(SASPACs) in [SASPAC](https://github.com/SASPAC).

## How to use SAS Packages? (quick start)
### 1. Set-up SPF(SAS Packages Framework)
Firstly, create directory for your packages and assign a fileref to it.
~~~sas      
filename packages "\path\to\your\packages";
~~~
Secondly, enable the SAS Packages Framework.  
(If you don't have SAS Packages Framework installed, follow the instruction in [SPF documentation](https://github.com/yabwon/SAS_PACKAGES/tree/main/SPF/Documentation) to install SAS Packages Framework.)  
~~~sas      
%include packages(SPFinit.sas)
~~~  
### 2. Install SAS package  
Install SAS package you want to use using %installPackage() in SPFinit.sas.
~~~sas      
%installPackage(packagename, sourcePath=\github\path\for\packagename)
~~~
(e.g. %installPackage(ABC, sourcePath=https://github.com/XXXXX/ABC/raw/main/))  
### 3. Load SAS package  
Load SAS package you want to use using %loadPackage() in SPFinit.sas.
~~~sas      
%loadPackage(packagename)
~~~
### Enjoy😁

