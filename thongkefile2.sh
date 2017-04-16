#!/bin/bash
unset path i psize pname ptime f a pdv ten
tong=0
csize=0
m=0
echo -e "chuong trinh liet ke file"
#nguoi dung nhap duong dan
until [ -d "$path" ]
do
    read -e -p "xin moi nhap duong dan den thu muc liet ke: " path
done
#vong lap kiem tra va so sanh, ket qua la cac' bien va mang se dc liet ke
IFS_old="$IFS"
IFS='
'
for i in `ls -lSrh $path|grep ^-`
do
    psize="`echo $i | awk '{print $5}'`"
    ptime="`echo $i | awk '{print $8}'`"
    pname="`echo ${i##*$ptime }`"
    pso="${psize:0: -1}"
    pdv="${psize: -1}"
    if [[ "$pdv" == [0-9] ]] || ( [ "$pdv" == "K" ] && [ ${pso%,*} -le 4 ] ) #kiem tra dung luong file <= 4KB
    then
        continue
    elif [ "$psize" != "$csize" ] #kiem tra co xuat hien dung luong moi
    then
        tong=$(($tong+1))
	psize1="${psize/./_}"
        mang[m]="file$psize1"
        eval "file$psize1[0]='$pname'"
        n=0
        m=$(($m+1))
        csize=$psize
    else
        tong=$(($tong+1))
	n=$(($n+1))
        psize1="${psize/./_}"
        eval "file$psize1[$n]='$pname'"
    fi
done
IFS="$IFS_old"
f=$((${#mang[@]}-1)) #index lon nhat cua mang
echo "co tat ca $tong file co dung luong >4K"
for a in `eval echo {0..$f}`
do
	ten="${mang[a]#file}"
	eval soluong=\${#${mang[a]}[@]}
        echo "dung luong ${ten/_/.} co tat ca $soluong file"
        eval echo \${${mang[a]}[@]}
done
