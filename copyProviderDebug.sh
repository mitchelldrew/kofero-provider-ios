#!
rm -rf provider.framework
rm -rf ~/workspace/ios/kofero-app/provider.framework
cp -R build/provider/Build/Products/Debug-iphonesimulator/provider.framework provider.framework
mv provider.framework ~/workspace/ios/kofero-app/provider.framework