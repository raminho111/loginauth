SDK = iphoneos
ARCH = arm64
OUTPUT = libramoss4m.dylib

all:
	xcrun -sdk $(SDK) clang -dynamiclib -arch $(ARCH) \
		-fobjc-arc \
		-framework UIKit \
		-framework Foundation \
		src/main.m src/Ramoss4mLogin.m -o $(OUTPUT) \
		-Wall -Wextra -Wno-deprecated-declarations
