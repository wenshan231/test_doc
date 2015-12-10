cd E:\DVB\bat\compile_bat
if not exist filelist.txt (
echo there is no filelist!
goto out_err
)


:out_err
k:
