#!
rm -rf provider.framework
rm -rf ~/workspace/ios/kofero-app/provider.framework
rm -rf ~/workspace/ios/kofero-app/presenter.framework
cp -R build/provider/Build/Products/Debug-iphonesimulator/provider.framework provider.framework
cp -R presenter.framework ~/workspace/ios/kofero-app/presenter.framework
mv provider.framework ~/workspace/ios/kofero-app/provider.framework
