# Introduction
My first LabVIEW projects served as an introduction to the LabVIEW programming language, literally walking through step by step on .vi creation of increasing complexity.  

Since I know the LabVIEW language already, I've decided to combine all of these projects into the solution of one new problem, without the step by step guide originally provided. 

# Problem Statement
Many of us spend 40+ hours each week at our jobs. When you spend that much time somewhere, there's eventually going to be something you may not want to do, such as taking out the trash or sitting through another "coulda-been-an-email" meeting. Sometimes, the hardest part about not wanting to do something, is finding the motivation to do it anyway. That's where our LabVIEW programming knowledge can come in!  

The task for this Project is to create a LabVIEW .vi that, for a given income and task duration, calculates how much a client is paid to do the task. This should pave the way for the ideal user experience, (example):  
"Ugh I really don't want to write this email"  
\*calculates information on our patent not pending .vi\*  
"$11 for 30 minutes?" "Shoot, I'd write this email for $11, guess I'll get on it" 

## Requirements
- Must be calculable for both hourly and salary Employees
- Assume all salary employees work 40 hours a week
- Must be able to toggle for hours worked each week and overtime percentage if applicable
- Salary Employees are not eligible for Overtime pay ;(
- Money Calculations are all done pre-tax
- The .vi must run continuously, users should only have to hit "run" one time until they close the application
- Any invalid values should be reported as errors, but not crash the .vi

# Development
Development incomplete or in-progress, stay tuned!

# Testing
LabVIEW technically CAN be automated with inputs and outputs and run as a part of a larger test suite, however setting up an ATS for these few LabVIEW projects may be a tad excessive.  
  
Instead I have provided the table below with key test cases to test against. Feel free to download the executable and try them out for yourself!  
  
| Example Task | Task Duration (Hours) | Overtime Duration (Hours) | Compensation Model | Compensation Rate (USD) | Overtime Rate | Expected Result (USD) | Test Case |
|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:|
| Early morning meeting | 1 | 0 | Hourly | 15 | 1.5x | 15.00 | Hourly can be positively calculated |  
| Required Training | 4 | 0 | Salary | 45,000 | N/A | 86.54 | Salary can be positively calculated |  
| Writing an Email | 0.5 | 0.5 | Hourly | 12 | 1.5x | 9.00 | Hourly Overtime can be positively calculated |  
| Important Phone Call | 1.75 | 0.75 | Hourly | 13.50 | 1.275x | 26.41 | Hybrid Hourly Overtime can be positively calculated |  
| Customer Escalation | 5.33 | 5.33 | Salary | 100,000 | 300x | 256.25 | Validate OT pay does not apply to salary (Standard) |  
| Troubleshooting technology problems | 0.99 | 0.67 | Salary | 68,000 | 1.22x | 32.37 | Validate OT pay does not apply to salary (Hybrid) |  
| Checking the Mailbox | 0.33 | 0.11 | Hourly | 0.00 | 2.25x | 0.00 | Zero pay edge case (hourly) |  
| That last hour before 5pm | 1 | 0 | Salary | 0.00 | N/A | 0.00 | Zero pay edge case (salary) |  
| Running Important Tests | 0 | 0 | Hourly | 7.25 | 1.33x | 0.00 | Zero hour edge case (hourly) |  
| Giving a difficult presentation | 0 | 0 | Salary | 35,000 | N/A | 0.00 | Zero hour edge case (salary) |  
| Traveling back in time to meet deadlines | 5 | 7 | Hourly | 35 | 200x | -1 | Error, Overtime duration exceeds task duration (hourly) |  
| Rushing to make up lost time scrolling | 9.334 | 102.3 | Salary | 135,000 | N/A | -1 | Error, Overtime duration exceeds task duration (salary) |  
