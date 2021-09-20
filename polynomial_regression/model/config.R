# This is the configuration script with all folder paths and general settings

get_os_sep <- function () {
  # Gettting operating system (os) depending dictionary seperator
  os_name <- Sys.info()["sysname"]
  if (os_name == "Linux") {
    sep <- '/'
  } else if (os_name == "Darwin") {
    sep <- '/'
  } else if (os_name == "Windows") {
    sep <- '\\\\'
  } else {
    sep <- '/'
  }
  return(sep)
}

get_project_folder <- function () {
  # Get project folder using getwd. Remove scripts if exists
  folder_project <- getwd()
  list_path <- strsplit(folder_project, os_sep)[[1]]
  last_dir <- tail(list_path, n=1)
  if(last_dir == "model") {
    folder_project <- unlist(strsplit(folder_project, split="model"))
  } else {
    folder_project <- paste0(folder_project)
  }
  return(folder_project)
}


os_sep <- get_os_sep()
folder_project <- get_project_folder()
folder_data <- paste0(folder_project, "/data")
#folder_scripts <- paste0(folder_project, "/scripts")
folder_results <- paste0(folder_project, "/results")



