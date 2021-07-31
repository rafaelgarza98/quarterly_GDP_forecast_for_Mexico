# quarterly_GDP_forecast_for_Mexico
R analysis for the GDP from México  using an ARMA (Autoregressive–moving-average model) 
Forecast published by INEGI on July 15

## Definition:
gross domestic product (GDP) is an economic indicator that aims to measure
the growth of the value of all the goods and services of a country at a certain time.

## Comment (Data from 01/01/1986 to 07/30/2021):
From my personal perspective and information in the media we have planned
a rate hike for inflation in our country, all this thanks to the reopening of different
industries that were closed due to the health contingency (increasing prices due to the rise in
consumers who little by little return to the trade) and also because in recent months the rate
vaccination in Mexico has been growing, so it will also help accelerate the reactivation
economical

## variables used in the model
Data window (sample): The time window analyzed includes January 1, 1986
to June 30, 2021. The frequency of the data is quarterly and was obtained from INEGI and the
FRED (Federal Reserve Economic Data). The variables used were the price of crude oil: West
Texas Intermediate (WTI), manufacturing production, energy production and imports
American merchandise from Mexico.

1. Dependent variable: PIB
2. Independent variables: 
- Manufacturing production
- Energy production
- imports
- WTI

## Statistical report

### Unit Root Test and Series Transformation
The unit root test of Phillips-Perron was used in this model, which uses analysis of time series
to test the null hypothesis of a time series of order 1. In the test performed,
i observed how no test except for energy production fell within the p-value of
0.05, which led me to conclude that the null hypothesis cannot be rejected and that it does not show
stable behavior. In the case of the energy production variable, we treat it with the first
difference.

### Model identification with the stationary series
Based on the autocorrelation and partial autocorrelation functions, it was determined that the:
- series a) (GDP)  was of type AR (6) with adjustment of the “fixed” tool to eliminate garbage variables from the
model.
- Series b) (Manufacturing production) was an RA (1)
- series c) (Energy production) a RA (12) with “fixed” 
- series d) (wti) did not require any changes.

###  Model estimation
the p-value of the GDP variables tell us that imports and WTI do not
are significant at 5% error, so that in the elaboration of another model they could not be taken into account
consideration of these variables. In relation to the parameters of GDP, industrial production,
energy production and imports were found to be significant.

### Diagnosis of the model
In this section we proceeded to corroborate compliance with the assumptions, that is, to know what
so different is the empirical probability function of our residuals with the normal curve
standard, in the cases presented there is an excellent match between the normal distribution and the function of
probability of our residuals, since there are very few outliers. Besides, the
The autocorrelation of the residuals was practically zero and the null hypothesis was rejected in the
Ljung-Box in all cases

## forecast
Consistent with our forecast, the growth rate for the second quarter of the
GDP is 0.7282%

## Stress test
The test showed us that our model (ARMAX) has on average an error level of 23.34 and is
better than the Arima model that is made up of an AR (1) and an MA (1), whose level of error
average is 39.92.


