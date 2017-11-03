library(SoilR, quietly=T)

## Munge data
totalC_t0 <- 7.7         # not included in data, so hard code here
t0 <- 0
N_t <- 25                # calculated by inspection
ts <- eCO2[1:25,2]
eCO2mean <- eCO2[1:25,3] 
eCO2sd <- eCO2[1:25,4]

## Plot data
library(ggplot2,quietly=TRUE)
df <- data.frame(list(ts=ts,eCO2mean=eCO2mean,eCO2sd=eCO2sd))
interval_95pct <- aes(ymin = eCO2mean + 1.96 * eCO2sd, 
                      ymax = eCO2mean - 1.96 * eCO2sd)
plot_data <- 
  ggplot(df, aes(x=ts, y=eCO2mean)) +
  geom_point() + 
  geom_errorbar(interval_95pct, width=0, colour="blue") +
  scale_x_continuous(name="time (days)") +
  scale_y_continuous(name="evolved CO2 (mgC g-1 soil)") +
  ggtitle("Evolved CO2 Measurements (with 95% intervals)")
plot(plot_data)


# Fit model
library(rstan)
fit <- stan("~/Box Sync/Work/GitHub/microbial_c_modeling/two_pool_Stan.stan",
            data=c("totalC_t0", "t0", "N_t", "ts", "eCO2mean"),
            control=list(adapt_delta=0.99, max_treedepth=15),
            chains=2, iter=1000, seed=1234)

print(fit,digits=2)

