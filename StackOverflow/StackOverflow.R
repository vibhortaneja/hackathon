library(tidyverse)
library(boot)
library
stackOverflow <- read_csv("C:\\Users\\VIBHOR TANEJA\\Desktop\\hackathon\\StackOverflow\\Data\\survey_results_public.csv")
stackOverflow1 <- read_csv("C:\\Users\\VIBHOR TANEJA\\Desktop\\hackathon\\StackOverflow\\File_converstion_for_stack_problem\\req.csv")

DF=sqldf('select country, count(*) from stackOverflow group by Country')
ggplot(DF, aes(x=DF$Country,y= DF$`count(*)`)) + geom_point() + labs(title="Frequency bar chart")

DF1=sqldf('select HaveWorkedLanguage, count(*) from stackOverflow1 where HaveWorkedLanguage != "NA" group by HaveWorkedLanguage')

ggplot(DF1, aes(x=HaveWorkedLanguage,y=DF1$`count(*)`)) + geom_point() + labs(title="Frequency of languages")

# Looking at the vars in question:
head(stackOverflow)
summary(stackOverflow$Salary)
summary(stackOverflow$JobSatisfaction)

has_salary <- stackOverflow %>%
  filter(Salary != "NA") %>%
  filter(JobSatisfaction != "NA")
dim(has_salary)
unique(has_salary$JobSatisfaction)   # just a quick head check
# linear model to predict Job Satisfaction by Salary
model <- glm(JobSatisfaction ~ Salary, data = has_salary , family = "poisson")
model

glm.diag.plots(model)

# log(0) is never a good idea.
has_salary2 <- has_salary %>%
  mutate(logsalary = (Salary+1)**2)

logmodel <- glm(JobSatisfaction ~ logsalary, data = has_salary2 , family = "gaussian")
glm.diag.plots(logmodel)

ggplot(has_salary, aes(Salary)) + geom_histogram(color="#667ea5", fill= "#9ec2ff")

# why are these people making so little?
# perhaps it's employment status:
low_salaries <- has_salary %>% 
  filter(Salary < 25000) %>% 
  group_by(EmploymentStatus)
ggplot(low_salaries, aes(Salary, fill=EmploymentStatus)) + 
  geom_histogram(color="green4", lwd=0.25)

# perhaps it's currency:

by_country <- low_salaries %>%
  add_count(Country) %>%
  arrange(desc(n)) %>%
  filter(n > 60)
head(unique(by_country$n), n=10)


ggplot(by_country, aes(Salary)) + 
  geom_histogram(fill = "#a55200", color= "#4f2700") + 
  facet_wrap(~Country)

america <- has_salary %>%
  filter(Country == "United States")
head(america)

AmericaModel <- glm(JobSatisfaction ~ Salary, data = america , family = "gaussian")
glm.diag.plots(AmericaModel)

ggplot(america, aes(x=Salary, y = JobSatisfaction)) + 
  geom_jitter()

# middle america
middle_america <- america %>%
  filter(Salary > 50000 && Salary < 150000) %>%
  mutate(LogSalary = log(Salary))
MiddleAmericaModel <- glm(JobSatisfaction ~ Salary, data = middle_america , family = "gaussian")
ggplot(middle_america, aes(Salary, fill=EmploymentStatus)) + 
  geom_histogram(color="green4", lwd=0.25)

glm.diag.plots(MiddleAmericaModel)

ggplot(middle_america, aes(x = Salary, y = JobSatisfaction)) + # draw a 
  geom_point() + # add points
  geom_smooth(method = "glm", # plot a regression...
              method.args = list(family = "gaussian")) # ...from the binomial family
