javac -source 1.7 -target 1.7 src\main\java\com\scrtwpns\Mixbox.java -d build && copy src\main\resources\com\scrtwpns\mixbox_lut.dat build\com\scrtwpns && jar -cvf mixbox.jar -C build .
