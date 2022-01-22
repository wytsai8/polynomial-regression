# polynomial-regression

Our analysis is divided into two parts, 

- Photoacoustic/optical imaging features:

Signal analysis process by MATLAB.
The data and scripts are in the folder of “image_features”. The example input files are in the photoacoustic and optical folders, separately. The folders include signal raw data (sampleA to sampleM) and a sample list, which including all the sample names. Please change the data folder in features_main.m and execute the file. 

The result file will be generated in polynomial_regression/model/data. The name of the result file is photoacoustic_image.txt or optical_image.txt.
Please also put the corresponding file of biochemical parameters in polynomial_regression/model/data for the polynomial regression analysis.

- Polynomial regression model: 

Polynomial regression model for biochemical parameters prediction by R.
The prediction model includes:
1. Spearman’s correlation
2. Multicollinearity diagnose
3. Linear/non-linear determination
4. Degree selection
5. Adjusted R-squared calculation

The example input files are in polynomial_regression/model/data, including photoacoustic/optical imaging features (e.g. photoacoustic_image.txt) and photoacoustic/optical biochemical blood parameters (e.g. photoacoustic_biochemical.txt). Please execute config.R first to determine the path. Then change the name of the data files in polynomial.R (“input_file_biochemical” and “input_file_image”) and execute polynomial.R to analyze the data. Finally, we output the result.txt in polynomial_regression/model/results, which include the information of biochemical parameters, model, R-squared, adjusted R-squared and F-statistic p-value.
