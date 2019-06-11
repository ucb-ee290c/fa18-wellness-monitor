#!/usr/bin/env bash
# Load the seizure detection modules from src/main/scala/seizureDetection*
# Also load the corresponding test environment from src/test/scala/seizureDetection*
# For Adel use
# Use with caution, it overwrites some important files 

# From the stash folders, put the files in the main directory

machine=0
if [ "$(uname)" == "Darwin" ]; then
	machine=1
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
	machine=2
fi


if [ $# -eq 0 ]; then
	echo "No arguments provided! Should be either 'logistic, 'svm', 'rf', 'nn', or 'gen'"
elif [ $machine = 0 ]; then
	echo "Machine not identified!"
else
	check=0
	if [ $1 = "logistic" ]; then
		check=1
		cp src/main/scala/biocasAdel/seizureDetectionLogistic/* src/main/scala/
		cp src/test/scala/biocasAdel/seizureDetectionLogistic/* src/test/scala/
	elif [ $1 = "rf" ]; then
		check=1
		cp src/main/scala/biocasAdel/seizureDetectionRF/* src/main/scala/
		cp src/test/scala/biocasAdel/seizureDetectionRF/* src/test/scala/
	elif [ $1 = "nn" ]; then
		check=1
		cp src/main/scala/biocasAdel/seizureDetectionNN/* src/main/scala/
		cp src/test/scala/biocasAdel/seizureDetectionNN/* src/test/scala/
	elif [ $1 = "svm" ]; then
		check=1
		cp src/main/scala/biocasAdel/seizureDetectionSVM/* src/main/scala/
		cp src/test/scala/biocasAdel/seizureDetectionSVM/* src/test/scala/
	elif [ $1 = "gen" ]; then
		cp src/main/scala/previousWellnessGenLogistic/* src/main/scala

		if [ -f "src/main/scala/Wellness.scala" ]; then
			rm src/main/scala/Wellness.scala
		fi
		
		FILE=src/main/scala/ConfigurationMemory.scala
		tail -n +2 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		if [ $machine = 1 ]; then
			ghead -n -1 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		else
			head -n -1 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		fi

		FILE=src/main/scala/Main.scala
		tail -n +2 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		if [ $machine = 1 ]; then
			ghead -n -1 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		else
			head -n -1 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		fi

		FILE=src/main/scala/WellnessGen.scala
		tail -n +2 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		if [ $machine = 1 ]; then
			ghead -n -1 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		else
			head -n -1 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		fi

		FILE=src/main/scala/WellnessParams.scala
		tail -n +2 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		if [ $machine = 1 ]; then
			ghead -n -1 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		else
			head -n -1 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		fi

		cp src/test/scala/previousWellnessGenLogistic/* src/test/scala

		if [ -f "src/test/scala/WellnessIntegrationSpec.scala" ]; then
			rm src/test/scala/WellnessIntegrationSpec.scala
			rm src/test/scala/WellnessIntegrationTester.scala
		fi

		FILE=src/test/scala/ConfigurationMemorySpec.scala
		tail -n +2 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		if [ $machine = 1 ]; then
			ghead -n -1 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		else
			head -n -1 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		fi

		FILE=src/test/scala/ConfigurationMemoryTester.scala
		tail -n +2 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		if [ $machine = 1 ]; then
			ghead -n -1 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		else
			head -n -1 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		fi

		FILE=src/test/scala/WellnessGenIntegrationSpec.scala
		tail -n +2 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		if [ $machine = 1 ]; then
			ghead -n -1 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		else
			head -n -1 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		fi

		FILE=src/test/scala/WellnessGenIntegrationTester.scala
		tail -n +2 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		if [ $machine = 1 ]; then
			ghead -n -1 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		else
			head -n -1 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		fi

		echo "Reverted to Generator config"
	else
		echo "Wrong arguments given! Should be either 'logistic', 'svm', 'rf', 'nn', or 'gen'"
	fi

	if [ $check = 1 ]; then
		# If ConfigurationMemory testers are present, delete it
		if [ -f "src/test/scala/ConfigurationMemorySpec.scala" ]; then
			rm src/test/scala/ConfigurationMemory*
		fi

		# If WellnessGen exists, delete it
		if [ -f "src/test/scala/WellnessGenIntegrationSpec.scala" ]; then
			rm src/test/scala/WellnessGen*
			rm src/main/scala/WellnessGen.scala
		fi

		# Now remove the 1st and last lines of added files, to uncomment the blocks
		FILE=src/main/scala/ConfigurationMemory.scala
		tail -n +2 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		if [ $machine = 1 ]; then
			ghead -n -1 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		else
			head -n -1 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		fi

		FILE=src/main/scala/Main.scala
		tail -n +2 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		if [ $machine = 1 ]; then
			ghead -n -1 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		else
			head -n -1 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		fi

		FILE=src/main/scala/Wellness.scala
		tail -n +2 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		if [ $machine = 1 ]; then
			ghead -n -1 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		else
			head -n -1 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		fi

		FILE=src/main/scala/WellnessParams.scala
		tail -n +2 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		if [ $machine = 1 ]; then
			ghead -n -1 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		else
			head -n -1 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		fi

		FILE=src/test/scala/WellnessIntegrationSpec.scala
		tail -n +2 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		if [ $machine = 1 ]; then
			ghead -n -1 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		else
			head -n -1 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		fi

		FILE=src/test/scala/WellnessIntegrationTester.scala
		tail -n +2 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		if [ $machine = 1 ]; then
			ghead -n -1 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		else
			head -n -1 "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
		fi

		echo "Done replacing files, check it out"
	fi
fi

