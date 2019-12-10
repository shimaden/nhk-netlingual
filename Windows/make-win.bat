del /s /q system
rmdir system
del *.mp3
del nhk-netlingual.exe nhk-netlingual.rb program-list.conf
copy ..\nhk-netlingual.rb .
copy ..\program-list.conf .
neri nhk-netlingual.rb program-list.conf cacert.pem
