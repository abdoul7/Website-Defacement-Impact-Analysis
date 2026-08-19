# ================================
# SET WORKING DIRECTORY
# ================================
getwd()
setwd("C:/Users/LENOVO-PC/OneDrive - Asia Pacific University of Technology And Innovation (APU)/3rd sem/PFDA/R_assign")

# ================================
# LOAD REQUIRED LIBRARIES
# ================================
library(dplyr)
library(stringr)
library(readr)
library(lubridate)

# ================================
# READ TAB-DELIMITED TXT FILE
# ================================
df <- read_delim(
  "HackingData_Part3.txt",
  delim = "\t",
  na = c("", "NA", "NULL", "Unknown", "UNKNOWN"),
  trim_ws = TRUE
)

# ================================
# BASIC CHECKS
# ================================
head(df)
colnames(df)
nrow(df)
str(df)

# ================================
# DATA TYPE CONVERSIONS
# ================================
df$Date <- dmy(df$Date)
df$DownTime <- as.integer(df$DownTime)
df$Ransom <- as.numeric(df$Ransom)
df$Loss   <- as.numeric(df$Loss)

str(df[c("Date", "DownTime", "Ransom", "Loss")])

# ================================
# FIX ENCODING & TRIM WHITESPACE
# ================================
df <- df %>%
  mutate(
    Notify    = str_trim(iconv(Notify, from = "", to = "UTF-8")),
    URL       = str_trim(iconv(URL, from = "", to = "UTF-8")),
    IP        = str_trim(iconv(IP, from = "", to = "UTF-8")),
    Country   = str_trim(iconv(Country, from = "", to = "UTF-8")),
    WebServer = str_trim(iconv(WebServer, from = "", to = "UTF-8")),
    Encoding  = str_trim(iconv(Encoding, from = "", to = "UTF-8"))
  )

# ================================
# STANDARDIZE COUNTRY NAMES
# ================================
df <- df %>%
  mutate(Country = str_to_title(Country))

# ================================
# REMOVE DUPLICATE ROWS
# ================================
df <- df %>% distinct()
nrow(df)

# ================================
# CHECK MISSING VALUES
# ================================
colSums(is.na(df))

# ================================
# HANDLE MISSING VALUES
# ================================
df <- df %>%
  mutate(
    Notify    = ifelse(is.na(Notify), "Unknown", Notify),
    URL       = ifelse(is.na(URL), "Unknown", URL),
    Country   = ifelse(is.na(Country), "Unknown", Country),
    IP        = ifelse(is.na(IP), "Not Available", IP),
    WebServer = ifelse(is.na(WebServer), "Not Available", WebServer),
    Encoding  = ifelse(is.na(Encoding), "Unknown", Encoding),
    Ransom    = ifelse(is.na(Ransom), 0, Ransom)
  )

# Fill missing Loss with median
median_loss <- median(df$Loss, na.rm = TRUE)
df <- df %>%
  mutate(Loss = ifelse(is.na(Loss), median_loss, Loss))

# ✅ Fill missing DownTime with median
median_downtime <- median(df$DownTime, na.rm = TRUE)
df <- df %>%
  mutate(DownTime = ifelse(is.na(DownTime), median_downtime, DownTime))

# ================================
# HANDLE INVALID (NEGATIVE) VALUES
# ================================
df <- df %>%
  mutate(
    Ransom   = ifelse(Ransom < 0, 0, Ransom),
    DownTime = ifelse(DownTime < 0, 0, DownTime),
    Loss     = ifelse(Loss < 0, 0, Loss)
  )

summary(df$Ransom)
summary(df$DownTime)
summary(df$Loss)

# ================================
# OUTLIER TREATMENT (IQR - WINSORIZATION)
# ================================
Q1 <- quantile(df$Loss, 0.25)
Q3 <- quantile(df$Loss, 0.75)
IQR_val <- Q3 - Q1

lower_limit <- Q1 - 1.5 * IQR_val
upper_limit <- Q3 + 1.5 * IQR_val

df <- df %>%
  mutate(
    Loss = ifelse(Loss > upper_limit, upper_limit, Loss),
    Loss = ifelse(Loss < lower_limit, lower_limit, Loss)
  )

# ================================
# OUTLIER TREATMENT FOR RANSOM
# ================================
Q1_r <- quantile(df$Ransom, 0.25)
Q3_r <- quantile(df$Ransom, 0.75)
IQR_r <- Q3_r - Q1_r

lower_r <- Q1_r - 1.5 * IQR_r
upper_r <- Q3_r + 1.5 * IQR_r

df <- df %>%
  mutate(
    Ransom = ifelse(Ransom > upper_r, upper_r, Ransom),
    Ransom = ifelse(Ransom < lower_r, lower_r, Ransom)
  )


# ================================
# FINAL CHECKS
# ================================
colSums(is.na(df))
str(df)
summary(df)

# ================================
# SAVE CLEANED DATA TO TXT FILE
# ================================
write_delim(
  df,
  "HackingData_Part3_Cleaned.csv",
  delim = "\t"
)
