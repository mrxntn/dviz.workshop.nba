# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# DataVizR-Workshop (NBA-version) // Dr. Anton K. G. Marx @ LMU Munich [anton.marx@psy.lmu.de]

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Quick Introduction

#

# What is data visualization?

# Wikipedia.com: 
# Data visualization deals with the graphic represention of data to efficiently to 
# communicate information. [https://en.wikipedia.org/wiki/Data_visualization]


# Techopedia.com: 
# Data visualization is the process of displaying data/information in graphical charts, 
# figures and bars. [https://www.techopedia.com/definition/30180/data-visualization]

#

# Goals of data visualization?

# Goal 1
# Explaining complicated processes more easily. 

# Goal 2
# Explaining complicated results more easily. 

# Goal 3
# Displaying exploratory data analysis. 

#

# Types of data visualizations? [https://www.r-graph-gallery.com/ & https://www.data-to-viz.com]

# Distribution of variables (e.g. histogram)

# Relation between variables (e.g. scatter plots)

# Ranking according to variables (e.g. bar plots)

# Composition of groups (e.g. pie charts)

# Development over time (e.g. time series)

# Geospatial data (e.g. maps)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# wd
my.wd <- "/Users/amx/data_local/R/DataVizR" # change to your working directory
setwd(my.wd)

# packages
#install.packages("ggplot2")
library(ggplot2)

# disable scientific notation
options(scipen=999) 

# sources:
# https://r-graphics.org
# https://ggplot2.tidyverse.org/
# https://www.r-graph-gallery.com/ggplot2-package.html
# https://www.statmethods.net/advgraphs/ggplot2.html
# https://www.stat.auckland.ac.nz/~paul/RG2e/

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# DATASET ####

# nba data = season 2015/2016
# https://github.com/AddisonGauss/NbaData2015-2016/blob/master/NBApoints.csv

#data.nba <- read.csv(url("https://raw.githubusercontent.com/AddisonGauss/NbaData2015-2016/master/NBApoints.csv"))
#data.nba<-data.nba[!(data.nba$Pos == "PF-C" | data.nba$Pos == "SG-SF"),] # delete rows = PF-C and SG-SF

# LINK TO DATA DEPRECATED !!!

# new data
data.nba <- read.csv(url("https://raw.githubusercontent.com/sivabalanb/Data-Analysis-with-Pandas-and-Python/master/nba.csv"))

# delete last row
data.nba <- head(data.nba, - 1)

str(data.nba)
head(data.nba)
View(data.nba)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# DISTRIBUTION ####

# histogram
plot.hist <- ggplot(data.nba, # dataset nba
                    aes(x = Age)) + # variable x = age of the players over all teams
  geom_histogram(bins = 15, # number of bins
                 color = "black") # color of lines
plot.hist

# faceted histogram
plot.hist + facet_grid(Position ~ .)

# dotplots
plot.dots <- ggplot(data.nba, # dataset nba
                    aes(x = Age)) + # variable x = age of the players over all teams
  geom_dotplot(binwidth = 0.25,
               color = "black") # color of lines
plot.dots

# faceted dotplots
plot.dots + facet_grid(Position ~ .)

# density
plot.dens <- ggplot(data.nba, 
                    aes(x = Age)) + # variable x = age of the players over all teams
  geom_density(fill = "darkgrey") # color of curve
plot.dens

# density, color by group
plot.dens <- ggplot(data.nba, 
                    aes(x = Age, # variable x = age of the players over all teams
                        color = Position, # grouping variable = position of players
                        fill = Position, 
                        alpha = .05)) + # transparency
  geom_density()
plot.dens

# boxplot
plot.box <- ggplot(data.nba,
                   aes(x = Position, # grouping variable = position of players
                       y = Age)) + # variable y = age of the players over all teams
  geom_boxplot()
plot.box

# violin
plot.vio <- ggplot(data.nba,
                   aes(x = Position, # grouping variable = position of players
                       y = Age, # variable y = age of the players over all teams
                       fill = Position,
                       alpha = .1)) +
  geom_violin()
plot.vio

# violin-box-plot
plot.vio + 
  geom_boxplot(fill = "white", # add bloxplot to violin plot
               alpha = .1)

# ridgeline
# https://www.rdocumentation.org/packages/ggjoy/versions/0.3.0/topics/geom_ridgeline
#install.packages("ggridges")
library(ggridges)

plot.ridge <- ggplot(data.nba,
                     aes(x = Weight, # variable x = weight
                         y = Position, # grouping variable = position
                         fill = Position, # color fill according to positions
                         alpha = .5)) +
  geom_density_ridges(stat="binline", # histogram
                      bins=15) +
  theme_classic() +
  theme(legend.position = "bottom")
plot.ridge

# waffle
# https://paulvanderlaken.com/2019/01/25/visualization-innovation-waffleplots-and-swarmplots-aka-beeplots/
#install.packages("waffle")
library(waffle)

waffle.data <- table(data.nba$Position) # create contingency table
waffle.data

plot.waf <- waffle(waffle.data, # variable = position
                   rows = 15,
                   legend_pos = "bottom")
plot.waf

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# RELATION ####

# scatter plot: basic
plot.scat <- ggplot(data.nba, 
                    aes(x = Age, # age
                        y = Weight)) + # weight
  geom_point()
plot.scat

# scatter plot: color by group
plot.scat <- ggplot(data.nba, 
                    aes(x = Age, 
                        y = Weight,
                        fill = Position,
                        color = Position)) + 
  geom_point()
plot.scat

# scatter plot: color by group, large transparent jittered dots
plot.scat <- ggplot(data.nba, 
                    aes(x = Age, 
                        y = Weight,
                        fill = Position,
                        color = Position)) + 
  geom_jitter(size = 4, # jittered dots to avoid overplotting,
              width = .5,
              height = .5,
              alpha = .4)
plot.scat

# scatter plot: color by group, large transparent jittered dots, trend line
plot.scat <- ggplot(data.nba, 
                    aes(x = Age, 
                        y = Weight,
                        fill = Position,
                        color = Position)) + 
  geom_jitter(size = 4, # jittered dots to avoid overplotting,
              width = .5,
              height = .5,
              alpha = .4) +
  geom_smooth(method=lm , color="black", fill="darkgrey", se=FALSE) # trend line
plot.scat

# faceted scatter plot
# http://www.sthda.com/english/wiki/ggplot2-facet-split-a-plot-into-a-matrix-of-panels

plot.scat + facet_grid(Position ~ .)

# heat map
plot.tile <- ggplot(data.nba, 
                    aes(x = Team, # teams
                        y = Position, # positions
                        fill = Weight)) + # age of players
  geom_tile()
plot.tile

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# THEMES ####

# base ggplot themes
plot.scat + 
  theme_bw()

plot.scat + 
  theme_classic()

plot.scat + 
  theme_minimal()

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# COLORS ####

# https://www.datanovia.com/en/blog/top-r-color-palettes-to-know-for-great-data-visualization/

# color palettes
#install.packages("RColorBrewer")
library(RColorBrewer)

# viridis
#install.packages("viridis")
library(viridis)

# ggsci
#install.packages("ggsci")
library(ggsci)

# wesanderson
#install.packages("wesanderson")
library(wesanderson)

# r base colors

# colorspace
#install.packages("colorspace")
library(colorspace)
#hcl_palettes()
#sequential_hcl(5)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ADVANCED PLOTS ####

# boxplot with jittered dots
plot.box <- ggplot(data.nba,
                   aes(x = Position,
                       y = Weight,
                       color = Position,
                       fill = Position)) +
  
  geom_boxplot(alpha = .3) +
  
  geom_jitter(color = "black",
              size = 3, 
              alpha = 0.3,
              width = 0.1,
              height = 0.2) +
  
  scale_color_viridis(discrete = TRUE, option = "D") +
  scale_fill_viridis(discrete = TRUE, option = "D") +
  
  theme_bw() +
  theme(legend.position = "bottom",
        axis.ticks = element_blank())

plot.box

# scatter plot: color by group, large transparent jittered dots, marginal density plots
#install.packages("ggExtra")
library(ggExtra) # function ggMarginal()

plot.scat <- ggplot(data.nba, 
                    aes(x = Age, 
                        y = Weight,
                        fill = Position,
                        color = Position)) + 
  geom_jitter(size = 4, # jittered dots to avoid overplotting
              alpha = .7,
              width = .5,
              height = .5)  + 
  theme_bw() +
  theme(legend.position = "bottom",
        axis.ticks = element_blank()) +
  scale_fill_brewer(palette = "Set3") +
  scale_color_brewer(palette = "Set3") +
  geom_smooth(method=lm , color="grey10", fill="darkgrey", se=TRUE)
plot.scat

plot.scat.marg <- ggMarginal(plot.scat, 
                             type="density",
                             size = 5,
                             alpha = .6,
                             groupColour = TRUE,
                             groupFill = TRUE)
plot.scat.marg

# ... marginal histograms
plot.scat <- ggplot(data.nba, 
                    aes(x = Weight, 
                        y = Salary,
                        fill = Position,
                        color = Position)) + 
  geom_jitter(size = 4, # jittered dots to avoid overplotting
              alpha = .7,
              width = .5,
              height = .5)  + 
  geom_rug() +
  theme_bw() +
  theme(legend.position = "bottom",
        axis.ticks = element_blank()) +
  scale_fill_brewer(palette = "Set2") +
  scale_color_brewer(palette = "Set2") +
  geom_smooth(method=lm , color="grey10", fill="darkgrey", se=TRUE)

plot.scat.marg <- ggMarginal(plot.scat, 
                             type="histogram",
                             size = 5,
                             alpha = .6,
                             color = "white")
plot.scat.marg

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# END

