library(stats)
library("Metrics")
library("Hmisc")  # sudo dnf install libjpeg-turbo-devel
library(here)
library(semEff)
library(caret)
library(gvlma)
require(car)

input_file_biochemical = "optical_biochemical.txt" #"photoacoustic_biochemical.txt" "optical_biochemical.txt"
input_file_image = "optical_image.txt" #"photoacoustic_image.txt"  "optical_image.txt"
conf <- import::here("config.R")

folder_in <- paste0(conf$folder_data, "/")

if (file.exists(paste0(folder_results,"/", "model_result.txt")) == "TRUE")
{
  file.remove(paste0(folder_results,"/", "model_result.txt"))
}

file_function <- function(file1,file2)
{
  data_1 <- read.table(paste0(folder_in, file1),header=TRUE)
  data_2 <- read.table(paste0(folder_in, file2),header=TRUE)
  data_3 = cbind(data_1,data_2)
  return(data_3)
}

biochemical_function <- function(file1)
{
  data_1 <- read.table(paste0(folder_in, file1),header=TRUE)
  bio_count = dim(data_1)
  return(bio_count[2])
}

Spearman_function <- function(feature_file_1,b_count)
{
  res2 <- rcorr(as.matrix(feature_file_1), type="spearman")
  res2_r = as.data.frame(res2$r)
  res2_p = as.data.frame(res2$P)

  feature_count = dim(res2_r)
  feature_coun_1 = feature_count[1]
  
  bio_name_tmp=matrix(nrow=b_count,ncol=b_count)
  b=1
  for(p in 1:b_count)
  {
    bio_name=0
    image_name=0
    a=1
    b_count1 = b_count+1
    for(k in b_count1:feature_coun_1)
    {
      if (abs(res2_r[p,k]) >= 0.5)
      {
        if (is.na(res2_p[p,k]) == "FALSE")
        {
          if(res2_p[p,k] < 0.05)
          {
            image_name[a] = names(res2_p[k])
            a=a+1
          }
        }
      }
    }
    if(image_name != 0)
    {
      bio_name = names(res2_p[p])
      bio_name_tmp[b,1] =bio_name
      bio_name_tmp[b,2] =a-1
      a_tmp = a-1
      for(b1 in 1:a_tmp)
      {
        bio_name_tmp[b,b1+2] = image_name[b1]
      }
      b=b+1
    }
  }
  return(bio_name_tmp)
}

linear_model_function <- function(spearman_m,feature_file_1)
{
  model_tmp=dim(spearman_m)
  linear_tmp=matrix(nrow=model_tmp[1],ncol=3)
  for(c in 1:model_tmp[1])
  {
    if(is.na(spearman_m[c,1]) == FALSE)
    {
      model = paste0(spearman_m[c,1],"~")
      linear_tmp[c,1] = spearman_m[c,1]
      linear_tmp[c,2] = spearman_m[c,2]
      for(d in 3:model_tmp[2])
      {
        if(is.na(spearman_m[c,d]) == FALSE)
        {
          d1 = as.integer(spearman_m[c,2])
          d2 = d1+2
          if(d == d2) # in the end
          {
            model=paste0(model,"poly(",spearman_m[c,d],",1,raw=TRUE)")
          }
          else
          {
            model=paste0(model,"poly(",spearman_m[c,d],",1,raw=TRUE)+")
          }
        }
      }
      linear_tmp[c,3] = model 
    }
  }
  return(linear_tmp)
}

VIF_function <- function(linear_model,feature_file_1)
{
  model_count = dim(linear_model)
  linear_tmp_1=matrix(nrow=model_count[1],ncol=3)
  for(i in 1:model_count[1])
  {
    if(is.na(linear_model[i,1]) == FALSE)
    {
      tmp = as.integer(linear_model[i,2])
      model_1 = as.formula(linear_model[i,3])
      if(tmp>1) #need VIF
      {
        model_linear = lm(model_1,data=feature_file_1)
        VIF_result = as.data.frame(car::vif(model_linear))
        MAX_VIF = max(VIF_result$'car::vif(model_linear)')
        MAX_VIF_1 = as.numeric(MAX_VIF)
        print(model_1)
        while(MAX_VIF_1 > 10)
        {
          for(j in 1:dim(VIF_result)[1])
          {
            VIF_tmp = as.integer(VIF_result$'car::vif(model_linear)'[j])
            max_tmp = as.integer(MAX_VIF)
            if(VIF_tmp == max_tmp)
            {
              max_name = row.names(VIF_result)[j]
              model_2 = as.character(model_1)
              bio = model_2[2]
              model_3 =  unlist(strsplit(model_2[3],"\\+"))
              model_4 = model_3[-j]
              model_5 = paste0(bio,"~",model_4[1])
              if(length(model_4) != 1)
              {
                for(k in 2:length(model_4))
                {
                  model_5 = paste(model_5,model_4[k],sep="+")
                }
              }
            }
          }
          if(length(model_4) == 1)
          {
            tmp = 1
            model_1 = as.formula(model_5)
            break
          }
          
          tmp = length(model_4)
          model_6 = as.formula(model_5)
          model_linear = lm(model_6,data=feature_file_1)
          VIF_result = as.data.frame(car::vif(model_linear))
          MAX_VIF = max(VIF_result$'car::vif(model_linear)')
          MAX_VIF_1 = as.numeric(MAX_VIF)
          model_1 = model_6
          
        }
        linear_tmp_1[i,1] = linear_model[i,1]
        linear_tmp_1[i,2] = tmp
        linear_tmp_1[i,3] = as.character(model_1)[3]
      }
      else
      {
        linear_tmp_1[i,1] = linear_model[i,1]
        linear_tmp_1[i,2] = tmp
        linear_tmp_1[i,3] = as.character(model_1)[3]
      }
    }
  }
  return(linear_tmp_1)
}

linear_determine_function <- function(VIF_result,feature_file_1)
{
  count = dim(VIF_result)
  linear_tmp_1=matrix(nrow=count[1],ncol=3)
  for(i in 1:count[1])
  {
    bio_name = VIF_result[i,1]
    num = VIF_result[i,2]
    feature=0
    if(is.na(VIF_result[i,1]) == FALSE) 
    {
      feature =  unlist(strsplit(VIF_result[i,3],"\\+"))
      model_tmp = paste0(bio_name,"~")
      for(j in 1:length(feature))
      {
        model = paste0(bio_name,"~",feature[j])
        model_1 = as.formula(model)
        model_2 = lm(model_1,data=feature_file_1)
        result = gvlma(model_2)
        result1 = durbinWatsonTest(model_2)
        result2 = as.numeric(result1$p) 
        if((result$GlobalTest$GlobalStat4$Decision == "1") || (result$GlobalTest$DirectionalStat1$Decision == "1")
           || (result$GlobalTest$DirectionalStat2$Decision == "1") || (result$GlobalTest$DirectionalStat3$Decision == "1")
           ||¡@(result$GlobalTest$DirectionalStat4$Decision == "1") || (result2 < 0.05))
        {
          feature[j] = sub(feature[j],pattern=", 1,",replacement=",2,")  # non-linear
        }
        if(j == 1)
        {
          model_tmp = paste(model_tmp,feature[1])
        }
        else
        {
          model_tmp = paste(model_tmp,feature[j],sep="+") 
        }
      }
      linear_tmp_1[i,1] = bio_name
      linear_tmp_1[i,2] = num
      linear_tmp_1[i,3] = model_tmp
    }
  }
  return(linear_tmp_1)
}

degree_determine_function <- function(linear_determine,feature_file_1)
{
  count = dim(linear_determine)
  result = matrix(nrow=count[1],ncol=3)
  for(i in 1:count[1])
  {
    if(is.na(linear_determine[i,1]) == FALSE)
    {
      result[i,1] = linear_determine[i,1]
      result[i,2] = linear_determine[i,2]
      result[i,3] = linear_determine[i,3]
      if(grepl(",2,",linear_determine[i,3]) == TRUE)
      {
        formula_1 = linear_determine[i,3]
        feature =  unlist(strsplit(formula_1,"\\+"))
        count1 = length(feature)
        degree = matrix(nrow=2,ncol=count1)
        for(j in 1:count1)
        {
          if(grepl(",2,",feature[j]) == TRUE)
          {
            degree[1,j] = feature[j]
            degree[2,j] =sub(feature[j],pattern=",2,",replacement=",3,")
          }
          if(grepl(", 1,",feature[j]) == TRUE)
          {
            degree[1,j] = feature[j]
          }
        }
        degree1 = as.list(as.data.frame(degree))
        a = expand.grid(degree1)
        a1 = as.matrix(a)
        colnames(a1) <- NULL
        count_model = dim(a)
        p=1
        model_tmp1 = matrix(nrow=count_model[1],ncol=2)
        for(m in 1:count_model[1])
        {
          all_count=0
          if(is.na(a1[m,1]) == FALSE)
          {
            model_tmp=a1[m,1]
            if(as.numeric(count_model[2]) >1)
            {
             for(n in 2:count_model[2])
             {
              if(is.na(a1[m,n]) == FALSE)
              {
                model_tmp = paste(model_tmp,a1[m,n],sep="+")
                all_count = all_count+1
              }
             }
             if(all_count == as.numeric(count_model[2])-1)
             {
              model_tmp1[p,1] = model_tmp
              model_tmp2 = as.formula(model_tmp)
              model_tmp3 = lm(model_tmp2,data=feature_file_1)
              model_tmp1[p,2] = BIC(model_tmp3)
              p=p+1
             }
            }
            else
            {
              model_tmp1[p,1] = model_tmp
              model_tmp2 = as.formula(model_tmp)
              model_tmp3 = lm(model_tmp2,data=feature_file_1)
              model_tmp1[p,2] = BIC(model_tmp3)
              p=p+1
            }
          }
        }
        print(model_tmp1)
        tmp_count = dim(model_tmp1)
        min_BIC = min(as.numeric(model_tmp1[,2]),na.rm = TRUE)
        print(min_BIC)
        for(q in 1:tmp_count[1])
        {
          if(is.na(model_tmp1[q,2])==FALSE)
          {
           if(as.numeric(model_tmp1[q,2]) == as.numeric(min_BIC))
           {
            result[i,3] = model_tmp1[q,1]
           }
          }
        }
      }
    }
  }
  return(result)
}

Rsquared_function <- function(degree_determine,feature_file_1)
{
  count = dim(degree_determine)
  result = matrix(nrow=count[1],ncol=5)
  for(i in 1:count[1])
  {
    if(is.na(degree_determine[i,1]) == FALSE)
    {
      model_1 = as.formula(degree_determine[i,3])
      model_2 = lm(model_1,data=feature_file_1)
      model_r = summary(model_2)
      model_r1 = model_r$r.squared
      model_r2 = model_r$adj.r.squared
      F_pvalue = pf(model_r$fstatistic[1],model_r$fstatistic[2],model_r$fstatistic[3],
                    lower.tail = FALSE)
      BIC_final = BIC(model_2)
      
      result[i,1] = degree_determine[i,1]
      result[i,2] = degree_determine[i,3]
      result[i,3] = model_r1
      result[i,4] = model_r2
      result[i,5] = F_pvalue
     # result[i,6] = BIC_final
    }
  }
  colnames(result) = c("biomedical","model","R-squared","adjusted_R-squared","F-statistic_p-value")
  write.table(result, file = paste0(folder_results,"/", "results.txt"), sep = "\t", 
                          col.names = colnames(result),row.names = FALSE,quote=FALSE)
  return(result)
}

feature_file=file_function(input_file_biochemical,input_file_image)
bio_count=biochemical_function(input_file_biochemical)
spearman_m=Spearman_function(feature_file,bio_count)
linear_model=linear_model_function(spearman_m,feature_file)
VIF_result=VIF_function(linear_model,feature_file)
linear_determine=linear_determine_function(VIF_result,feature_file)
degree_determine=degree_determine_function(linear_determine,feature_file)
Rsquared=Rsquared_function(degree_determine,feature_file)