# polynomial-regression


We provide a polynomial regression model for biochemical parameters prediction.
The prediction model includes:
(1)	Spearman’s correlation
(2)	Multicollinearity diagnose
(3)	Linear/non-linear determination
(4)	Degree selection
(5)	Adjusted R-squared calculation

The example input files are in the data folder, including photoacoustic/optical imaging features and photoacoustic/optical biochemical blood parameters. Please execute config.R first to determine the path. Then execute polynomial.R to analyze the data. Finally, we output the result.txt in results folder, which include the information of biochemical parameters, model, R-squared, adjusted R-squared and F-statistic p-value.
