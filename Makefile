default:
	./gradlew generateGrammarSource
	mkdir -p build && cd build; cmake .. && make
	./build/test/TEST

clean:
	[[ -d build ]] && rm -r build || true;
	[[ -d dist ]] && rm -r dist || true;

release:
	./gradlew generateGrammarSource
	mkdir -p build && cd build; cmake -DCMAKE_BUILD_TYPE=Release .. && make
