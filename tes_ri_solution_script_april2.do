// Load in data
clear all
import delimited "/Users/elijahweston-capulong/Desktop/ACADEMICS/Tufts/Spring 2025/TES_RI/tes_ri_april2.csv", clear

// Manually compute covariance and correlation coefficient, 
// r = cov_xy / (sd_x * sd_y)

// 1. Get means
egen mean_x = mean(avg_nba_ppg)
egen mean_y = mean(gdp_capita)

// 2. Compute deviations
gen dev_x = avg_nba_ppg - mean_x
gen dev_y = gdp_capita - mean_y

// 3. Compute covariance and correlation coefficient
gen dev_xy = dev_x * dev_y
gen dev_x2 = dev_x^2
gen dev_y2 = dev_y^2

egen cov_xy = mean(dev_xy)
egen var_x = mean(dev_x2)
egen var_y = mean(dev_y2)

gen sd_x = sqrt(var_x)
gen sd_y = sqrt(var_y)

gen corr_coeff = cov_xy / (sd_x * sd_y)
display "Manually created correlation coefficient: " corr_coeff

// ***Compare results to Stata's corr command***
corr avg_nba_ppg gdp_capita

// 4. Compute regression coefficients
gen beta_1 = cov_xy / var_x
gen beta_0 = mean_y - beta_1 * mean_x

// 5. Compute line-of-best-fit
gen yhat = beta_0 + beta_1 * avg_nba_ppg

// **Compare results with Stata's reg command**
reg gdp_capita avg_nba_ppg

// 6. Create scatter plot with line-of-best-fit and Stata's reg line
twoway (scatter gdp_capita avg_nba_ppg, ///
        mcolor(blue) ///
        msize(medium)) ///
       (line yhat avg_nba_ppg, ///
        lcolor(red) lwidth(thick) lpattern(dash)) ///
       (lfit gdp_capita avg_nba_ppg, ///
        lcolor(black) lwidth(medium) lpattern(solid)), ///
       title("Manual vs Stata Regression Line") ///
       legend(order(1 "Data Points" 2 "Manual Regression" 3 "Stata Regression"))
	   
// 7. Control for year
regress gdp_capita avg_nba_ppg year



