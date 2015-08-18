#!/bin/bash

function display_logo(){
	echo "===================================="
	echo "           cmakeGenerator           "
	echo "===================================="
}

function create_directory(){
	echo "...creating directory $1"
	mkdir $1
}

function create_file(){
	echo "...creating file $1"
	touch $1
}

function read_project_name(){
	while [[ true ]]; do
		echo -n "Insert project name: " 
		read project_name

		if [[ -z "$project_name" ]]; then
			echo "Project name should be at least 1 character long!"
		else
			break
		fi
	done
}

function git_init(){
	cd ${project_name}
	git init
	git add -A
	git commit -m "init"
	cd ..
}

function main_prog(){
	display_logo
	echo ""
	read_project_name

	create_directory "$project_name"
	create_directory "$project_name/src"
	create_directory "$project_name/include"
	create_directory "$project_name/tests"
	create_directory "$project_name/docs"
	create_directory "$project_name/build"
	create_file "$project_name/readme.txt"

	create_file "$project_name/CMakeLists.txt"
	cat <<-EOT >> "$project_name/CMakeLists.txt"
	cmake_minimum_required(VERSION 2.8)
	project($project_name)

	include_directories(\${${project_name}_SOURCE_DIR}/include)

	add_executable($project_name src/main.cpp)

	EOT

	create_file "$project_name/.gitignore"
	cat <<-EOT >> "$project_name/.gitignore"
	build/
	EOT

	create_file "$project_name/src/main.cpp"
	cat <<-EOT >> "$project_name/src/main.cpp"
	#include<iostream>

	int main(){
		std::cout << "Hello world" << std::endl;

		return 0;
	}
	EOT

	create_file "$project_name/build.sh"
	cat <<-EOT >> "$project_name/build.sh"
	#!/bin/bash
	cd build
	cmake ..
	make
	cd ..
	EOT
	chmod +x "$project_name/build.sh"

	git_init

}


main_prog
