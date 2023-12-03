mkdir -p work
iverilog -o work/my_design -c ../file_list.txt
cd work
vvp my_tesign