
*  import delimited "C:\Users\Utilisateur\Documents\StageLiepp\données\dico_var.csv", varnames(1) encoding(windows-


qui count
local n = r(N)
qui compress

file open var_label  using label.do, write replace

file write `handle' "*** This file was created by VarLabels.do" _n
file write `handle' `"*** on `= c(current_date)' at `= c(current_time)'. "' _n
file write `handle' "*** " _n
file write `handle' "********************************************** " _n
file write `handle' _n
file write `handle' _n


forvalues x = 1/`n' {
    file write `handle' "capture label variable `=VarName[`x']' \`"
    file write `handle' `"" `=VarLabel[`x']' ""'
    file write `handle' "'" _n
}

file close C:\Users\Utilisateur\Documents\StageLiepp\données\dico_var.csv