# Getting list of modules:
cd Modules
folders=$(ls -d */)
cd ..
echo $folders

# Printing modules list:
foldersArray=($folders)
echo "Modules found: ${foldersArray[@]}"

# Calling formatter in each package:
cd Modules
for value in "${foldersArray[@]}"
do
	echo "---------"
	echo "🚀 Processing: $value"
	cd $value
	swift package plugin --allow-writing-to-package-directory swiftformat
	echo "🎉🎉🎉 Done with: $value"
    cd ..
done
echo "---------"
cd ..
