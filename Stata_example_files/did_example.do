// Load in data
clear all
use "data/score_zoom.dta", clear

// Manually compute difference-in-differences estimator, 
// DiD = (Y_treat_post − Y_treat_pre) − (Y_ctrl_post − Y_ctrl_pre)

// 1. Confirm treatment and time indicators
tab zoom
tab exam2

// 2. Compute group means
summ score if zoom==1 & exam2==1
scalar mean_treat_post = r(mean)

summ score if zoom==1 & exam2==0
scalar mean_treat_pre = r(mean)

summ score if zoom==0 & exam2==1
scalar mean_ctrl_post = r(mean)

summ score if zoom==0 & exam2==0
scalar mean_ctrl_pre = r(mean)

// 3. Calculate Diff-in-Diff estimator
scalar diff_in_diff = (mean_treat_post - mean_treat_pre) - (mean_ctrl_post - mean_ctrl_pre)
display "Manually created Diff-in-Diff estimator: " diff_in_diff

// ***Compare results to Stata's regression with interaction term***
// 4. Difference-in-differences regression
reg score i.zoom##i.exam2
display "Interaction coefficient (i.zoom#i.exam2) is Stata's DiD estimator."
