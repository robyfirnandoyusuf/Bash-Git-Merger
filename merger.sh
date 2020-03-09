#!/bin/bash
#==============================================================================
#title           :Bash Merger
#author		 	 :Nando - GreyCat - ExploreOurBrain
#usage		 	 :./merger.sh
#==============================================================================

list_branches(){
	myArray=()
	eval "$(git for-each-ref --shell --format='branches+=(%(refname))' refs/remotes/)"
	x=0  

	printf '%s\n%s------------------- %s\n'
	for branch in "${branches[@]}"; do
		cok=$(echo $branch | awk '{gsub("refs/remotes/",""); print}')
		myArray+=($cok)
		echo "[$x]" $cok
		y=$((x++))
	done
}

merge_brach(){
	list_branches
	read -p "Merge branch destination ? : " destination

	fixDestination=${myArray[$destination]##*\/}
	if [[ $from != $fixDestination ]]; then
		echo $(git checkout $fixDestination)
	fi

	read -p "Merge $fixDestination with which branch ? : " to
	s=${myArray[$to]}
	sourceBranch="${s##*/}"

	pull=$(git pull origin $sourceBranch)

	if [[ $pull == *"Already"* ]]; then
		echo "Everything is up to date !"
	elif [[ $pull == *"CONFLICT"* ]]; then
		echo "Something Conflict, Fix then I Suggest you do it Git command manually"
	else
		read -p "Do you want push it ? (y/n) : " cpush
		if [ "$cpush" != "${cpush#[Yy]}" ] ;then
			x=0
			for branch in "${myArray[@]}"; do
				cok=$(echo $branch | awk '{gsub("refs/remotes/",""); print}')
				myArray+=($cok)
				echo "[$x]" $cok
				y=$((x++))
			done
			read -p "Push Branch To : " pushTo

			branchRemoteDest=${myArray[$pushTo]}
			remoteDestBranch="${branchRemoteDest##*/}"
			echo $(git push origin $remoteDestBranch)
		else
			echo "-- ./logout --"
		fi
	fi
}

printf '%s\n%s'
SWITCH="\033["
NORMAL="${SWITCH}0m"
YELLOW="${SWITCH}1;33m"

echo -e "Current Branch :"${YELLOW} $(git rev-parse --abbrev-ref HEAD) ${NORMAL}

printf '%s\n%s'
echo "[1] Merge Branch"

read -p "Option : " cmd
from=$(git rev-parse --abbrev-ref HEAD)

case $cmd in
     1)
		merge_brach
      	;;
esac
